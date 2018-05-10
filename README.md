# Workspace
An initializer script to create a new workspace, so that I don't have to manually install everything I want/need.

### Idea space
The way I see is that the installation step contains three phases.
Without going too philosophical, here is a list of those:

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
