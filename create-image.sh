#!/bin/bash

# Halt on any error
set -u
set -e

if [ -f "./BaseSystem.img" ]; then
  echo "BaseSystem.img already exists"
  exit 0
fi

if ! [ -f "./InstallOS.dmg" ]; then
  echo "Please place InstallOS.dmg into the current directory!"
  exit 0
fi

# Extract HFS Partition from Apples official InstallOS.dmg ( Download from https://support.apple.com/de-de/102662 )
7z x InstallOS.dmg 5.hfs

# Extract InstallOS.pkg from the HFS Partition
7z e 5.hfs "Install macOS/InstallOS.pkg"

# Cleanup and rename InstallOS.pkg due to naming conflict that would prevent next extraction
mv InstallOS.pkg IOS.pkg
rm 5.hfs

# Extract InstallESD.dmg and move it
xar -xvf IOS.pkg InstallOS.pkg/InstallESD.dmg
mv InstallOS.pkg/InstallESD.dmg InstallESD.dmg

# Cleanup
rm -r InstallOS.pkg
rm IOS.pkg

# Extract HFS Partition from InstallESD.dmg
7z x InstallESD.dmg 5.hfs
rm InstallESD.dmg

# Extract BaseSystem.dmg
# 7z e 5.hfs "OS X Install ESD/AppleDiagnostics.dmg"
7z e 5.hfs "OS X Install ESD/BaseSystem.dmg"
rm 5.hfs

# Convert to BaseSystem.img
dmg2img BaseSystem.dmg
rm BaseSystem.dmg

echo "--- Done! ---"
echo "Now write BaseSystem.img to a DVD or USB-Stick, e.g. using AnyBurn."
echo "Boot it by keeping ALT pressed when powering on your MacBook."