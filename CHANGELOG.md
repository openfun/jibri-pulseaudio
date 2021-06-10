# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic 
Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

 - Initial version of the `jibri-pulseaudio` docker image based on
   `jitsi/jibri:stable-5765-1`
 - Add possibility to shutdown jibri (eventually gracefully) and stop the
   container
 - Add JIBRI_NO_MEDIA_TIMEOUT, JIBRI_ALL_MUTED_TIMEOUT and
   JIBRI_CALL_EMPTY_TIMEOUT environment variables

[Unreleased]: https://github.com/openfun/jibri-pulseaudio/compare/86a5427cd81d7f21d8f7fe74f64a4e2167e9a140...main
