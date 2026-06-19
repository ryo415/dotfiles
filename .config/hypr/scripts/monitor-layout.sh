#!/usr/bin/env bash
set -euo pipefail

DP_OUTPUT="DP-5"
HDMI_OUTPUT="HDMI-A-2"

DP_MODE="1920x1080@60.00000"
HDMI_MODE="1920x1080@60.0000"
SCALE="1"

runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
instance_signature="${HYPRLAND_INSTANCE_SIGNATURE:-}"
socket_path="${runtime_dir}/hypr/${instance_signature}/.socket2.sock"
lock_dir="${runtime_dir}/hypr-monitor-layout.lock"

if ! mkdir "$lock_dir" 2>/dev/null; then
    if [[ -r "${lock_dir}/pid" ]] && kill -0 "$(cat "${lock_dir}/pid")" 2>/dev/null; then
        exit 0
    fi

    rm -rf "$lock_dir"
    mkdir "$lock_dir"
fi

printf '%s\n' "$$" > "${lock_dir}/pid"
trap 'rm -rf "$lock_dir"' EXIT

monitor_connected() {
    hyprctl monitors -j | jq -e --arg name "$1" '.[] | select(.name == $name)' >/dev/null
}

set_workspace_monitor() {
    local workspace="$1"
    local monitor="$2"
    local default="$3"

    hyprctl keyword workspace "${workspace},monitor:${monitor},default:${default}" >/dev/null
}

apply_layout() {
    local has_dp=false
    local has_hdmi=false

    if monitor_connected "$DP_OUTPUT"; then
        has_dp=true
    fi

    if monitor_connected "$HDMI_OUTPUT"; then
        has_hdmi=true
    fi

    if [[ "$has_dp" == true && "$has_hdmi" == true ]]; then
        hyprctl keyword monitor "${DP_OUTPUT},${DP_MODE},0x0,${SCALE}" >/dev/null
        hyprctl keyword monitor "${HDMI_OUTPUT},${HDMI_MODE},1920x0,${SCALE}" >/dev/null

        for workspace in {1..5}; do
            set_workspace_monitor "$workspace" "$DP_OUTPUT" "$([[ "$workspace" == 1 ]] && echo true || echo false)"
        done

        for workspace in {6..10}; do
            set_workspace_monitor "$workspace" "$HDMI_OUTPUT" "$([[ "$workspace" == 6 ]] && echo true || echo false)"
        done
    elif [[ "$has_dp" == true ]]; then
        hyprctl keyword monitor "${DP_OUTPUT},${DP_MODE},0x0,${SCALE}" >/dev/null

        for workspace in {1..10}; do
            set_workspace_monitor "$workspace" "$DP_OUTPUT" "$([[ "$workspace" == 1 ]] && echo true || echo false)"
        done
    elif [[ "$has_hdmi" == true ]]; then
        hyprctl keyword monitor "${HDMI_OUTPUT},${HDMI_MODE},0x0,${SCALE}" >/dev/null

        for workspace in {1..10}; do
            set_workspace_monitor "$workspace" "$HDMI_OUTPUT" "$([[ "$workspace" == 1 ]] && echo true || echo false)"
        done
    else
        hyprctl keyword monitor ",preferred,auto,${SCALE}" >/dev/null
    fi
}

apply_layout || true

if [[ ! -S "$socket_path" ]]; then
    socket_path="$(find "${runtime_dir}/hypr" -mindepth 2 -maxdepth 2 -name .socket2.sock -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | cut -d' ' -f2-)"
fi

if [[ -S "$socket_path" ]]; then
    socat -U - "UNIX-CONNECT:${socket_path}" | while read -r event; do
        case "$event" in
            monitoradded*|monitorremoved*)
                sleep 0.4
                apply_layout || true
                ;;
        esac
    done
fi
