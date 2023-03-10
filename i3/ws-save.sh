#!/bin/bash
# key is the first argument
# value is the second argument
mkdir -p ~/.cache/i3x
i3-msg -t get_workspaces | jq ".[] | select(.focused==true) | .name " -r > ~/.cache/i3x/$1
