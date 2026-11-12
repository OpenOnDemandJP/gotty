# GoTTY uses gotty_path. Leave OOD's standard connection password field empty.
unset gotty_path
password=''

port=$(find_port) || {
  printf '%s\n' 'Could not find an available port.' >&2
  exit 1
}
export port
