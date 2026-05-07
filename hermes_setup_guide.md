# Hermes Agent Setup Guide

## Quick Setup Options

### Option 1: Use OpenRouter (Recommended - Pay-as-you-go)

1. Get an API key from https://openrouter.ai
2. Add to your environment:
```bash
echo 'export OPENROUTER_API_KEY="your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

3. Configure Hermes:
```bash
hermes config set model.provider openrouter
hermes config set model.default claude-3-5-sonnet-20241022
```

### Option 2: Use Anthropic Claude (Direct)

1. Get an API key from https://console.anthropic.com
2. Add to your environment:
```bash
echo 'export ANTHROPIC_API_KEY="your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

3. Configure Hermes:
```bash
hermes config set model.provider anthropic
hermes config set model.default claude-3-5-sonnet-20241022
```

### Option 3: Use Nous Portal (Free Tier Available)

1. Login with OAuth:
```bash
hermes login
```

2. Configure:
```bash
hermes config set model.provider nous
hermes config set model.default hermes-3-70b
```

### Option 4: Keep Ollama (Override Context Check)

If you really want to use local Ollama with small models:

1. Pull a small model:
```bash
ollama pull phi3:mini
```

2. Edit ~/.hermes/config.yaml and modify the model section:
```yaml
model:
  default: "phi3:mini"
  provider: "custom"
  base_url: "http://localhost:11434/v1"
  context_length: 65536  # Override to bypass check
  max_tokens: 2048       # Limit output size
```

Note: This will fail frequently when context exceeds the model's actual limit!

## Testing Your Setup

After configuring, test with:
```bash
hermes -z "Hello, can you help me list files in the current directory?"
```

## Checking Current Configuration

View your current settings:
```bash
hermes config
```

## Need Help?

- Run `hermes doctor` to diagnose issues
- Check logs: `hermes logs`
- View status: `hermes status`