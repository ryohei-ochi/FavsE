@echo off

echo FavsE (FullAuto AVS Encode) 3.22
echo.

REM ----------------------------------------------------------------------
REM �f���G���R�[�_�̎w��i0:x264, 1:QSVEnc, 2:NVEnc_AVC, 3:NVEnc_HEVC�j
REM ��������قǋ���ȑ��x���͂���܂���B�掿�̍��͂���܂��̂�x264�����ł��B
REM ----------------------------------------------------------------------
set video_encoder=0
REM ----------------------------------------------------------------------
REM �����G���R�[�_�̎w��i0:FAW, 1:qaac�j
REM �ʏ��FAW��OK�ł��BFAW���g�p�ł��Ȃ��ꍇ�͎����I��qaac�ŏ������܂��B
REM ----------------------------------------------------------------------
set audio_encoder=0

REM ----------------------------------------------------------------------
REM ����CM�J�b�g�̏������s�����i0:�s��Ȃ�, 1:�s���j
REM CM�͍����x�ŃJ�b�g���܂����A�����ł͂���܂���B�蓮�J�b�g�Ƃ̑g�ݍ��킹�����ł��B
REM ----------------------------------------------------------------------
set cut_cm=0
REM ----------------------------------------------------------------------
REM ���S�����̏������s�����i0:�s��Ȃ�, 1:�s���j
REM ���O��AviUtl + ���S��̓v���O�C����.lgd�t�@�C�����쐬���Ă����K�v������܂��B
REM ----------------------------------------------------------------------
set cut_logo=0
REM ----------------------------------------------------------------------
REM avs������ɏ������ꎞ��~���邩�i0:���Ȃ�, 1:����j
REM �������ꂽ�X�N���v�g���m�F���Ă���i�߂��܂��B�قڎ蓮CM�J�b�g�p�ł��B
REM ----------------------------------------------------------------------
set check_avs=0

REM ----------------------------------------------------------------------
REM �C���^�[���[�X�������s�����i0:�C���^�[���[�X�ێ�, 1:�C���^�[���[�X�����j
REM �ʏ�͉��������ł��B���T�C�Y�������s���̂ł���΃C���^�[���[�X�ێ��̈Ӗ��͔���܂��B
REM ----------------------------------------------------------------------
set deint=1
REM ----------------------------------------------------------------------
REM 30fps�̃C���^�[���[�X��������BOB�����s�����i0:�s��Ȃ�, 1:�s���j
REM 24fps���i�t�e���V�l�j�ł͂Ȃ��P�[�X�ŁA�����k���k����60fps����ɂł��܂��B
REM ----------------------------------------------------------------------
set deint_bob=1
REM ----------------------------------------------------------------------
REM �C���^�[���[�X���� / �t�e���V�l��GPU�ōs�����i0:�s��Ȃ�, 1:�s���j
REM �g�p����f�o�C�X����������ꍇ�� Intel, NVIDIA, Radeon����w�肵�Ă��������B
REM ----------------------------------------------------------------------
set gpu_deint=0
set d3dvp_device=Intel

REM ----------------------------------------------------------------------
REM GPU�ɂ��m�C�Y�������s�����i0:�s��Ȃ�, 1:�s���j
REM _GPU25�v���O�C�����g�p���܂��B�Ή�GPU�������Ă��Ȃ���΃G���[�ɂȂ�܂��B
REM ----------------------------------------------------------------------
set denoize=0
REM ----------------------------------------------------------------------
REM Width��1280px�𒴂���ꍇ��1280x720px�Ƀ��T�C�Y���邩�i0:���Ȃ�, 1:����j
REM 4K / 2K / Full HD���̏ꍇ��HD�T�C�Y�ɑ����A�t�@�C���T�C�Y���k�߂�Ӗ�������܂��B
REM ----------------------------------------------------------------------
set resize=1
REM ----------------------------------------------------------------------
REM �኱�̃V���[�v�����s�����i0:�s��Ȃ�, 1:�s���j
REM �C�������x�̃V���[�v���ł����A�Ⴆ�΃m�C�Y�������g�又����ɂ͂���Ȃ�ɗL���ł��B
REM ----------------------------------------------------------------------
set sharpen=0

REM ----------------------------------------------------------------------
REM �I����Ɉꎞ�t�@�C�����폜���邩�i0:���Ȃ�, 1:����j
REM �ꎞ�t�@�C���Q���ꊇ�폜�ł��܂��B0���ƕ��u����܂����A��蒼�����ɍė��p�ł��܂��B
REM ----------------------------------------------------------------------
set del_temp=0

REM ----------------------------------------------------------------------
REM ���m�F�K�{�F�t�H���_��
REM ���ɉ����āy�K���z���������Ă��������B
REM ----------------------------------------------------------------------
set output_path=F:\Encode\
set bin_path=C:\DTV\bin\
set logo_path=%bin_path%join_logo_scp\logo\
set cut_result_path=%bin_path%join_logo_scp\result\

REM ----------------------------------------------------------------------
REM ���m�F�K�{�F���s�t�@�C����
REM ���ɉ����āy�K���z���������Ă��������B�킩����͕K�v�Ȃ��̂����Ō��\�ł��B
REM ----------------------------------------------------------------------
set x264=%bin_path%x264.exe
set qsvencc=%bin_path%QSVEncC.exe
set nvencc=%bin_path%NVEncC.exe

set avs2pipemod=%bin_path%avs2pipemod.exe
set fawcl=%bin_path%fawcl.exe
set qaac=%bin_path%qaac.exe
set muxer=%bin_path%muxer.exe
set remuxer=%bin_path%remuxer.exe

set mediainfo=%bin_path%MediaInfo\MediaInfo.exe
set rplsinfo=%bin_path%rplsinfo.exe
set tsspritter=%bin_path%TsSplitter\TsSplitter.exe
set dgindex=%bin_path%DGIndex.exe
set join_logo_scp=%bin_path%join_logo_scp\jlse_bat.bat

REM ----------------------------------------------------------------------
REM �f���G���R�[�_�̃I�v�V����
REM �ݒ�l�̈Ӗ����킩����͎��R�ɉ��ς��Ă��������B
REM ----------------------------------------------------------------------
if %video_encoder% == 0 (
  set x264_opt=--crf 21 --qcomp 0.7 --me umh --subme 9 --direct auto --ref 5 --trellis 2
) else if %video_encoder% == 1 (
  set qsvencc_opt=-c h264 -u 2 --la-icq 24 --la-quality slow --bframes 3 --weightb --weightp
) else if %video_encoder% == 2 (
  set nvencc_opt=--avs -c h264 --cqp 20:22:24 --qp-init 20:22:24 --weightp --aq --aq-temporal
) else if %video_encoder% == 3 (
  set nvencc_opt=--avs -c hevc --cqp 21:22:24 --qp-init 21:22:24 --weightp --aq --aq-temporal
) else (
  echo [�G���[] �G���R�[�_�𐳂����w�肵�Ă��������B
  goto end
)

REM ----------------------------------------------------------------------
REM �ݒ肱���܂�
REM ======================================================================

:loop
if "%~1" == "" goto end
set file_ext=%~x1

echo ======================================================================
echo %~1
echo ----------------------------------------------------------------------
echo �����J�n: %date% %time%
echo ======================================================================
echo.

REM ----------------------------------------------------------------------
REM SD�i���DVD�\�[�X�j�����T�C�Y�擾�Ŕ���
REM ----------------------------------------------------------------------
set is_sd=0
for /f "delims=" %%A in ('%mediainfo% %1 ^| grep "Width" ^| sed -r "s/Width *: (.*) pixels/\1/" ^| sed -r "s/ //"') do set info_width=%%A
if %info_width% == 720 set is_sd=1

REM ----------------------------------------------------------------------
REM �ϐ��Z�b�g
REM ----------------------------------------------------------------------
set file_path=%~dp1
set file_name=%~n1
set file_fullname=%~dpn1
set file_fullpath=%~1

if not %file_ext% == .ts goto not_hd_ts_source
if %is_sd% == 1 goto not_hd_ts_source

set source_fullname=%file_fullname%_HD
set cut_dir_name=%file_name%_HD
goto end_source
:not_hd_ts_source

set source_fullname=%file_fullname%
:end_source

set source_fullpath=%source_fullname%%file_ext%

set avs="%source_fullname%.avs"
set avs_template="%bin_path%.template.avs"
set output_enc="%output_path%%file_name%.enc.mp4"
set output_wav="%output_path%%file_name%.wav"
set output_aac="%output_path%%file_name%.aac"
set output_m4a="%output_path%%file_name%.m4a"
set output_mp4="%output_path%%file_name%.mp4"

REM ----------------------------------------------------------------------
REM �R�[�f�b�N�擾
REM ----------------------------------------------------------------------
for /f "delims=" %%A in ('%mediainfo% -f "%file_fullpath%" ^| grep "Commercial name" ^| head -n 1 ^| sed -r "s/Commercial name *: (.*)/\1/"') do set info_container=%%A
for /f "delims=" %%A in ('%mediainfo% -f "%file_fullpath%" ^| grep "Codecs Video" ^| sed -r "s/Codecs Video *: (.*)/\1/"') do set info_vcodec=%%A
for /f "delims=" %%A in ('%mediainfo% -f "%file_fullpath%" ^| grep "Audio codecs" ^| sed -r "s/Audio codecs *: (.*)/\1/"') do set info_acodec=%%A
for /f "delims=" %%A in ('%mediainfo% -f "%file_fullpath%" ^| grep "Bit depth" ^| head -n 1 ^| sed -r "s/Bit depth *: (.*)/\1/"') do set info_bitdepth=%%A
echo �R���e�i�@�@�@�F%info_container%
echo �f���R�[�f�b�N�F%info_vcodec%
echo �����R�[�f�b�N�F%info_acodec%
echo �r�b�g�[�x�@�@�F%info_bitdepth%�r�b�g
echo.

REM ----------------------------------------------------------------------
REM SD�i���DVD�\�[�X�j�̃A�X�y�N�g���ݒ�
REM ----------------------------------------------------------------------
for /f "delims=" %%A in ('%mediainfo% "%file_fullpath%" ^| grep "Display aspect ratio" ^| sed -r "s/Display aspect ratio *: (.*)/\1/"') do set info_aspect=%%A

if %is_sd% == 1 (
  if %info_aspect% == 16:9 (
    set sar=--sar 32:27
    REM set sar=--sar 40:33
  ) else (
    set sar=--sar 8:9
    REM set sar=--sar 10:11
  )
) else (
  set sar=--sar 1:1
)

REM ----------------------------------------------------------------------
REM �t�B�[���h�I�[�_�[����
REM ----------------------------------------------------------------------
for /f "delims=" %%A in ('%mediainfo% "%source_fullpath%" ^| grep "Scan type" ^| sed -r "s/Scan type *: (.*)/\1/"') do set scan_type=%%A
for /f "delims=" %%A in ('%mediainfo% "%source_fullpath%" ^| grep "Scan order" ^| sed -r "s/Scan order *: (.*)/\1/"') do set scan_order=%%A

if "%scan_type%" == "Progressive" (
  echo ���v���O���b�V�u�\�[�X�ł��B
  echo.
  set order_ref=PROGRESSIVE
  goto end_scan_order
)
if "%scan_order%" == "Bottom Field First" (
  set order_ref=BOTTOM
  if %deint% == 0 set order_tb= --bff
) else (
  set order_ref=TOP
  if %deint% == 0 set order_tb= --tff
)
:end_scan_order

if not %file_ext% == .ts goto end_tssplitter
if not "%info_vcodec%" == "MPEG-2 Video" goto end_tssplitter
if not "%info_acodec%" == "AAC LC" goto end_tssplitter
if %is_sd% == 1 goto end_tssplitter
echo ----------------------------------------------------------------------
echo TSSplitter����
echo ----------------------------------------------------------------------
if %is_sd% == 0 (
  if not exist "%source_fullpath%" (
    call %tsspritter% -EIT -ECM -EMM -SD -1SEG "%file_fullpath%"
  ) else (
    echo �����ς݂̃t�@�C�������݂��Ă��܂��B
  )
) else (
  echo �����͕K�v����܂���B
)
echo.
:end_tssplitter

if not %file_ext% == .ts goto end_dgindex
if not "%info_vcodec%" == "MPEG-2 Video" goto end_dgindex
if not "%info_acodec%" == "AAC LC" goto end_dgindex
if %is_sd% == 1 goto end_dgindex
if not %audio_encoder% == 0 goto end_dgindex
echo ----------------------------------------------------------------------
echo DGIndex����
echo ----------------------------------------------------------------------
if not exist "%source_fullname%.d2v" (
  call %dgindex% -i "%source_fullpath%" -o "%source_fullname%" -ia 5 -fo 0 -yr 2 -om 2 -hide -exit
) else (
  echo �����ς݂̃t�@�C�������݂��Ă��܂��B
)
echo.
:end_dgindex

if not %audio_encoder% == 0 goto end_faw
if not %file_ext% == .ts goto end_faw
if not "%info_vcodec%" == "MPEG-2 Video" goto end_faw
if not "%info_acodec%" == "AAC LC" goto end_faw
if %is_sd% == 1 goto end_faw
echo ----------------------------------------------------------------------
echo  FAW�ɂ��aac �� �^��wav������
echo ----------------------------------------------------------------------
for /f "usebackq tokens=*" %%A in (`dir /b "%source_fullname% PID *.aac"`) do set aac_fullpath=%file_path%%%A
if exist "%source_fullname% PID *_aac.wav" goto exist_wav
call %fawcl% -s2 "%aac_fullpath%"
goto end_audio_split

:exist_wav
echo �^��wav�t�@�C�������݂��Ă��܂��B

:end_audio_split
for /f "usebackq tokens=*" %%A in (`dir /b "%source_fullname% PID *_aac.wav"`) do set wav_fullpath=%file_path%%%A
echo.
:end_faw

echo ----------------------------------------------------------------------
echo avs�t�@�C����������
echo ----------------------------------------------------------------------
if exist %avs% (
  echo avs�t�@�C�������݂��Ă��܂��B
  goto end_avs
)

echo SetMemoryMax(1024)>>%avs%
echo.>>%avs%

echo ### �t�@�C���ǂݍ��� ###>>%avs%
if not %audio_encoder% == 0 goto not_faw
if not %file_ext% == .ts goto not_faw
if not "%info_vcodec%" == "MPEG-2 Video" goto not_faw
if not "%info_acodec%" == "AAC LC" goto not_faw
if %is_sd% == 1 goto not_faw
echo SetMTMode(1, 0)>>%avs%
echo MPEG2Source("%source_fullname%.d2v")>>%avs%
echo SetMTMode(2)>>%avs%
echo AudioDub(last, WAVSource("%wav_fullpath%"))>>%avs%
goto end_fileread

:not_faw
if %info_bitdepth% == 8 echo LWLibavVideoSource("%source_fullpath%")>>%avs%
if not %info_bitdepth% == 8 echo LWLibavVideoSource("%source_fullpath%", format="YUV420P8")>>%avs%
echo AudioDub(last, LWLibavAudioSource("%source_fullpath%", av_sync=true, layout="stereo"))>>%avs%
echo.>>%avs%
echo SetMTMode(2, 0)>>%avs%
echo.>>%avs%

:end_fileread

echo ### �t�B�[���h�I�[�_�[ ###>>%avs%
if %order_ref% == TOP echo AssumeTFF()>>%avs%
if %order_ref% == BOTTOM echo AssumeBFF()>>%avs%
if %order_ref% == PROGRESSIVE echo #Progressive>>%avs%
echo.>>%avs%

echo ### �N���b�v ###>>%avs%
echo #Crop(8, 0, -8, 0)>>%avs%
echo.>>%avs%

if %is_sd% == 1 goto end_cm_cut_logo

echo ### �T�[�r�X���擾 ###>>%avs%
for /f "delims=" %%A in ('%rplsinfo% "%source_fullpath%" -c') do set service=%%A
echo #�T�[�r�X���F%service%>>%avs%
echo.>>%avs%

if %cut_cm% == 0 goto end_auto_trim
echo ### ����CM�J�b�g ###>>%avs%
set cut_fullpath="%cut_result_path%%cut_dir_name%\obs_cut.avs"
if exist %cut_fullpath% goto end_cut_cm
call %join_logo_scp% "%source_fullpath%"

:end_cut_cm
sleep 2
for /f "usebackq tokens=*" %%A in (%cut_fullpath%) do set trim_line=%%A
echo %trim_line%>>%avs%
echo.>>%avs%
goto end_trim

:end_auto_trim

if %cut_cm% == 1 goto end_do_manual_cut
echo ### �蓮Trim ###>>%avs%
echo #Trim()>>%avs%
echo.>>%avs%

:end_trim

if %cut_logo% == 0 goto end_cm_cut_logo
echo ### ���S���� ###>>%avs%
echo EraseLOGO("%logo_path%%service%.lgd", pos_x=0, pos_y=0, depth=128, yc_y=0, yc_u=0, yc_v=0, start=0, fadein=0, fadeout=0, end=-1, interlaced=true)>>%avs%
echo.>>%avs%
:end_cm_cut_logo

if %deint% == 0 goto end_deint
if "%scan_type%" == "Progressive" goto end_deint
echo ### �C���^�[���[�X���� / �t�e���V�l ###>>%avs%
set is_ivtc=0

if %is_sd% == 0 goto not_sd
if %deint_bob% == 0 goto set_deint
if %deint_bob% == 1 goto set_deint_bob

:not_sd
for /f "delims=" %%A in ('%rplsinfo% "%source_fullpath%" -g') do set genre=%%A
echo #�W���������F%genre%>>%avs%
if "%scan_type%" == "Progressive" goto end_deint

echo %genre% | find " ���J���̂Ɏ��s���܂���." > NUL
if not ERRORLEVEL 1 if %deint_bob% == 0 goto set_deint
if not ERRORLEVEL 1 if %deint_bob% == 1 goto set_deint_bob

echo %genre% | find "�A�j��" > NUL
if not ERRORLEVEL 1 goto set_deint_it
echo %genre% | find "�f��" > NUL
if not ERRORLEVEL 1 goto set_deint_it

:set_deint
if %gpu_deint% == 1 goto set_deint_gpu
echo #TIVTC24P2()>>%avs%
echo TDeint(edeint=nnedi3)>>%avs%
echo #TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%
echo #D3DVP(mode=0, device="%d3dvp_device%")>>%avs%
echo #GPU_Begin()>>%avs%
echo #GPU_IT(fps=24, ref="%order_ref%", blend=false)>>%avs%
echo #GPU_End()>>%avs%
goto end_deint
echo.>>%avs%

:set_deint_gpu
echo #TIVTC24P2()>>%avs%
echo #TDeint(edeint=nnedi3)>>%avs%
echo #TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%
echo D3DVP(mode=0, device="%d3dvp_device%")>>%avs%
echo #GPU_Begin()>>%avs%
echo #GPU_IT(fps=24, ref="%order_ref%", blend=false)>>%avs%
echo #GPU_End()>>%avs%
goto end_deint
echo.>>%avs%

:set_deint_bob
if %gpu_deint% == 1 goto set_deint_bob_gpu
echo #TIVTC24P2()>>%avs%
echo #TDeint(edeint=nnedi3)>>%avs%
echo TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo #D3DVP(mode=1, device="%d3dvp_device%")>>%avs%
echo.>>%avs%
echo #D3DVP(mode=1, device="%d3dvp_device%")>>%avs%
echo #GPU_Begin()>>%avs%
echo #GPU_IT(fps=24, ref="%order_ref%", blend=false)>>%avs%
echo #GPU_End()>>%avs%
goto end_deint
echo.>>%avs%

:set_deint_bob_gpu
echo #TIVTC24P2()>>%avs%
echo #TDeint(edeint=nnedi3)>>%avs%
echo #TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%
echo D3DVP(mode=1, device="%d3dvp_device%")>>%avs%
echo #GPU_Begin()>>%avs%
echo #GPU_IT(fps=24, ref="%order_ref%", blend=false)>>%avs%
echo #GPU_End()>>%avs%
goto end_deint
echo.>>%avs%

:set_deint_it
set is_ivtc=1
if %gpu_deint% == 1 goto set_deint_it_gpu
echo TIVTC24P2()>>%avs%
echo #TDeint(edeint=nnedi3)>>%avs%
echo #TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%
echo #D3DVP(mode=0, device="%d3dvp_device%")>>%avs%
echo #GPU_Begin()>>%avs%
echo #GPU_IT(fps=24, ref="%order_ref%", blend=false)>>%avs%
echo #GPU_End()>>%avs%
goto end_deint
echo.>>%avs%

:set_deint_it_gpu
echo #TIVTC24P2()>>%avs%
echo #TDeint(edeint=nnedi3)>>%avs%
echo #TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%
echo D3DVP(mode=0, device="%d3dvp_device%")>>%avs%
echo GPU_Begin()>>%avs%
echo GPU_IT(fps=24, ref="%order_ref%", blend=false)>>%avs%
echo GPU_End()>>%avs%
goto end_deint
echo.>>%avs%

:end_deint

echo ### �m�C�Y���� ###>>%avs%
if %denoize% == 0 goto not_denoize
set is_anime=0
echo %genre% | find "�A�j��" > NUL
if not ERRORLEVEL 1 set is_anime=1

echo GPU_Begin()>>%avs%
if %is_anime% == 1 goto anime_hq
echo GPU_Convolution3d(preset="movieLQ")>>%avs%
echo #GPU_Convolution3d(preset="animeLQ")>>%avs%
goto end_mov_anm

:anime_hq
echo #GPU_Convolution3d(preset="movieLQ")>>%avs%
echo GPU_Convolution3d(preset="animeLQ")>>%avs%

:end_mov_anm
echo GPU_End()>>%avs%
goto end_denoize

:not_denoize
echo #GPU_Begin()>>%avs%
echo #GPU_Convolution3d(preset="movieLQ")>>%avs%
echo #GPU_Convolution3d(preset="animeLQ")>>%avs%
echo #GPU_End()>>%avs%
:end_denoize
echo.>>%avs%

if %is_sd% == 1 goto end_resize
if %resize% == 0 goto end_resize

echo ### ���T�C�Y ###>>%avs%
echo (Width() ^> 1280) ? Spline36Resize(1280, 720) : last>>%avs%
echo.>>%avs%
:end_resize

echo ### �V���[�v�� ###>>%avs%
if %sharpen% == 0 goto not_sharpen
echo Sharpen(0.02)>>%avs%
goto end_sharpen

:not_sharpen
echo #Sharpen(0.02)>>%avs%
:end_sharpen
echo.>>%avs%

echo ### ���̑��̏��� ###>>%avs%
echo.>>%avs%

echo return last>>%avs%

if %deint% == 0 goto end_tivtc24p2
if "%scan_type%" == "Progressive" goto end_tivtc24p2
echo.>>%avs%
echo function TIVTC24P2(clip clip){>>%avs%
echo Deinted=clip.TDeint(order=-1,field=-1,edeint=clip.nnedi3(field=-1))>>%avs%
echo clip = clip.TFM(mode=6,order=-1,PP=7,slow=2,mChroma=true,clip2=Deinted)>>%avs%
echo clip = clip.TDecimate(mode=1)>>%avs%
echo return clip>>%avs%
echo }>>%avs%
:end_tivtc24p2

echo avs�t�@�C���𐶐����܂����B
echo %avs%

:end_avs
echo.

if %check_avs% == 1 (
  echo ��avs�t�@�C���m�F�I�v�V�������ݒ肳��Ă��܂��B
  echo ���m�F�E�ҏW������͉����L�[�������Ώ����𑱍s�ł��܂��B
  echo.
  pause
)
echo.

echo ----------------------------------------------------------------------
echo �f������
echo ----------------------------------------------------------------------
if not exist %output_enc% (
  if %video_encoder% == 0 (
    call %x264% %x264_opt% %sar%%order_tb% -o %output_enc% %avs%
  ) else if %video_encoder% == 1 (
    call %qsvencc% %qsvencc_opt% %sar%%order_tb% -i %avs% -o %output_enc%
  ) else if %video_encoder% == 2 (
    call %nvencc% %nvencc_opt% %sar%%order_tb% -i %avs% -o %output_enc%
  ) else if %video_encoder% == 3 (
    call %nvencc% %nvencc_opt% %sar%%order_tb% -i %avs% -o %output_enc%
  )
) else (
  echo �G���R�[�h�ς݉f���t�@�C�������݂��Ă��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo ��������
echo ----------------------------------------------------------------------
if not exist %output_wav% (
  call %avs2pipemod% -wav %avs% > %output_wav%
) else (
  echo ����wav�t�@�C�������݂��Ă��܂��B
)
if %audio_encoder% == 1 goto qaac_encode
if not %file_ext% == .ts goto qaac_encode
if %is_sd% == 1 goto qaac_encode

if not exist %output_aac% (
  call %fawcl% %output_wav% %output_aac%
) else (
  echo �G���R�[�h�ς�aac�t�@�C�������݂��Ă��܂��B
)
goto end_audio_encode

:qaac_encode
if not exist %output_aac% (
  call %qaac% -q 2 --tvbr 95 %output_wav% -o %output_aac%
) else (
  echo �G���R�[�h�ς�aac�t�@�C�������݂��Ă��܂��B
)

:end_audio_encode
echo.

echo ----------------------------------------------------------------------
echo muxer����
echo ----------------------------------------------------------------------
if not exist %output_m4a% (
  call %muxer% -i %output_aac% -o %output_m4a%
) else (
  echo muxer�ς݂�m4a�t�@�C�������݂��Ă��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo remuxer����
echo ----------------------------------------------------------------------
if not exist %output_mp4% (
  call %remuxer% -i %output_enc% -i %output_m4a% -o %output_mp4%
) else (
  echo remuxer�ς݂�mp4�t�@�C�������݂��Ă��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo �ꎞ�t�@�C������
echo ----------------------------------------------------------------------
if %del_temp% == 0 goto no_del_temp

echo �ꎞ�t�@�C�����폜���܂��B
echo.

set del_hd_file=0
if %file_ext% == .ts if %is_sd% == 0 set del_hd_file=1

if exist "%file_fullname%.lwi" del /f /q "%file_fullname%.lwi" & echo "%file_fullname%.lwi"
if exist "%source_fullpath%.lwi" del /f /q "%source_fullpath%.lwi" & echo "%source_fullpath%.lwi"
if exist "%source_fullname%.d2v" del /f /q "%source_fullname%.d2v" & echo "%source_fullname%.d2v"
if exist "%source_fullname%.d2v" del /f /q "%source_fullname%.d2v.lwi" & echo "%source_fullname%.d2v.lwi"
if exist "%source_fullname%.log" del /f /q "%source_fullname%.log" & echo "%source_fullname%.log"
if exist "%aac_fullpath%.lwi" del /f /q "%aac_fullpath%.lwi" & echo "%aac_fullpath%.lwi"
if exist "%wav_fullpath%.lwi" del /f /q "%wav_fullpath%.lwi" & echo "%wav_fullpath%.lwi"
if exist %avs% del /f /q %avs%
if exist "%aac_fullpath%" del /f /q "%aac_fullpath%" & echo "%aac_fullpath%"
if exist "%wav_fullpath%" del /f /q "%wav_fullpath%" & echo "%wav_fullpath%"
if %del_hd_file% == 1 if exist "%source_fullpath%" del /f /q "%source_fullpath%" & echo "%source_fullpath%"
if exist %output_enc% del /f /q %output_enc% & echo %output_enc%
if exist %output_wav% del /f /q %output_wav% & echo %output_wav%
if exist %output_aac% del /f /q %output_aac% & echo %output_aac%
if exist %output_m4a% del /f /q %output_m4a% & echo %output_m4a%
echo.
goto end_del_temp

:no_del_temp
echo �ꎞ�t�@�C���Q�͎c���Ă���A������s���ɍė��p�i�������X�L�b�v�j�ł��܂��B
echo ����̏�������蒼�������ꍇ�́A�Y���t�@�C�����폜���čĎ��s���Ă��������B
echo �s�v�ɂȂ�����A���ׂĂ̈ꎞ�t�@�C�����폜���č\���܂���B
echo.
:end_del_temp

echo ======================================================================
echo %output_mp4%
echo ----------------------------------------------------------------------
echo �����I��: %date% %time%
echo ======================================================================
echo.

shift
goto loop
:end

pause
