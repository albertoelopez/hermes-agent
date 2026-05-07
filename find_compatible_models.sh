#!/bin/bash

echo "=== Finding Ollama Models Compatible with Your System ==="
echo
echo "System Specs:"
echo "- RAM: 5.7GB (2.7GB available)"
echo "- CPU: Intel Core i5-4210U (4 cores)"
echo "- GPU: None (Intel integrated graphics only)"
echo

echo "=== Models that MIGHT work with CPU-only (but with limited context) ==="
echo

# Models under 3GB that could run on CPU
echo "1. phi3:mini (2.3GB) - Microsoft's small model"
echo "   Context: 4K tokens (too small for Hermes)"
echo "   Pull: ollama pull phi3:mini"
echo

echo "2. gemma:2b (1.4GB) - Google's smallest model"
echo "   Context: 8K tokens (too small for Hermes)"
echo "   Pull: ollama pull gemma:2b"
echo

echo "3. qwen:0.5b (394MB) - Alibaba's tiny model"
echo "   Context: 2K tokens (too small for Hermes)"
echo "   Pull: ollama pull qwen:0.5b"
echo

echo "=== The Problem ==="
echo "Hermes Agent requires models with 64K+ context window."
echo "Models with 64K context typically need:"
echo "- 8-16GB VRAM (GPU) for fast inference, OR"
echo "- 16-32GB RAM for slow CPU inference"
echo
echo "Your system has only 5.7GB RAM total, which limits you to tiny models"
echo "with small context windows that won't work with Hermes Agent."
echo

echo "=== Recommended Solutions ==="
echo
echo "1. USE CLOUD PROVIDERS (Best option for your hardware):"
echo "   hermes setup"
echo "   - Choose Anthropic (Claude) - Best quality"
echo "   - Choose OpenRouter - Many model options"
echo "   - Choose Nous Portal - Free tier available"
echo

echo "2. OVERRIDE CONTEXT CHECK (Not recommended - will fail frequently):"
echo "   Edit ~/.hermes/config.yaml and add:"
echo "   model:"
echo "     context_length: 65536"
echo "   But the model will still only have its actual small context"
echo

echo "3. USE HERMES WITH CLOUD MODELS (Recommended):"
echo "   # Example with OpenRouter"
echo "   export OPENROUTER_API_KEY='your-key-here'"
echo "   hermes model"
echo "   # Select OpenRouter and a model like claude-3-5-sonnet"
echo

echo "=== Testing Small Models Anyway ==="
echo "If you want to experiment with small models despite the limitations:"
echo
echo "# Pull a small model"
echo "ollama pull phi3:mini"
echo
echo "# Configure Hermes to use it (will need context override)"
echo "# Edit ~/.hermes/config.yaml:"
echo "model:"
echo "  default: 'phi3:mini'"
echo "  provider: 'custom'"
echo "  base_url: 'http://localhost:11434/v1'"
echo "  context_length: 65536  # Fake override"
echo
echo "But expect frequent context overflow errors!"