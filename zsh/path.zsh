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

if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
fi

# Node.js & Composer paths
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
