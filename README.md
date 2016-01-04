# swiftc-wrapper
Python script acting as a wrapper for swfitc compiler allowing to bypass [SR-280](https://bugs.swift.org/browse/SR-280) bug


More info: [http://codica.pl/2015/12/25/taming-swift-compiler-bugs/](http://codica.pl/2015/12/25/taming-swift-compiler-bugs/)

## How to install

- chmod +x swiftc.sh
- cp swiftc.sh /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xc
toolchain/usr/bin/swiftc

### Note

Make sure that you have Python interpreter in /usr/bin/python and write access to /usr/local/bin
