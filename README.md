# GoTTY for Open OnDemand

Launch a browser terminal on an allocated compute node. This Batch Connect app starts the user's registered login shell.

## Requirements

- Open OnDemand with Batch Connect, a configured job scheduler, and the [`/rnode` reverse proxy](https://osc.github.io/ood-documentation/latest/how-tos/app-development/interactive/view.html#reverse-proxy) enabled.
- Linux compute nodes with Bash, `getent`, and access to the [`sorenisanerd/gotty` v1.11.0 binary](https://github.com/sorenisanerd/gotty/releases/tag/v1.11.0) for their CPU architecture.

## Installation

1. Install GoTTY on the compute nodes or place it on a shared filesystem. This example installs the Linux x86-64 binary.

   ```bash
   release=https://github.com/sorenisanerd/gotty/releases/download/v1.11.0
   archive=gotty_v1.11.0_linux_amd64.tar.gz
   wget "$release/$archive"
   tar -xzf "$archive" ./gotty
   sudo install -D -m 0755 gotty /shared/apps/gotty
   ```

2. Clone the app from GitHub on the Open OnDemand server. Then configure it as described below.

   ```bash
   cd /var/www/ood/apps/sys/
   sudo git clone https://github.com/OpenOnDemandJP/ood_gotty.git
   ```
3. Launch GoTTY from **Interactive Apps**, click **Open GoTTY**, and run a command to verify the connection.

## Configuration

* `form.yml`
* `submit.yml`
* `template/script.sh`
  * Set `gotty_bin` to the executable path on compute nodes and `gotty_origin_re` to a regex that matches the public OOD origin. 

## Testing and limitations

GoTTY v1.11.0 startup and WebSocket connections were verified on Linux x86-64 and ARM64 using Slurm test jobs in an Open OnDemand 4.2.5 environment. Other schedulers and OOD versions are unverified.

GoTTY's startup message must reach the session's `output.log` on stderr. Keep the log private because it contains the session URL.

## License

[MIT](LICENSE)
