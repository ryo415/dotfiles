#!/usr/bin/env python3
"""Small, dependency-free collectors for the dashboard. One JSON object per run."""

import json
import os
import subprocess
import sys
import urllib.parse
import urllib.request


def network():
    interface = ""
    try:
        with open("/proc/net/route", encoding="ascii") as routes:
            for line in routes:
                fields = line.split()
                if len(fields) > 3 and fields[1] == "00000000" and int(fields[3], 16) & 1:
                    interface = fields[0]
                    break
        if not interface or "/" in interface:
            return {"connected": False}
        base = f"/sys/class/net/{interface}"
        with open(f"{base}/statistics/rx_bytes", encoding="ascii") as rx:
            received = int(rx.read())
        with open(f"{base}/statistics/tx_bytes", encoding="ascii") as tx:
            sent = int(tx.read())
        with open(f"{base}/operstate", encoding="ascii") as state:
            connected = state.read().strip() == "up"
        return {"interface": interface, "connected": connected,
                "received": received, "sent": sent}
    except (OSError, ValueError):
        return {"connected": False}


def gpu():
    try:
        result = subprocess.run([
            "nvidia-smi", "--query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu,power.draw",
            "--format=csv,noheader,nounits"], capture_output=True, text=True, timeout=4, check=True)
        fields = [part.strip() for part in result.stdout.splitlines()[0].split(",")]
        if len(fields) != 5:
            return {}
        values = [float(value) if value not in ("[N/A]", "N/A", "") else None for value in fields]
        return dict(zip(("utilization", "memoryUsed", "memoryTotal", "temperature", "power"), values))
    except (OSError, subprocess.SubprocessError, IndexError, ValueError):
        return {}


def storage():
    mounts = ["/"]
    try:
        with open("/proc/self/mounts", encoding="utf-8") as source:
            for line in source:
                fields = line.split()
                if len(fields) >= 3 and fields[2] in ("ext4", "btrfs", "xfs"):
                    path = fields[1].replace("\\040", " ")
                    if path.startswith("/mnt/") and path.count("/") == 2:
                        mounts.append(path)
    except OSError:
        pass
    output = []
    for path in dict.fromkeys(mounts):
        try:
            info = os.statvfs(path)
            total = info.f_blocks * info.f_frsize
            used = (info.f_blocks - info.f_bfree) * info.f_frsize
            if total:
                output.append({"path": path, "used": used, "total": total})
        except OSError:
            pass
    return {"mounts": output[:4]}


def services():
    try:
        docker = subprocess.run(["systemctl", "is-active", "docker.service"],
                                capture_output=True, text=True, timeout=3).stdout.strip() == "active"
    except (OSError, subprocess.SubprocessError):
        docker = False
    return {"docker": docker, "network": network().get("connected", False)}


def weather():
    lat = os.environ.get("DASHBOARD_LATITUDE", "")
    lon = os.environ.get("DASHBOARD_LONGITUDE", "")
    try:
        if not -90 <= float(lat) <= 90 or not -180 <= float(lon) <= 180:
            return {}
        params = urllib.parse.urlencode({
            "latitude": lat, "longitude": lon,
            "current": "temperature_2m,weather_code",
            "daily": "temperature_2m_max,temperature_2m_min,precipitation_probability_max",
            "forecast_days": 1, "timezone": "auto",
        })
        with urllib.request.urlopen("https://api.open-meteo.com/v1/forecast?" + params, timeout=8) as response:
            data = json.load(response)
        current, daily = data["current"], data["daily"]
        return {"temperature": current["temperature_2m"], "code": current["weather_code"],
                "high": daily["temperature_2m_max"][0], "low": daily["temperature_2m_min"][0],
                "rain": daily["precipitation_probability_max"][0]}
    except (ValueError, KeyError, IndexError, OSError):
        return {}


def uptime():
    try:
        with open("/proc/uptime", encoding="ascii") as source:
            return {"seconds": int(float(source.read().split()[0]))}
    except (OSError, ValueError, IndexError):
        return {}


COLLECTORS = {"network": network, "gpu": gpu, "storage": storage,
              "services": services, "weather": weather, "uptime": uptime}

if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] not in COLLECTORS:
        sys.exit(2)
    print(json.dumps(COLLECTORS[sys.argv[1]]()))
