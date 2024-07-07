#!/bin/bash
#
# Install Visual Studio Code Ruby extensions
#
extensions=(
  # https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-github-actions
  "GitHub.vscode-github-actions"
  # https://marketplace.visualstudio.com/items?itemName=ms-python.python
  "ms-python.python"
)
for extension in ${extensions[@]}; do
  code --install-extension $extension
done
