#!/bin/bash

# Halt on any error
set -u
set -e

if [ -f "./BaseSystem.img" ]; then
  echo "BaseSystem.img already exists"
  exit 0
fi

if [ -f "./InstallOS.dmg" ]; then
  OSFILE="InstallOS"
  OSFOLDER="Install macOS"
  echo "Found $OSFILE.dmg - Installer for Sierra (10.12)";
fi

if [ -f "./InstallMacOSX.dmg" ]; then
  OSFILE="InstallMacOSX"
  OSFOLDER="Install OS X"
  echo "Found $OSFILE.dmg - Installer for Lion (10.7) - El Capitan (10.11)";
fi

if [ -z ${OSFILE+x} ]; then
  echo "Please place InstallOS.dmg / InstallMacOSX.dmg into the current directory!"
  exit 0
fi

# Extract HFS Partition from Apples official InstallOS.dmg ( Download from https://support.apple.com/de-de/102662 )
7z x $OSFILE.dmg 5.hfs

# Extract InstallOS.pkg from the HFS Partition
7z e 5.hfs "${OSFOLDER}/$OSFILE.pkg"

# Cleanup and rename InstallOS.pkg due to naming conflict that would prevent next extraction
mv $OSFILE.pkg IOS.pkg
rm 5.hfs

# Extract InstallESD.dmg and move it
xar -xvf IOS.pkg $OSFILE.pkg/InstallESD.dmg
mv $OSFILE.pkg/InstallESD.dmg InstallESD.dmg

# Cleanup
rm -r $OSFILE.pkg
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