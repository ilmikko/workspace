# Workspace
An initializer script to create a new workspace, so that I don't have to manually install everything I want/need.

## Configuration options

##### OOS_INSTALL_DEVICE
The device this installation will use (for example `/dev/sdb`).
All the information on this device will be lost.
This is a required option, there is no default value.

##### OOS_INSTALL_NAME
The name of the installation.
This will determine some settings such as the bootloader ID.

##### OOS_INSTALL_PACKAGES
Which packages to install using pacman / pacaur in stage 3.

##### OOS_LOCALE
Which locales are enabled? Does not have to be the full locale;
for example: `en_US fi_FI` would enable all locales starting with these values

##### OOS_TIMEZONE
Which timezone to use?
You can check the available timezones in `/usr/share/zoneinfo`

##### OOS_PARTITION_LIST
Which partitions to create (there should be an example of this)

##### OOS_MOUNT_FOLDER
Where to mount the installation temporarily for writing.
For example: `/mnt`
If omitted, the mount folder will be a temporary folder in `/tmp`.

##### OOS_USE_GRUB
Use grub as the bootloader. Currently the script only supports this bootloader.

##### OOS_BOOT_UEFI
Use UEFI boot instead of BIOS boot.

##### OOS_UNMOUNT_AFTER_INSTALL
Unmount the filesystems after installation
Default: `1`

### Advanced options

##### OOS_PARTITION_DISK_LABEL
The partition table label to use (default: `gpt`)
**Please note: If you use something else than GPT, such as MBR, you need to make sure your partition list is <4 partitions, as logical partitions aren't supported.**

##### OOS_LANG
Which LANG to set in locale.conf?

##### OOS_HOSTNAME
The hostname to use - this is usually the same as the INSTALL_NAME, but can be overwritten by this option.

##### OOS_BOOT_ID
The bootloader ID to use - this is usually the same as the INSTALL_NAME, but can be overwritten by this option.

### Installation steps

##### OOS_USE_PARTITIONING
Use partitioning

##### OOS_USE_REMOUNT
Use remount

##### OOS_USE_STRAP
Use strapping

##### OOS_USE_SKELETON
Use skeleton

##### OOS_USE_REBOOT
Use reboot

##### OOS_USE_BOOTLOADER
Use bootloader installation

##### OOS_USE_PACSTRAP
Use pacstrap

### Debug variables

##### OOS_FASTTRACK
Skip some confirmations and fast track to the installation process.

### Other variables

#### Timeouts

##### OOS_ERROR_TIMEOUT
How much to wait when an error (like when mounting) happens.

#### System specifics

##### OOS_SHELL
Which shell are we running?

##### OOS_ARCH
Which architecture are we using?

##### OOS_DISTRIBUTION
If possible to tell, which distribution of linux are we using?

##### OOS_ADDITIONAL_PACKAGES
Which additional packages are needed in the installation process?

##### OOS_DEFAULT_PACKAGES
Default packages that are installed in any case

#### Paths

##### OOS_INSTALL_PATH
Location of the `install.d` directory.
This directory will contain the stages for the installation.

##### OOS_AWK_PATH
Location of all of the awk scripts used by the script.

##### OOS_HELPER_PATH
Location of all of the helper scripts

##### OOS_INSTALL_CONF_PATH
Where will the `install.conf` be located?
This file will be used to contain the configuration throughout the installation.

##### OOS_SKELETON_PATH
Location of all of the skeleton folders that will be used by the installation.
User skeletons are stored in a different location

### Idea space
The way I see is that the installation step contains three phases.
Without going too philosophical, here is a list of those:

#### Phase 0
A setup phase that should work with every setup, it's main task is to choose which phase to pick next.

#### Phase 1
This phase is where there is a shell of some kind, but not necessarily all the tools required to complete an arch installation.
The installation script should detect this phase and then do all in its capability to get the process to Phase 2.
The dream would be to be able to say `curl workspace-server.net/script.sh | bash -` or similar, and have a interrupt-less installation from there.

#### Phase 2
This is a phase which works in an arch-like linux installation, and the toolset is readily available to complete the installation.
The installation script should again detect this phase (we can also be booted from phase 1) and clone a new arch installation to whatever disk was provided.
There are some things we could do in chroot, but most of it is left for Phase 3. In the end of Phase 2 we reboot to Phase 3.
On arch installations, the script can simply skip to this step as the tools are already there.

#### Phase 3
This is the last phase, which is already booted into the new installation. Some final configurations are set in this phase.
After this phase the script should finish and leave the user in a working installation (with or without a reboot.)

### Footnote
The initializer script is yet to be completed; this is because my "workspace" consists of a variety of tools that I variate between, and as everything is subject to change it's hard to pin down everything I want in my installation script.
However, I believe it will grow with time.
