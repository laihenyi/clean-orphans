#!/bin/bash
mkdir -p ~/.local/bin
cp clean-orphans ~/.local/bin/clean-orphans
chmod +x ~/.local/bin/clean-orphans
echo "✅ Installed clean-orphans to ~/.local/bin/"
echo "Make sure ~/.local/bin is in your PATH."
