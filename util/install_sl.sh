# Install versioned file into the host os with a symlink.
# Example:
#   install_sl "resolv.conf" /home/xyz/conf/resolv.conf /etc/resolv.conf
function install_sl() {
  local name=$1
  local src=$2
  local target=$3

  # Check if already installed.
  if [[ -h $target ]]; then
    debug "Looks like $target is already a symlink."

    # Check if the symlink is to our hosts
    link_target=$( readlink -- "$target" )
    if [[ "$link_target" = "$src" ]]; then
      info "Verified symlink install: $name"
    else
      info "Incorrect symlink detected: $target -> $link_target\n  Should be $target -> $src"
      return 1
    fi
  else
    if [[ -e $target ]]; then
      info "$target already exists, moving to $target.bak for safe keeping"
      mv $target{,.bak}
    fi

    info "Setting up link: $target -> $src" 
    ln -s $src $target
  fi
  return 0
}
