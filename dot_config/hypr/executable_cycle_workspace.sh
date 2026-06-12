#!/bin/bash

# Filter out empty workspaces (windows == 0) and special workspaces (id < 0)
WORKSPACES=$(hyprctl workspaces -j | jq '[.[] | select(.id > 0 and .windows > 0) | .id] | sort')
LAST_WORKSPACE=$(echo "$WORKSPACES" | jq '.[-1]')
FIRST_WORKSPACE=$(echo "$WORKSPACES" | jq '.[0]')

# Fallback if no windows exist anywhere (fresh login)
if [ "$LAST_WORKSPACE" == "null" ]; then
    LAST_WORKSPACE=1
    FIRST_WORKSPACE=1
fi

CURRENT_WORKSPACE=$(hyprctl activeworkspace -j | jq '.id')

if [ "$1" == "next" ]; then
    if [ "$CURRENT_WORKSPACE" == "$LAST_WORKSPACE" ]; then
        # We are on the last populated workspace, go to the new empty one
        NEXT_NUM=$((LAST_WORKSPACE + 1))
        hyprctl dispatch workspace "$NEXT_NUM"
    elif [ "$CURRENT_WORKSPACE" -gt "$LAST_WORKSPACE" ]; then
        # We are on the empty workspace, wrap around to the first workspace
        hyprctl dispatch workspace "$FIRST_WORKSPACE"
    else
        # Simply go to the next numerical workspace without skipping
        NEXT_NUM=$((CURRENT_WORKSPACE + 1))
        hyprctl dispatch workspace "$NEXT_NUM"
    fi
elif [ "$1" == "prev" ]; then
    if [ "$CURRENT_WORKSPACE" == "$FIRST_WORKSPACE" ]; then
        # We are on the first workspace, wrap around to the empty one at the end
        NEXT_NUM=$((LAST_WORKSPACE + 1))
        hyprctl dispatch workspace "$NEXT_NUM"
    elif [ "$CURRENT_WORKSPACE" -gt "$LAST_WORKSPACE" ]; then
        # We are on the empty workspace, go back to the last populated one
        hyprctl dispatch workspace "$LAST_WORKSPACE"
    else
        # Simply go to the previous numerical workspace without skipping
        NEXT_NUM=$((CURRENT_WORKSPACE - 1))
        hyprctl dispatch workspace "$NEXT_NUM"
    fi
fi
