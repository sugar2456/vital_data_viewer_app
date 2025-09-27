#!/bin/bash

CURRENT_VERSION=$(git tag --sort=-version:refname | head -1)

if [ -z "$CURRENT_VERSION" ]; then
    echo "No version tags found"
    exit 1
fi

echo "Current version: $CURRENT_VERSION"