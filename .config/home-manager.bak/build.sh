#!/usr/bin/env bash
set -e

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
RESET='\033[0m'

if [ "$1" == "pull" ]
then
    echo -e "${BOLD}${YELLOW}Pulling"
    git pull &> build.log || (
      grep --color error < build.log && false
    )
    echo -e "${BOLD}${GREEN}Finished pulling"
else
    echo -e "${BOLD}${GREEN}Skipping git pull"
fi

echo -e "${BOLD}${YELLOW}Rebuilding home manager:${RESET}"
# Clear the log file
> build.log
# Run home-manager in background
home-manager switch --flake .#scott-linux &> build.log &
HM_PID=$!
# Show last 5 lines as they come in
tail -n 5 -f build.log --pid=$HM_PID 2>/dev/null || true
# Wait for home-manager to complete and check exit status
wait $HM_PID || (
  echo -e "\n${BOLD}${YELLOW}Build failed, showing errors:${RESET}"
  grep --color error < build.log && false
)
echo -e "${BOLD}${GREEN}Finished building home manager${RESET}"

echo -e "${BOLD}${YELLOW}Running Neovim to install plugins...${RESET}"
nvim --headless -c 'Lazy install' -c 'qa' &> nvim-log.log || (
  grep --color error < build.log && false
)
echo -e "${BOLD}${GREEN}Finished running Neovim${RESET}"

echo -e "${BOLD}${YELLOW}Building blink.cmp${RESET}"
cd ~/.local/share/nvim/lazy/blink.cmp || return
nix run .#build-plugin &> build.log || (
  grep --color error < build.log && false
)
echo -e "${GREEN}Finished building blink.cmp${RESET}"
