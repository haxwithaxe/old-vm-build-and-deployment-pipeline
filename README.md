# Description
This is the VM build and deployment pipeline I used until recently. I've switched to using Proxmox from libvirt so I will be redoing big chunks of this very soon.

# Source material
Torrents! Yes, I actually use Bittorrent for Linux ISOs.

I create RSS feeds of torrents using [this](https://github.com/haxwithaxe/debian-feed) and [this](https://github.com/haxwithaxe/ubuntu-feed). I also had a Rocky Linux feed but I've given up on RHEL and it's clones/spin-offs.

I have qBittorrent watch the RSS feeds and grab the torrents that match regexps for the netinstall/minimal ISOs or equivalent and download them directly to the directory where the next part of the process looks for them. See [this](qBittorrent/rss/download_rules.json) for the rules I use. The rules include other images that I grab just to seed as well. I'm rebuilding everything so those rules are from an old backup they might not be quite right for Debian 12.

# Base images
I used scripts that use packer to build base images. [This script](packer/build.sh) was used via cron to check the state of the environment and run the build scripts for the different distros. I have the content of the mail spool sent as a digest to my email so I get build error alerts by email.

See [this](https://github.com/haxwithaxe/packer-debian) and [this](https://github.com/haxwithaxe/packer-ubuntu) for details on how I built the specific images.

# Deployment
For deploying VMs generally I used [this](https://github.com/haxwithaxe/generic-lab-testing-terraform) terraform template. It's basically a parametric VM deployment tool. I would fork that repo and change the defaults for whatever project or if I needed a one-off VM I could provide the variables on the commandline and wipe the state when the VM was up and running. Then I would throw ansible scripts at it or just start whatever testing needed to be done.
