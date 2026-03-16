# User bin directories
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# macOS Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/usr/local/bin:$PATH"
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Linuxbrew (Homebrew on Linux)
if [ -d "$HOME/.linuxbrew" ]; then
    export PATH="$HOME/.linuxbrew/bin:$PATH"
    export PATH="$HOME/.linuxbrew/sbin:$PATH"
fi

# Node.js & Composer paths
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
