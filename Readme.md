# macOS Boot Image Extractor

This is a simple Docker-Container that contains all the tools required to extract a bootable Rescue/Install image from an official macOS Installation .dmg file, like the ones you can download from https://support.apple.com/en-us/102662 .

It was successfully testet with:
- macOS Sierra (10.12)
- macOS El Capitan (10.11)

All you need is Docker and a Tool to write an .img file to a USB Stick (like AnyBurn) or DVD. It should work with Windows or Linux, though some batch-files are provided for convenience on Windows.

It uses [xar](https://github.com/mackyle/xar) and 7zip to extract pkg and dmg images and dmg2img to convert the final dmg to img.

The Image we want is burried deep in the Installation image:
```
InstallOS.dmg (Sierra 10.12)
└─ 5.hfs (Partition)
   └─ Install macOS/InstallOS.pkg
      └─ InstallOS.pkg/InstallESD.dmg
         └─ 5.hfs (Partition)
            └─ OS X Install ESD/BaseSystem.dmg

InstallMacOSX.dmg (Lion 10.7 - El Capitan 10.11)
└─ 5.hfs (Partition)
   └─ Install OS X/InstallMacOSX.pkg
      └─ InstallMacOSX.pkg/InstallESD.dmg
         └─ 5.hfs (Partition)
            └─ OS X Install ESD/BaseSystem.dmg
 ```

## Instructions

1. Build the required Doker-Container by running `docker_build.bat` (Windows) or `./docker_build.sh` (Linux)

1. Download/Copy `InstallOS.dmg` from https://support.apple.com/en-us/102662 into the current directory and make sure it's called `InstallOS.dmg`

1. Run the Docker container via `docker_run.bat` (Windows) or `./docker_run.sh` (Linux)

*⚠ While the Container is running, it will extract temporary files into the current directory! Make sure you have at least 15GB free space and no other conflicting files in the directory! ⚠*

When it's done, it will leave a `BaseSystem.img` in the current folder you can then write on an USB-Stick or DVD, e.g. using Tools like AnyBurn.

To boot you MacBook from the media hold down ALT when powering it on.

## Sources
This was inspired by:
- https://gist.github.com/coolaj86/9834a45a6c21a41e8882698a00b55787
- https://apple.stackexchange.com/questions/448120/how-can-i-use-windows-to-create-an-os-x-el-capitan-or-macos-sierra-usb-flash-dri/448121#448121