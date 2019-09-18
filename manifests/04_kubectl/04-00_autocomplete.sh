#!/bin/bash

set -x

# 1. Configure Bash kubectl Autocomplete
#  See docs at: https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-autocomplete

# setup autocomplete in bash into the current shell, bash-completion package should be installed first.
source <(kubectl completion bash)

# add autocomplete permanently to your bash shell.
echo "source <(kubectl completion bash)" >> ~/.bashrc 

read -p "Continue?"

# 2. You can also use a shorthand alias for kubectl that also works with completion:
alias k=kubectl
complete -F __start_kubectl k
echo "alias k=kubectl" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc

read -p "Continue?"
