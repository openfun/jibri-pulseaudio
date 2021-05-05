# Jibri-pulseaudio, a Jibri docker image using pulseaudio instead of alsa

## Overview

[Jibri](https://github.com/jitsi/jibri) provides services for recording or
streaming a [Jitsi Meet](https://github.com/jitsi/jitsi-meet) conference.

It works by launching a Chrome instance rendered in a virtual framebuffer and
capturing and encoding the output with ffmpeg. The audio is captured with a
virtual audio device, which is a Alsa loopback device.

To use Jibri within a container (with the [official Jibri docker image](https://github.com/jitsi/docker-jitsi-meet/)), it requires to create a loopback device on the host and share it to the container. 

This approach has the following drawbacks:
 - It is not practical to run multiple instances of Jibri on the same host.
 - Some cloud based container platforms does not allow customization of hosts
   and therefore do not allow to create the required Alsa loopback sound
   device.
 - It is hard to build a dynamic pool of Jibri containers with auto-scaling
   features provided by some orchestrators (like
   [Kubernetes HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)).

The purpose of this project is to replace Alsa with Pulseaudio in Jibri, to be
able to run it within a container without any specific configuration on the
host.

## Getting Started

The following instructions are meant to compile and run the Jibri docker image on your
workstation, with a fully functionning jitsi-meet stack.

### Requirements

  - Add the following entry to your `/etc/hosts`: `127.0.0.1	meet.jitsi`
  - docker should be able to bind the port `443` on your workstation

(Improvements are welcome here!)

### Instructions

**Initialize the project**
 - Clone the git repository
 - `make bootstrap`

**Launch the services**
 - `make run`

Note that a volume is mounted outside of the project directory to store persistent data for jitsi services. (By default: `~/.jitsi-meet-cfg`.  It can be customized with the `CONFIG` setting in the `.env` file).

**Start a meeting and record it**
 - Open [https://meet.jitsi/](https://meet.jitsi/) on your browser and accept the certificate if needed
 - Start a recording with the jitsi-meet interface

You can watch `Jibri`'s logs with `make logs`.

When the recording is stopped, you'll find your recordings in `~/.jitsi-meet-cfg/jibri/recordings/`.

You can customize the Jitsi instance by editing the `.env` file.

You can list available commands with `make help`.


## Credits

This project benefits from the work of:

 - The Jitsi team with their [official Jibri docker image](https://github.com/jitsi/docker-jitsi-meet/).
 - [kpeiruza's jibri docker image](https://hub.docker.com/r/kpeiruza/jibri/) with Pulseaudio support.
 - [emrah's guide](https://community.jitsi.org/t/tip-pulseaudio-support-for-jibri/65780) to use Pulseaudio on the Jitsi community forum.  

Many thanks to them!
