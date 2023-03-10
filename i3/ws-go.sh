#!/bin/bash
i3-msg "workspace $(cat ~/.cache/i3x/$1)"
