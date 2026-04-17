# Automated FFmpeg Audio Builds

Weekly automated LGPL audio-only FFmpeg binaries.

Designed for workloads that don't require video.

Latest builds are available [here](https://github.com/Xiragi/FFmpeg-Audio-Builds/releases/tag/latest).

## Supported platforms

- Windows x64
- Windows ARM64
- Linux x64
- Linux ARM64

## Supported features

### Encoders
- AAC
- AC3
- ALAC
- AMR-NB / AMR-WB
- APE
- aptX / aptX HD
- DCA
- FLAC
- G.722 / G.723.1 / G.726 / G.729
- GSM
- MP1 / MP2 / MP3
- Musepack
- Nellymoser
- Opus
- PCM formats
- RealAudio formats
- Shorten
- SIPR / Sonic
- TAK
- TrueHD
- TTA
- Vorbis
- WavPack
- WMA
- libmp3lame
- libopus
- libvorbis

### Decoders
- AAC / AAC-LATM
- AC3
- ADPCM formats
- ALAC
- AMR-NB / AMR-WB
- APE
- aptX / aptX HD
- ATRAC
- Cook
- DCA
- DSF / DSD formats
- FLAC
- G.722 / G.723.1 / G.726 / G.729
- GSM
- MP1 / MP2 / MP3
- Musepack
- Nellymoser
- Opus
- PCM formats
- QCELP
- RealAudio formats
- Shorten
- SIPR / Sonic
- TAK
- TrueHD
- TTA
- Vorbis
- WavPack
- WMA
- IAMF

### Muxers
- ADTS
- AIFF
- AMR
- AU
- CAF
- FLAC
- IAMF
- MP2 / MP3
- MP4 / M4A
- OGG
- Opus
- PCM formats
- TTA
- WAV
- WavPack
- RTP / RTSP / HLS / DASH

### Demuxers
- AAC, AC3, ADP, ADX
- AEA, AFC, AIFF, AMR
- AMR-NB / AMR-WB
- ANM, APC, APE
- ASF, AU, AVS
- CAF, DAUD
- DSF / DFF
- DTS / DTS-HD
- DV
- EA
- FLAC
- GSM
- HLS
- IAMF
- IFF, IT, ILBC
- LOAS, LRC
- Matroska
- MM, MMF
- MOV / MP4
- MP3
- MPC / MPC8
- MXF
- NUT
- OGG, OMA
- PCM formats
- QCP
- RealMedia
- RTP / RTSP
- SBC, SBG
- SDX / SDS / SIF / SLN / SOX
- SPDIF
- TAK
- TrueHD
- TTA
- VOC / VQF
- W64 / WAV / WavPack
- WSAUD / WSD / WTV
- WV
- XA / XMV / XVAG / XWMA

### Parsers
- AAC
- AC3
- ADPCM
- ALAC
- AMR
- APE
- Cook
- DCA
- DVAudio
- FLAC
- GSM
- MP3
- Opus
- PCM
- Vorbis

### Filters
- aresample
- aformat
- anull
- volume
- pan
- amerge
- asplit
- atempo
- equalizer
- bass
- treble
- compand
- flanger
- chorus
- echo
- reverb
- silencedetect
- ebur128
- agate
- alimiter
- acompressor
- sidechaincompress
- sidechaingate
- apulsator
- atrim
- asetpts
- adelay
- apad
- asendcmd
- acrossfade
- afade
- aloop
- asettb
- ashowinfo
- amovie
- abuffer
- abuffersink
- aiir
- asupercut
- asuperpass
- asubboost
- asubcut
- aspectrogram
- astats
- avectorscope
- aphasemeter

### Protocols
- file
- http
- https
- tcp
- udp
- rtp
- rtsp
- hls
- tls
- rtmp
- rtmpe
- rtmps
- rtmpt
- rtmpte
- pipe