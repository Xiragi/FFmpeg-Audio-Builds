#!/bin/bash
AUDIO_ENCODERS="aac,ac3,ac3_fixed,adpcm_*,alac,aptx,aptx_hd,comfortnoise,dca,eac3,flac,g723_1,mp2,mp2fixed,nellymoser,pcm_*,ra_144,truehd,tta,wavpack,wmav1,wmav2,libmp3lame,libopus,libvorbis,libopencore_amrnb,libtwolame"
AUDIO_DECODERS="aac,aac_latm,ac3,adpcm_*,alac,amrnb,amrwb,ape,aptx,aptx_hd,atrac*,comfortnoise,cook,dca,dsd_*,dst,eac3,flac,g723_1,g729,gsm*,mlp,mp1*,mp2*,mp3*,mpc7,mpc8,nellymoser,opus,pcm_*,qcelp,ra_*,ralf,sbc,shorten,sipr,speex,tak,truehd,tta,vorbis,wavpack,wma*"
AUDIO_MUXERS="ac3,adts,aiff,amr,asf,au,caf,chromaprint,dash,dts,eac3,flac,hls,iamf,ipod,latm,matroska,mov,mp2,mp3,mp4,null,ogg,opus,pcm_*,rtp,rtsp,spdif,truehd,tta,wav,wv"
AUDIO_DEMUXERS="aac,ac3,adp,adx,aea,afc,aiff,amr,amrnb,amrwb,apc,ape,asf,au,avi,caf,concat,dash,daud,dsf,dss,dts,dtshd,dv,ea,eac3,flac,flv,gsm,hls,iamf,iff,ilbc,libgme,loas,lrc,matroska,mm,mmf,mov,mp3,mpc,mpc8,mpegps,mpegts,msf,mxf,nistsphere,nut,ogg,oma,pcm_*,qcp,rm,rsd,rso,rtp,rtsp,sbc,sbg,sds,sdx,shorten,siff,sln,sol,sox,spdif,svag,tak,truehd,tta,voc,vqf,w64,wav,wsaud,wsd,wtv,wv,xa,xmv,xvag,xwma"
AUDIO_PARSERS="aac,aac_latm,ac3,amr,cook,dca,dvaudio,flac,g723_1,g729,gsm,mpegaudio,opus,sbc,vorbis"
AUDIO_FILTERS="acompressor,acrossfade,adelay,aecho,afade,afir,aformat,agate,aiir,alimiter,aloop,amerge,amovie,anull,apad,aphaser,apulsator,aresample,asendcmd,asetnsamples,asetpts,asettb,ashowinfo,asplit,astats,asubboost,asubcut,asupercut,asuperpass,atempo,atrim,bass,chorus,compand,concat,ebur128,equalizer,flanger,loudnorm,pan,sidechaincompress,sidechaingate,silencedetect,silenceremove,treble,volume"
AUDIO_PROTOCOLS="file,pipe,crypto,data,http,https,httpproxy,tcp,udp,rtp,srtp,tls,rtmp,rtmpe,rtmps,rtmpt,rtmpte"

# Match upstream's disabled winarm64 OpenMPT recipe until that build is verified.
if [[ $TARGET != winarm64 ]]; then
    AUDIO_DEMUXERS+=",libopenmpt"
fi

FF_CONFIGURE="--enable-version3 --disable-gpl --disable-nonfree \
    --disable-everything --disable-autodetect \
    --enable-small --disable-debug --enable-stripping \
    --enable-ffmpeg --enable-ffprobe --disable-ffplay \
    --enable-avcodec --enable-avformat --enable-avfilter --enable-swresample \
    --disable-avdevice --disable-swscale --disable-hwaccels \
    --enable-network --enable-protocol=$AUDIO_PROTOCOLS \
    --enable-encoder=$AUDIO_ENCODERS --enable-decoder=$AUDIO_DECODERS \
    --enable-muxer=$AUDIO_MUXERS --enable-demuxer=$AUDIO_DEMUXERS \
    --enable-parser=$AUDIO_PARSERS --enable-filter=$AUDIO_FILTERS \
    --enable-iconv --enable-zlib --enable-gmp --enable-lzma --enable-libxml2 \
    --enable-libmp3lame --enable-libopus --enable-libvorbis \
    --enable-libopencore-amrnb --enable-libopencore-amrwb \
    --enable-libsoxr --enable-libtwolame --enable-libgme --enable-chromaprint"

if [[ $TARGET != winarm64 ]]; then
    FF_CONFIGURE+=" --enable-libopenmpt"
fi

if [[ $TARGET == win* ]]; then
    FF_CONFIGURE+=" --enable-schannel"
elif [[ $TARGET == macos* ]]; then
    FF_CONFIGURE+=" --enable-securetransport"
else
    FF_CONFIGURE+=" --enable-openssl"
fi

FF_CFLAGS=""
FF_CXXFLAGS=""
FF_LDFLAGS=""
# Static audio libraries use libm during configure's individual link checks too.
FF_LIBS="-lm"
GIT_BRANCH="master"
LICENSE_FILE="COPYING.LGPLv3"
