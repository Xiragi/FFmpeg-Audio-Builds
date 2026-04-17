FF_CONFIGURE="--enable-version3 --disable-gpl --disable-nonfree \
    --disable-everything \
    --enable-small --disable-debug --enable-stripping \
    --enable-avcodec --enable-avformat --enable-avfilter --enable-swresample --enable-avdevice \
    --enable-network --enable-protocol=file,http,https,tcp,udp,rtp,rtsp,hls,tls,rtmp,rtmpe,rtmps,rtmpt,rtmpte,pipe \
    --enable-encoder=aac,ac3,alac,amrnb,amrwb,ape,aptx,aptx_hd,comfortnoise,dca,dsd_*,flac,g722,g723_1,g726,g729,gsm*,mp1,mp2,mp3,mpc7,mpc8,nellymoser,opus,pcm_*,ra_*,ralf,shorten,sipr,sonic*,tak,truehd,tta,vorbis,wavpack,wma*,libmp3lame,libopus,libvorbis \
    --enable-decoder=aac,aac_latm,ac3,adpcm_*,alac,amrnb,amrwb,ape,aptx,aptx_hd,atrac*,comfortnoise,cook,dca,dsd_*,dsf,flac,g722,g723_1,g726,g729,gsm*,mp1,mp2,mp3,mpc7,mpc8,nellymoser,opus,pcm_*,qcelp,ra_*,ralf,shorten,sipr,sonic*,tak,truehd,tta,vorbis,wavpack,wma*,iamf \
    --enable-muxer=adts,aiff,amr,au,caf,flac,iamf,mp2,mp3,mp4,m4a,ogg,opus,pcm_*,tta,wav,wavpack,rtp,rtsp,hls,dash \
    --enable-demuxer=aac,ac3,adp,adx,aea,afc,aiff,amr,amrnb,amrwb,anm,apc,ape,asf,au,avs,caf,daud,dsf,dss,dts,dtshd,dv,ea,flac,gsm,hls,iamf,idcin,iff,ilbc,it,loas,lrc,matroska,mm,mmf,mov,mp3,mpc,mpc8,msf,mvi,mxf,nc,nistsphere,nsv,nut,ogg,oma,paf,pcm_*,pvf,qcp,realtext,rm,roq,rpl,rsd,rso,rtp,rtsp,sbc,sbg,sds,sdx,shorten,siff,sln,sol,sox,spdif,svag,tak,truehd,tta,tty,txd,ty,voc,vqf,w64,wav,wavpack,wsaud,wsd,wtv,wv,xa,xmv,xvag,xwma \
    --enable-parser=aac,ac3,adpcm,alac,amr,ape,cook,dca,dvaudio,flac,gsm,mpegaudio,opus,pcm,vorbis \
    --enable-filter=aresample,aformat,anull,volume,pan,amerge,asplit,atempo,equalizer,bass,treble,compand,flanger,chorus,echo,reverb,silencedetect,ebur128,agate,alimiter,acompressor,sidechaincompress,sidechaingate,apulsator,atrim,asetpts,adelay,apad,asendcmd,acrossfade,afade,aloop,asettb,ashowinfo,amovie,abuffer,abuffersink,aiir,asupercut,asuperpass,asubboost,asubcut,aspectrogram,astats,avectorscope,aphasemeter \
    --enable-libmp3lame --enable-libopus --enable-libvorbis \
    --disable-hwaccels --disable-audiotoolbox --disable-vaapi --disable-vdpau --disable-videotoolbox --disable-amf --disable-cuda --disable-cuvid --disable-d3d11va --disable-d3d12va --disable-dxva2 --disable-ffnvcodec --disable-nvdec --disable-nvenc --disable-v4l2-m2m"

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
GIT_BRANCH="master"
LICENSE_FILE="COPYING.LGPLv3"
