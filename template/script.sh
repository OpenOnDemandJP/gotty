#!/usr/bin/env bash
set -eu

# Edit these settings for your site.
# Set the GoTTY executable path on the compute nodes and the public OOD origin.
gotty_bin="/shared/apps/gotty"
gotty_origin_re='^https://ondemand[.]example[.]com$'

# Avoid inheriting GoTTY settings such as header forwarding or custom assets.
for gotty_env_name in "${!GOTTY_@}"; do
  unset "$gotty_env_name"
done

: "${port:?port is missing}"
# Resolve the job user's registered login shell on the compute node.
if ! account=$(getent passwd "$EUID"); then
  printf '%s\n' 'Could not find the job user in the account database.' >&2
  exit 1
fi
terminal_shell=${account##*:}
terminal_shell=${terminal_shell:-/bin/sh}
if [[ $terminal_shell != /* || ! -f $terminal_shell || ! -x $terminal_shell ]]; then
  printf '%s\n' 'Registered login shell is unavailable on this node.' >&2
  exit 1
fi
export SHELL="$terminal_shell"

gotty_config="$PWD/gotty.hcl"
cd "$HOME"

# "--config" loads the terminal font size from the session configuration.
# "--port" uses the port selected by before.sh.
# "--random-url" generates a random URL path at startup.
# "--random-url-length 32" sets the length of the random path segment.
# "--permit-write" allows browser input to the terminal.
# "--ws-origin" limits WebSocket requests to the configured OOD Origin.
# "--close-timeout 5" allows the terminal process five seconds to exit
# after the close signal before GoTTY force-kills it.
# "exec -l" starts the registered shell in login mode for each terminal connection.
exec "$gotty_bin" \
  --config "$gotty_config" \
  --port "$port" \
  --random-url \
  --random-url-length 32 \
  --permit-write \
  --ws-origin "$gotty_origin_re" \
  --close-timeout 60 \
  /bin/bash -c 'exec -l -a "${1##*/}" -- "$1"' gotty-login "$terminal_shell"

