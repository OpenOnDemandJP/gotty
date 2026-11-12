# This hook is sourced in the parent shell while GoTTY is starting.
set +x
set +a
unset gotty_path gotty_log_line BASH_REMATCH
gotty_path=''

# GoTTY v1.11.0 logs: HTTP server is listening at: http://HOST:PORT/TOKEN/
# HOST may be an IPv4 address or an IPv6 address enclosed in brackets.
gotty_url_re="HTTP server is listening at: http://[^/]+:${port}/([0-9a-z]{32})/[[:space:]]*$"

# Bash builtins parse the private file; no secret URL is passed to another argv.
for ((gotty_attempt = 0; gotty_attempt < 30; gotty_attempt++)); do
  while IFS= read -r gotty_log_line; do
    if [[ $gotty_log_line =~ $gotty_url_re ]]; then
      gotty_path="/${BASH_REMATCH[1]}/"
      break
    fi
  done < "$PWD/output.log"

  [[ -n $gotty_path ]] && break
  kill -0 "$SCRIPT_PID" 2>/dev/null || break
  sleep 1
done

if [[ -z $gotty_path ]]; then
  printf '%s\n' 'GoTTY did not produce a valid startup URL. Inspect the session output.log.' >&2
  clean_up 1
fi

# Check only TCP reachability. curl with a secret URL would expose it in argv.
if ! wait_until_port_used "${host}:${port}" 30; then
  printf '%s\n' 'GoTTY did not open its listening port.' >&2
  clean_up 1
fi

# Keep gotty_path as a non-exported shell variable. OOD writes it next.
unset gotty_log_line gotty_url_re gotty_attempt BASH_REMATCH
printf '%s\n' 'GoTTY is ready.'

