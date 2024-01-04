#!/bin/bash

# Halt on any error
set -u
set -e

if [ -f "./BaseSystem.img" ]; then
  echo "BaseSystem.img already exists"
  exit 0
fi

if [ -f "./InstallOS.dmg" ]; then
  OSFILE="InstallOS.dmg"
  echo "Found $OSFILE - Installer for Sierra (10.12)";
fi

if [ -f "./InstallMacOSX.dmg" ]; then
  OSFILE="InstallMacOSX.dmg"
  echo "Found $OSFILE - Installer for Lion (10.7) - El Capitan (10.11)";
fi

if [ -z ${OSFILE+x} ]; then
  echo "Please place InstallOS.dmg / InstallMacOSX.dmg into the current directory!"
  exit 0
fi

if [ $(7z l $OSFILE | grep -c -F 5.hfs) -eq 1 ]; then
  # Image contains intermediate HFS Partition
  7z x $OSFILE 5.hfs
  PKGSRC="5.hfs"
else
  PKGSRC=$OSFILE
fi

if [ $(7z l $PKGSRC | grep -c -e "Install.*/.*\.pkg") -eq 1 ]; then
  # Image contains the pkg
  PKGFOLDER=$(7z l $PKGSRC | grep -o -e "Install.*/.*\.pkg" | cut -d "/" -f 1)
  PKGFILE=$(7z l $PKGSRC | grep -o -e "Install.*/.*\.pkg" | cut -d "/" -f 2)
  7z e $PKGSRC "${PKGFOLDER}/$PKGFILE"
else
  7z l $PKGSRC
  echo "Couldn't find pkg in $PKGSRC"
  exit 1
fi

# Cleanup intermediate HFS
if [ -f "5.hfs" ]; then
  rm 5.hfs
fi

# Rename InstallOS.pkg due to naming conflict that would prevent next extraction
mv $PKGFILE IOS.pkg

# Extract InstallESD.dmg and move it
xar -xvf IOS.pkg $PKGFILE/InstallESD.dmg
mv $PKGFILE/InstallESD.dmg InstallESD.dmg

# Cleanup
rm -r $PKGFILE
rm IOS.pkg

if [ $(7z l InstallESD.dmg | grep -c -F 5.hfs) -eq 1 ]; then
  # Image contains intermediate HFS Partition
  7z x InstallESD.dmg 5.hfs
  rm InstallESD.dmg
  mv 5.hfs InstallESD.dmg
fi

if [ $(7z l InstallESD.dmg | grep -c -e ".*/BaseSystem.dmg") -eq 1 ]; then
  # Image contains the dmg
  PKGFOLDER=$(7z l -slt InstallESD.dmg | grep -e "Path = .*/BaseSystem.dmg" | cut -d "=" -f 2 | xargs | cut -d "/" -f 1)
  7z e InstallESD.dmg "$PKGFOLDER/BaseSystem.dmg"
  rm InstallESD.dmg
else
  # Could not find
  7z l InstallESD.dmg
  echo "Could not find BaseSystem.dmg in InstallESD.dmg"
  exit 1
fi

# Convert to BaseSystem.img
dmg2img BaseSystem.dmg
rm BaseSystem.dmg

echo "--- Done! ---"
echo "Now write BaseSystem.img to a DVD or USB-Stick, e.g. using AnyBurn."
echo "Boot it by keeping ALT pressed when powering on your MacBook."