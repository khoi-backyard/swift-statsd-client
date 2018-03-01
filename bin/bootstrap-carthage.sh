#!/bin/sh

if ! cmp -s Cartfile.resolved Carthage/Cartfile.resolved; then
 carthage bootstrap --platform iOS
 cp -f Cartfile.resolved Carthage/
fi
