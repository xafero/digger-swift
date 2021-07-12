#!/bin/sh
rm .build/x86_64-unknown-linux-gnu/debug/digger
swift build -Xswiftc -suppress-warnings
.build/x86_64-unknown-linux-gnu/debug/digger
