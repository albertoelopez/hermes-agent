#!/bin/bash

echo "=== Quick Hermes Setup with Google Gemini (FREE) ==="
echo
echo "1. Get your FREE API key:"
echo "   Visit: https://aistudio.google.com/apikey"
echo "   Click 'Create API Key'"
echo
echo "2. Once you have your key, run these commands:"
echo
echo "   # Add your API key"
echo "   echo 'export GOOGLE_API_KEY=\"YOUR_KEY_HERE\"' >> ~/.hermes/.env"
echo
echo "   # Configure Hermes for Gemini"
echo "   hermes config set model.provider gemini"
echo "   hermes config set model.default gemini-2-flash"
echo
echo "   # Remove the context override since Gemini has proper context"
echo "   hermes config set model.context_length ''"
echo
echo "3. Test it:"
echo "   hermes -z 'Hello! Can you help me list files in this directory?'"
echo
echo "=== Alternative: OpenRouter (Pay-as-you-go) ==="
echo
echo "1. Sign up at https://openrouter.ai"
echo "2. Add credit ($5 minimum)"
echo "3. Get your API key"
echo "4. Run:"
echo "   echo 'export OPENROUTER_API_KEY=\"sk-or-...\"' >> ~/.hermes/.env"
echo "   hermes config set model.provider openrouter"
echo "   hermes config set model.default claude-3-5-sonnet-20241022"
echo
echo "=== Alternative: Nous Portal (Free tier) ==="
echo
echo "Run: hermes login"
echo "Then follow the browser OAuth flow"