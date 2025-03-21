#!/bin/bash
wf-info -l | rg "^(Title:|Focused: true$)" | awk '/^Title:/ { title = $0; sub(/^Title: /, "", title) } /^Focused: true$/ { print title }'
