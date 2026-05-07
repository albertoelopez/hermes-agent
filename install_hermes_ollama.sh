#!/bin/bash

# Local installation of Hermes + Ollama without sudo
set -e

echo "=== Hermes + Ollama Local Installation ==="
echo "This script will install both tools locally without requiring sudo"
echo

# Create local directories
mkdir -p ~/bin
mkdir -p ~/.local/bin

# Check for required tools
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "ERROR: $1 is required but not installed"
        echo "Please install it using: sudo apt-get install $2"
        exit 1
    fi
}

echo "Checking prerequisites..."
check_tool "wget" "wget"
check_tool "python3" "python3"
check_tool "tar" "tar"

# Download and install Ollama locally
echo
echo "=== Installing Ollama locally ==="
cd ~/bin

# Get latest Ollama release
echo "Downloading Ollama..."
if [ ! -f ollama ]; then
    # Try to download pre-built binary
    wget -q https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64 -O ollama 2>/dev/null || {
        echo "Direct download failed, trying alternative method..."
        # Alternative: Download from Ollama CDN
        wget -q https://ollama.com/download/ollama-linux-amd64 -O ollama 2>/dev/null || {
            echo "ERROR: Could not download Ollama binary"
            echo "Please visit https://ollama.com/download for manual installation"
            exit 1
        }
    }
    chmod +x ollama
    echo "✓ Ollama binary downloaded to ~/bin/ollama"
else
    echo "✓ Ollama already exists at ~/bin/ollama"
fi

# Add to PATH if not already there
if ! echo "$PATH" | grep -q "$HOME/bin"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/bin:$PATH"
    echo "✓ Added ~/bin to PATH"
fi

# Install uv directly (bypasses pip issues)
echo
echo "=== Installing uv package manager ==="
if ! command -v uv &> /dev/null; then
    wget -qO- https://github.com/astral-sh/uv/releases/latest/download/uv-installer.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "✓ uv installed"
else
    echo "✓ uv already installed"
fi

# Install Hermes Agent
echo
echo "=== Installing Hermes Agent ==="

# Use the local repo
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Install Hermes using the official installer from this repo
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:$PATH"
if [ -f "./scripts/install.sh" ]; then
    ./scripts/install.sh
else
    echo "ERROR: scripts/install.sh not found in current directory"
    echo "Make sure you're in the hermes-agent repository"
    exit 1
fi

# The installer creates the hermes command automatically

echo "✓ Hermes Agent installed"

# Create setup completion script
cat > ~/hermes_ollama_setup.sh << 'EOF'
#!/bin/bash

echo "=== Completing Hermes + Ollama Setup ==="
echo

# Function to check if Ollama is running
check_ollama() {
    if curl -s http://localhost:11434/api/version > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Start Ollama if not running
if ! check_ollama; then
    echo "Starting Ollama service..."
    nohup ~/bin/ollama serve > ~/.ollama.log 2>&1 &
    echo "Waiting for Ollama to start..."
    sleep 5
    
    if check_ollama; then
        echo "✓ Ollama is running"
    else
        echo "ERROR: Ollama failed to start. Check ~/.ollama.log"
        exit 1
    fi
else
    echo "✓ Ollama is already running"
fi

# Pull the model
echo
echo "Pulling tinyllama model (1.1B parameters, ~650MB, suitable for 6GB RAM)..."
~/bin/ollama pull tinyllama

# Configure Hermes
echo
echo "=== Configuring Hermes to use Ollama ==="
mkdir -p ~/.hermes

cat > ~/.hermes/config.yaml << 'CONFIG'
provider: custom
base_url: http://localhost:11434/v1
model: tinyllama
temperature: 0.7
max_tokens: 2048
CONFIG

echo "✓ Hermes configured to use Ollama"

# Test the setup
echo
echo "=== Testing the installation ==="
~/bin/hermes doctor

echo
echo "=== Installation Complete! ==="
echo
echo "To use Hermes, run: hermes"
echo "To use Ollama directly, run: ollama"
echo
echo "Example commands:"
echo "  hermes 'What files are in my current directory?'"
echo "  ollama run qwen2.5:7b"
EOF

chmod +x ~/hermes_ollama_setup.sh

echo
echo "=== Installation Script Complete ==="
echo
echo "Next steps:"
echo "1. Source your bashrc to update PATH:"
echo "   source ~/.bashrc"
echo
echo "2. Run the setup completion script:"
echo "   ~/hermes_ollama_setup.sh"
echo
echo "This will:"
echo "- Start Ollama service"
echo "- Download the qwen2.5:7b model"
echo "- Configure Hermes to use Ollama"
echo "- Test the installation"