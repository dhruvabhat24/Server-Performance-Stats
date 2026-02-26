# Linux Server Stats Script

A lightweight Bash script to quickly audit server performance. It provides a snapshot of CPU, memory, disk usage, and the top resource-heavy processes.

## Features
- **OS & Uptime:** Current version and how long the system's been running.
- **Resource Usage:** Breakdown of CPU, RAM, and Disk (Used vs Free %).
- **Process Tracking:** Lists the top 5 processes hogging CPU and Memory.
- **Security Stats:** (Optional) Shows failed SSH login attempts (requires sudo).

## How to Run
1. **Clone the repo:**
   ```bash
   git clone https://github.com/dhruvabhat24/Server-Performance-Stats.git
   ```

2.  **Make the script executable**
    ```bash
    chmod +x server-stats.sh
    ```

3. **Run it**
    ```bash
    ./server-stats.sh
    ```
