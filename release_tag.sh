#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 v1.2.3"
    exit 1
fi

VERSION=$1

echo "Checking out main branch..."
git checkout main

echo "Creating and pushing tag: $VERSION"
git tag $VERSION
git push origin $VERSION

echo "Release tag $VERSION pushed successfully!"