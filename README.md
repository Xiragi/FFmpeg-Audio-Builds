# Automated FFmpeg Audio Builds

Lightweight LGPLv3+ FFmpeg binaries for audio only.

Designed for workloads that don't require video.

Latest builds are built and released weekly [here](https://github.com/Xiragi/FFmpeg-Audio-Builds/releases/tag/latest).

## Supported platforms

- Windows x64
- Windows ARM64
- Linux x64
- Linux ARM64
- macOS x64
- macOS ARM64 (M series)

Static and shared builds are available for Windows and Linux. macOS builds are static.

## Supported features

### Encoders

- AAC
- AC3 / EAC3
- ADPCM formats
- ALAC
- AMR-NB
- aptX / aptX HD
- Comfort noise
- DCA (DTS)
- FLAC
- G.722 / G.723.1 / G.726
- MP2 / MP3
- Nellymoser
- Opus
- PCM formats
- RealAudio 1.0
- TrueHD
- TTA
- Vorbis
- WavPack
- WMA 1 / WMA 2
- libmp3lame
- libopus
- libvorbis
- libtwolame
- libopencore-amrnb

DCA and TrueHD encoding may require `-strict -2`. AMR-WB is supported for decoding only.

### Decoders

- AAC / AAC-LATM
- AC3 / EAC3
- ADPCM formats
- ALAC
- AMR-NB / AMR-WB
- APE
- aptX / aptX HD
- ATRAC
- Cook
- DCA (DTS)
- DSD / DST
- FLAC
- G.722 / G.723.1 / G.726 / G.729
- GSM
- MLP
- MP1 / MP2 / MP3
- Musepack
- Nellymoser
- Opus
- PCM formats
- QCELP
- RealAudio formats
- SBC
- Shorten
- SIPR
- Speex
- TAK
- TrueHD
- TTA
- Vorbis
- WavPack
- WMA

### Muxers

- AC3 / EAC3
- ADTS
- AIFF
- AMR
- ASF
- AU
- CAF
- Chromaprint (KissFFT)
- DTS
- FLAC
- IAMF
- LATM
- Matroska
- MOV / MP4 / M4A
- MP2 / MP3
- OGG
- Opus
- PCM formats
- SPDIF
- TrueHD
- TTA
- WAV
- WavPack
- RTP / RTSP / HLS / DASH

### Demuxers

- AAC, AC3, EAC3, ADP, ADX
- AEA, AFC, AIFF, AMR
- AMR-NB / AMR-WB
- APC, APE
- ASF, AU, AVI
- CAF, DAUD
- Concat
- DASH
- DSF / DSS
- DTS / DTS-HD
- DV
- EA
- FLAC
- FLV
- Game Music Emu
- GSM
- HLS
- IAMF
- IFF, ILBC
- LOAS, LRC
- Matroska
- MM, MMF
- MOV / MP4
- MP3
- MPC / MPC8
- MPEG-PS / MPEG-TS
- MSF, MXF
- NIST Sphere
- NUT
- OGG, OMA
- OpenMPT tracker formats (except Windows ARM64)
- PCM formats
- QCP
- RealMedia
- RSD, RSO
- RTP / RTSP
- SBC, SBG
- SDX / SDS / SIFF / SLN / SOL / SOX
- Shorten
- SPDIF, SVAG
- TAK
- TrueHD
- TTA
- VOC / VQF
- W64 / WAV / WavPack
- WSAUD / WSD / WTV
- XA / XMV / XVAG / XWMA

### Parsers

- AAC / AAC-LATM
- AC3
- AMR
- Cook
- DCA (DTS)
- DVAudio
- FLAC
- G.723.1 / G.729
- GSM
- MPEG audio (MP1 / MP2 / MP3)
- Opus
- SBC
- Vorbis

### Filters

- aresample (including SoXR)
- aformat
- anull
- volume
- pan
- amerge
- asplit
- channelmap
- channelsplit
- join
- atempo
- equalizer
- bass
- treble
- compand
- flanger
- chorus
- aecho
- afir
- silencedetect
- silenceremove
- ebur128
- loudnorm
- replaygain
- dynaudnorm
- agate
- alimiter
- acompressor
- sidechaincompress
- sidechaingate
- aphaser
- apulsator
- atrim
- asetpts
- adelay
- apad
- asendcmd
- acrossfade
- afade
- aloop
- asetnsamples
- asettb
- ashowinfo
- amovie
- aiir
- asupercut
- asuperpass
- asubboost
- asubcut
- astats
- concat

### Bitstream filters

- dca_core
- eac3_core
- truehd_core
- opus_metadata
- aac_adtstoasc (enabled automatically by the selected muxers)

### Protocols

- file
- fd
- http
- https
- httpproxy
- tcp
- udp
- rtp
- srtp
- tls
- rtmp
- rtmpe
- rtmps
- rtmpt
- rtmpte
- pipe
- crypto
- data

## Building

Windows and Linux builds need Bash and Docker:

```sh
./makeimage.sh linux64 lgpl-audio
./build.sh linux64 lgpl-audio
```

Use `win64`, `winarm64`, `linux64` or `linuxarm64` for the target. Use `lgpl-audio-shared` for shared builds.

macOS builds need Xcode Command Line Tools and Homebrew:

```sh
brew install bash coreutils gnu-sed make bison texinfo gettext autoconf automake libtool cmake nasm subversion pkgconf
"$(brew --prefix bash)/bin/bash" util/build_macos.sh
```

Builds are saved in `artifacts/`.
