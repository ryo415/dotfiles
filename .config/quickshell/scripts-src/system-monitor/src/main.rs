use std::env;
use std::fs;
use std::io::{self, BufWriter, Write};
use std::path::PathBuf;
use std::thread;
use std::time::Duration;

const DEFAULT_INTERVAL_SECONDS: f64 = 2.0;

#[derive(Clone, Copy)]
struct CpuSample {
    idle: u64,
    total: u64,
}

fn parse_interval() -> Duration {
    let mut args = env::args().skip(1);

    while let Some(argument) = args.next() {
        if argument == "--interval"
            && let Some(value) = args.next()
            && let Ok(seconds) = value.parse::<f64>()
            && seconds.is_finite()
            && seconds > 0.0
        {
            return Duration::from_secs_f64(seconds);
        }
    }

    Duration::from_secs_f64(DEFAULT_INTERVAL_SECONDS)
}

fn read_cpu_sample() -> Option<CpuSample> {
    let stat = fs::read_to_string("/proc/stat").ok()?;
    let cpu_line = stat.lines().find(|line| line.starts_with("cpu "))?;
    let values: Vec<u64> = cpu_line
        .split_whitespace()
        .skip(1)
        .take(8)
        .map(str::parse)
        .collect::<Result<_, _>>()
        .ok()?;

    if values.len() < 5 {
        return None;
    }

    Some(CpuSample {
        idle: values[3].saturating_add(values[4]),
        total: values.iter().copied().sum(),
    })
}

fn cpu_usage(previous: Option<CpuSample>, current: Option<CpuSample>) -> f64 {
    let (Some(previous), Some(current)) = (previous, current) else {
        return 0.0;
    };

    let total_delta = current.total.saturating_sub(previous.total);
    if total_delta == 0 {
        return 0.0;
    }

    let idle_delta = current.idle.saturating_sub(previous.idle).min(total_delta);
    (100.0 * (total_delta - idle_delta) as f64 / total_delta as f64).clamp(0.0, 100.0)
}

fn ram_usage() -> f64 {
    let Ok(meminfo) = fs::read_to_string("/proc/meminfo") else {
        return 0.0;
    };

    let mut total = None;
    let mut available = None;

    for line in meminfo.lines() {
        let mut fields = line.split_whitespace();
        match fields.next() {
            Some("MemTotal:") => total = fields.next().and_then(|value| value.parse::<f64>().ok()),
            Some("MemAvailable:") => {
                available = fields.next().and_then(|value| value.parse::<f64>().ok())
            }
            _ => {}
        }
    }

    match (total, available) {
        (Some(total), Some(available)) if total > 0.0 => {
            (100.0 * (1.0 - available / total)).clamp(0.0, 100.0)
        }
        _ => 0.0,
    }
}

fn temperature_paths() -> Vec<PathBuf> {
    let thermal_paths: Vec<PathBuf> = fs::read_dir("/sys/class/thermal")
        .into_iter()
        .flatten()
        .filter_map(Result::ok)
        .filter(|entry| {
            entry
                .file_name()
                .to_string_lossy()
                .starts_with("thermal_zone")
        })
        .map(|entry| entry.path().join("temp"))
        .collect();

    if !thermal_paths.is_empty() {
        return thermal_paths;
    }

    fs::read_dir("/sys/class/hwmon")
        .into_iter()
        .flatten()
        .filter_map(Result::ok)
        .filter(|entry| {
            fs::read_to_string(entry.path().join("name"))
                .is_ok_and(|name| matches!(name.trim(), "coretemp" | "k10temp" | "zenpower"))
        })
        .flat_map(|entry| {
            fs::read_dir(entry.path())
                .into_iter()
                .flatten()
                .filter_map(Result::ok)
        })
        .filter(|entry| {
            let name = entry.file_name();
            let name = name.to_string_lossy();
            name.starts_with("temp") && name.ends_with("_input")
        })
        .map(|entry| entry.path())
        .collect()
}

fn max_temperature(paths: &[PathBuf]) -> f64 {
    paths
        .iter()
        .filter_map(|path| fs::read_to_string(path).ok())
        .filter_map(|value| value.trim().parse::<f64>().ok())
        .map(|millidegrees| millidegrees / 1000.0)
        .filter(|temperature| temperature.is_finite())
        .reduce(f64::max)
        .unwrap_or(0.0)
}

fn main() -> io::Result<()> {
    let interval = parse_interval();
    let temperature_paths = temperature_paths();
    let stdout = io::stdout();
    let mut output = BufWriter::new(stdout.lock());
    let mut previous_cpu = read_cpu_sample();

    loop {
        thread::sleep(interval);

        let current_cpu = read_cpu_sample();
        let cpu = cpu_usage(previous_cpu, current_cpu);
        let ram = ram_usage();
        let temp = max_temperature(&temperature_paths);

        previous_cpu = current_cpu.or(previous_cpu);

        writeln!(
            output,
            "{{\"cpu\":{cpu:.1},\"ram\":{ram:.1},\"temp\":{temp:.1}}}"
        )?;
        output.flush()?;
    }
}
