# swiftc-wrapper
Python script acting as a wrapper for swfitc compiler allowing to bypass [SR-280](https://bugs.swift.org/browse/SR-280) bug
It allows to bypass the issue with the compiler when it runs with -Owholemodule flag.

Note: This bug affects all versions of Xcode 7.x up to Xcode 7.3 beta2 (where SR-280 bug was fixed). 


More info: [http://codica.pl/2015/12/25/taming-swift-compiler-bugs/](http://codica.pl/2015/12/25/taming-swift-compiler-bugs/)

## How to install

- chmod +x swiftc.sh
- cp swiftc.sh /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xc
toolchain/usr/bin/swiftc

### Note

Make sure that you have Python interpreter in /usr/bin/python and write access to /usr/local/bin
