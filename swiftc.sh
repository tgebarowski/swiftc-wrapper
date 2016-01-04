#!/usr/bin/python

# Author: Tomasz Gebarowski
# 
# Wrapper for swift compiler, allowing to resolve issue with large Swift project and bug reported in:
# https://bugs.swift.org/browse/SR-280
#
# More info: http://codica.pl/2015/12/25/taming-swift-compiler-bugs/
#
# INSTALL
#
# chmod +x swiftc.sh
# mv swiftc.sh /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xc/toolchain/usr/bin/swiftc
#
# Make sure that you have write access to /usr/local/bin
#

import os
import os.path
import sys
import subprocess

swiftSymLink = "/usr/local/bin/swiftc"
scriptDir = os.path.dirname(os.path.abspath(__file__))

def getArgValue(argName):
	for i in range(1, len(sys.argv)):
		if sys.argv[i] == argName:
			return sys.argv[i+1]	

def makeSymLinkIfNeeded():
	if not os.path.isfile(swiftSymLink):
		swiftCmd = scriptDir + "/swift"
		print "Make sym link %s => %s" % (swiftSymLink, swiftCmd)
		os.symlink(swiftCmd, swiftSymLink)

def getProjectIntermediateDirectory():
	return os.path.dirname(getArgValue("-emit-objc-header-path")) + "/"
			
def getModuleFile():
	modulePath = getArgValue("-emit-module-path")
	return modulePath.replace("swiftmodule", "o")

def hasSwiftFileInInputArgument(swiftFile):
	for arg in sys.argv:
		if arg.endswith("/" + swiftFile):
			return True		
	return False

def getFilenameWithoutExtensionFromPath(path):
	return os.path.splitext(os.path.basename(path))[0]

# Patches LinkFileList so that it contains only moduleFilePath and Objective-C object files
def updateLinkFileList(dir, moduleFilePath):
	for file in os.listdir(dir):
		if file.endswith(".LinkFileList"):
			linkFilePath = dir + "/" + file
			print "Update file: %s\n" % (linkFilePath)
			tmpFile = "/tmp/LinkFileList"

			with open(linkFilePath, 'r') as oldfile, open(tmpFile, 'w') as newfile:
				for line in oldfile:
					if len(line) > 0:
						baseName = getFilenameWithoutExtensionFromPath(line)
						if not hasSwiftFileInInputArgument(baseName + ".swift"):
							newfile.write(line)
				newfile.write(moduleFilePath + "\n")
				os.rename(tmpFile, linkFilePath)
			break
	
makeSymLinkIfNeeded()
intermediateDir = getProjectIntermediateDirectory()
moduleFilePath = getModuleFile()

updateLinkFileList(intermediateDir, moduleFilePath)

extraArgs = ["-num-threads", "0", "-o", moduleFilePath]
cmd = [swiftSymLink] + sys.argv[1:] + extraArgs
#print cmd
subprocess.call(cmd)