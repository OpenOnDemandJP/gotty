# GoTTY terminal for Open OnDemand

Launch a browser terminal on an allocated compute node. This Batch Connect app starts the user's registered login shell.

## Requirements

- [GoTTY](https://github.com/sorenisanerd/gotty/)
- Linux compute nodes with Bash and `getent`

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

## Configuration

* `form.yml`
* `submit.yml`
* `template/script.sh`
  * Set `gotty_bin` to the executable path on compute nodes and `gotty_origin_re` to a regex that matches the public OOD origin. 

## Testing and limitations

GoTTY v1.11.0 startup and WebSocket connections were verified on Linux x86-64 and ARM64 using Slurm test jobs in an Open OnDemand 4.2.5 environment. 

GoTTY's startup message must reach the session's `output.log` on stderr.

## Security

GoTTY uses `--random-url --random-url-length 32` to generate a 32-character secret path using a cryptographically secure random number generator. It writes the startup URL to the job's `output.log`.

`after.sh` reads the path into a shell variable. Open OnDemand saves it in `connection.yml` and uses it to build the **Open GoTTY** link through `/rnode`. The app keeps the secret out of command-line arguments and environment variables.

The URL grants access to the running terminal, so keep it, `output.log`, and `connection.yml` private. GoTTY also checks WebSocket requests against the configured Open OnDemand origin.

## License

[MIT](LICENSE)
