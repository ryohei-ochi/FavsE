@echo off

echo FavsE (FullAuto AVS Encode) 2.10
echo.

REM ----------------------------------------------------------------------
REM �f���G���R�[�_�̎w��i0:x264, 1:QSV, 2:NVEnc_AVC, 3:NVEnc_HEVC�j
REM ----------------------------------------------------------------------
set video_encoder=0
REM ----------------------------------------------------------------------
REM �����G���R�[�_�̎w��i0:FAW, 1:qaac�j
REM ----------------------------------------------------------------------
set audio_encoder=0

REM ----------------------------------------------------------------------
REM ����CM�J�b�g�̏������s�����i0:�s��Ȃ�, 1:�s���j
REM ----------------------------------------------------------------------
set cut_cm=0
REM ----------------------------------------------------------------------
REM ���S�����̏������s�����i0:�s��Ȃ�, 1:�s���j
REM ----------------------------------------------------------------------
set cut_logo=1
REM ----------------------------------------------------------------------
REM avs������ɏ������ꎞ��~���邩�i0:���Ȃ�, 1:����j���قڎ蓮CM�J�b�g�p
REM ----------------------------------------------------------------------
set check_avs=1

REM ----------------------------------------------------------------------
REM �C���^�[���[�X�������s�����i0:�C���^�[���[�X�ێ�, 1:�C���^�[���[�X�����j
REM ----------------------------------------------------------------------
set deint=0
REM ----------------------------------------------------------------------
REM SD�i���DVD�\�[�X�j�̃C���^�[���[�X�������[�h�i0:�ʏ�, 1:BOB��, 2:24fps���j
REM ----------------------------------------------------------------------
set deint_mode=1
REM ----------------------------------------------------------------------
REM �C���^�[���[�X���� / �t�e���V�l��GPU�ōs�����i0:�s��Ȃ�, 1:�s���j
REM �g�p����f�o�C�X����������ꍇ�� Intel, NVIDIA, Radeon����w�肵�Ă�������
REM ----------------------------------------------------------------------
set gpu_deint=0
set d3dvp_device=Intel

REM ----------------------------------------------------------------------
REM GPU�ɂ��m�C�Y�������s�����i0:�s��Ȃ�, 1:�s���j
REM ----------------------------------------------------------------------
set denoize=0
REM ----------------------------------------------------------------------
REM Width��1280px�𒴂���ꍇ��1280x720px�ɏk�����邩�i0:���Ȃ�, 1:����j
REM ----------------------------------------------------------------------
set resize=1
REM ----------------------------------------------------------------------
REM �኱�̃V���[�v�����s�����i0:�s��Ȃ�, 1:�s���j
REM ----------------------------------------------------------------------
set sharpen=0

REM ----------------------------------------------------------------------
REM �I����Ɉꎞ�t�@�C�����폜���邩�i0:���Ȃ�, 1:����j
REM ----------------------------------------------------------------------
set del_temp=0

REM ----------------------------------------------------------------------
REM �G���R�[�_�̃I�v�V�����i�r�b�g���[�g�A�A�X�y�N�g��͎����ݒ�j
REM ----------------------------------------------------------------------
if %video_encoder% == 0 (
  set x264_opt=--crf 20 --qcomp 0.7 --me umh --subme 9 --direct auto --ref 5 --trellis 2
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
REM �t�H���_��(���ɉ����ď��������Ă�������)
REM ----------------------------------------------------------------------
set output_path=F:\Encode\
set bin_path=C:\DTV\bin\
set logo_path=%bin_path%join_logo_scp\logo\
set cut_result_path=%bin_path%join_logo_scp\result\

REM ----------------------------------------------------------------------
REM ���s�t�@�C���_��(���ɉ����ď��������Ă�������)
REM ----------------------------------------------------------------------
set x264=%bin_path%x264.exe
set qsvencc=%bin_path%QSVEncC.exe
set nvencc=%bin_path%NVEncC.exe

set avs2pipemod=%bin_path%avs2pipemod.exe
set fawcl=%bin_path%fawcl.exe
set wavi=%bin_path%wavi.exe
set qaac=%bin_path%qaac.exe
set muxer=%bin_path%muxer.exe
set remuxer=%bin_path%remuxer.exe

set mediainfo=%bin_path%MediaInfo\MediaInfo.exe
set rplsinfo=%bin_path%rplsinfo.exe
set tsspritter=%bin_path%TsSplitter\TsSplitter.exe
set ts_parser=%bin_path%ts_parser\ts_parser.exe
set join_logo_scp=%bin_path%join_logo_scp\jlse_bat.bat

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
for /f "delims=" %%A in ('%mediainfo% %1 ^| grep "Width" ^| sed -r "s/Width *: (.*) pixels/\1/" ^| sed -r "s/ //"') do set width=%%A
if %width% == 720 set is_sd=1

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
set output_enc="%output_path%%file_name%.enc.mp4"
set output_wav="%output_path%%file_name%.wav"
set output_aac="%output_path%%file_name%.aac"
set output_m4a="%output_path%%file_name%.m4a"
set output_mp4="%output_path%%file_name%.mp4"

REM ----------------------------------------------------------------------
REM SD�i���DVD�\�[�X�j�̃A�X�y�N�g���ݒ�
REM ----------------------------------------------------------------------
for /f "delims=" %%A in ('%mediainfo% "%file_fullpath%" ^| grep "Width" ^| sed -r "s/Width *: (.*) pixels/\1/" ^| sed -r "s/ //"') do set width=%%A
for /f "delims=" %%A in ('%mediainfo% "%file_fullpath%" ^| grep "Display aspect ratio" ^| sed -r "s/Display aspect ratio *: (.*)/\1/"') do set aspect=%%A

if %width% == 720 (
  if %aspect% == 16:9 (
    set sar=--sar 32:27
    REM set sar=--sar 40:33
  ) else (
    set sar=--sar 8:9
    REM set sar=--sar 10:11
  )
) else (
  set sar=--sar 1:1
)

if not %file_ext% == .ts goto end_tssplitter
echo ----------------------------------------------------------------------
echo TSSplitter����
echo ----------------------------------------------------------------------
if %is_sd% == 0 (
  if not exist "%source_fullpath%" (
    call %tsspritter% -EIT -ECM -EMM -SD -1SEG "%file_fullpath%"
  ) else (
    echo ���ɏ����ς݂̃t�@�C�������݂��܂��B
  )
) else (
  echo �����͕K�v����܂���B
)
echo.
:end_tssplitter

if not %audio_encoder% == 0 goto end_audio_split
echo ----------------------------------------------------------------------
echo  ������������
echo ----------------------------------------------------------------------
if not exist "%source_fullname% PID *.aac" (
  call %ts_parser% --mode dam --delay-type 3 --rb-size 16384 --wb-size 32768 "%source_fullpath%"
) else (
  echo ���ɕ������ꂽ�����t�@�C�������݂��܂��B
)
for /f "usebackq tokens=*" %%A in (`dir /b "%source_fullname% PID *.aac"`) do set aac_fullpath=%file_path%%%A
echo.
:end_audio_split

echo ----------------------------------------------------------------------
echo avs�t�@�C����������
echo ----------------------------------------------------------------------
if exist %avs% (
  echo ����avs�t�@�C�������݂��܂��B
  goto end_avs
)

echo SetMemoryMax(2048)>>%avs%
echo.>>%avs%

echo ### �t�@�C���ǂݍ��� ###>>%avs%
echo LWLibavVideoSource("%source_fullpath%", format="YUV420P8")>>%avs%
if %audio_encoder% == 0 echo AudioDub(last, AACFaw("%aac_fullpath%"))>>%avs%
if %audio_encoder% == 1 echo AudioDub(last, LWLibavAudioSource("%source_fullpath%", av_sync=true, layout="stereo"))>>%avs%
echo.>>%avs%

echo SetMTMode(2, 0)>>%avs%
echo AssumeFPS(30000, 1001)>>%avs%
echo.>>%avs%

echo ### �N���b�v ###>>%avs%
echo #Crop(8, 0, -8, 0)>>%avs%
echo.>>%avs%

echo ### �t�B�[���h�I�[�_�[ ###>>%avs%
for /f "delims=" %%A in ('%mediainfo% "%source_fullpath%" ^| grep "Scan type" ^| sed -r "s/Scan type *: (.*)/\1/"') do set scan_type=%%A
for /f "delims=" %%A in ('%mediainfo% "%source_fullpath%" ^| grep "Scan order" ^| sed -r "s/Scan order *: (.*)/\1/"') do set scan_order=%%A

if "%scan_type%" == "Progressive" (
  echo # %scan_type%>>%avs%
  goto end_scan
)
if "%scan_order%" == "Bottom Field First" (
  set order_ref=BOTTOM
) else (
  set order_ref=TOP
)
if %order_ref% == TOP echo AssumeTFF()>>%avs%
if %order_ref% == BOTTOM echo AssumeBFF()>>%avs%
:end_scan
echo.>>%avs%

if %is_sd% == 1 goto end_cm_cut_logo
echo SetMTMode(1)>>%avs%
echo.>>%avs%
echo ### ���蓮Trim�͂������ ###>>%avs%
echo.>>%avs%

echo ### �T�[�r�X���擾 ###>>%avs%
for /f "delims=" %%A in ('%rplsinfo% "%source_fullpath%" -c') do set service=%%A
echo #�T�[�r�X���F%service%>>%avs%
echo.>>%avs%

if %cut_cm% == 0 goto end_do_cut_cm
echo ### ����CM�J�b�g ###>>%avs%
set cut_fullpath="%cut_result_path%%cut_dir_name%\obs_cut.avs"
if exist %cut_fullpath% goto end_cut_cm
call %join_logo_scp% "%source_fullpath%"
:end_cut_cm

sleep 2
for /f "usebackq tokens=*" %%A in (%cut_fullpath%) do set trim_line=%%A
echo %trim_line%>>%avs%
echo.>>%avs%
:end_do_cut_cm

if %cut_logo% == 0 goto end_cm_cut_logo
echo ### ���S���� ###>>%avs%
echo EraseLOGO("%logo_path%%service%.lgd", pos_x=0, pos_y=0, depth=128, yc_y=0, yc_u=0, yc_v=0, start=0, fadein=0, fadeout=0, end=-1, interlaced=true)>>%avs%
echo.>>%avs%

:end_cm_cut_logo

echo SetMTMode(2)>>%avs%
echo.>>%avs%

if %deint% == 0 goto end_deint
if "%scan_type%" == "Progressive" goto end_deint
echo ### �C���^�[���[�X���� / �t�e���V�l ###>>%avs%
set is_ivtc=0

if %is_sd% == 0 goto not_sd
if %deint_mode% == 0 goto set_deint
if %deint_mode% == 1 goto set_deint_bob
if %deint_mode% == 2 goto set_deint_it

:not_sd
for /f "delims=" %%A in ('%rplsinfo% "%source_fullpath%" -g') do set genre=%%A
echo #�W���������F%genre%>>%avs%
if "%scan_type%" == "Progressive" goto end_deint

echo %genre% | find " ���J���̂Ɏ��s���܂���." > NUL
if not ERRORLEVEL 1 goto set_deint

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

:end_deint
echo.>>%avs%

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

echo ### �������x���␳ ###>>%avs%
echo #ColorYUV(autogain=true, cont_u=64, cont_v=64)>>%avs%
echo.>>%avs%

echo ### �A�b�v�R���o�[�g ###>>%avs%
echo #nnedi3_rpow2(rfactor=2, cshift="Spline36Resize")>>%avs%
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

:end_avs
echo.

if %check_avs% == 1 (
  echo ��avs�t�@�C���m�F�I�v�V�������ݒ肳��Ă��܂��B
  echo ��avs�t�@�C�����m�F���A�K�v�ł���ΕҏW���Ă��������B
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
    if %deint% == 0 call %x264% %x264_opt% %sar% --tff -o %output_enc% %avs%
    if %deint% == 1 call %x264% %x264_opt% %sar% -o %output_enc% %avs%
  ) else if %video_encoder% == 1 (
    call %qsvencc% %qsvencc_opt% %sar% -i %avs% -o %output_enc%
  ) else if %video_encoder% == 2 (
    call %nvencc% %nvencc_opt% %sar% -i %avs% -o %output_enc%
  ) else if %video_encoder% == 3 (
    call %nvencc% %nvencc_opt% %sar% -i %avs% -o %output_enc%
  )
) else (
  echo ���ɃG���R�[�h�ς݃t�@�C�������݂��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo ��������
echo ----------------------------------------------------------------------
if %audio_encoder% == 0 (
  if not exist %output_wav% (
    call %avs2pipemod% -wav %avs% > %output_wav%
  ) else (
    echo ����wav�t�@�C�������݂��܂��B
  )
  if not exist %output_aac% (
    call %fawcl% %output_wav% %output_aac%
  ) else (
    echo ����aac�t�@�C�������݂��܂��B
  )
) else if %audio_encoder% == 1 (
  if not exist %output_wav% (
    call %wavi% %avs% %output_wav%
  ) else (
    echo ����wav�t�@�C�������݂��܂��B
  )
  if not exist %output_aac% (
    call %qaac% -q 2 --tvbr 109 %output_wav% -o %output_aac%
  ) else (
    echo ����aac�t�@�C�������݂��܂��B
  )
)
echo.

echo ----------------------------------------------------------------------
echo muxer����
echo ----------------------------------------------------------------------
if not exist %output_m4a% (
  call %muxer% -i %output_aac% -o %output_m4a%
) else (
  echo ����m4a�t�@�C�������݂��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo remuxer����
echo ----------------------------------------------------------------------
if not exist %output_mp4% (
  call %remuxer% -i %output_enc% -i %output_m4a% -o %output_mp4%
) else (
  echo ����mp4�t�@�C�������݂��܂��B
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

if exist "%file_fullname%.lwi" del /f /q "%file_fullname%.lwi"
if exist "%source_fullpath%.lwi" del /f /q "%source_fullpath%.lwi"
if exist "%aac_fullpath%.lwi" del /f /q "%aac_fullpath%.lwi"
if exist %avs% del /f /q %avs%
if exist "%aac_fullpath%" del /f /q "%aac_fullpath%"
if %del_hd_file% == 1 if exist "%source_fullpath%" del /f /q "%source_fullpath%"
if exist %output_enc% del /f /q %output_enc%
if exist %output_wav% del /f /q %output_wav%
if exist %output_aac% del /f /q %output_aac%
if exist %output_m4a% del /f /q %output_m4a%

if not exist "%file_fullname%.lwi" echo "%file_fullname%.lwi"
if not exist "%source_fullpath%.lwi" echo "%source_fullpath%.lwi"
if not exist "%aac_fullpath%.lwi" echo "%aac_fullpath%.lwi"
if not exist %avs% echo %avs%
if not exist "%aac_fullpath%" echo "%aac_fullpath%"
if %del_hd_file% == 1 if not exist "%source_fullpath%" echo "%source_fullpath%"
if not exist %output_enc% echo %output_enc%
if not exist %output_wav% echo %output_wav%
if not exist %output_aac% echo %output_aac%
if not exist %output_m4a% echo %output_m4a%
echo.
goto end_del_temp

:no_del_temp
echo �ꎞ�t�@�C���Q�͎c���Ă���A����G���R�[�h����ۂɂ͍ė��p�i�������X�L�b�v�j���܂��B
echo ����̏�������蒼�������ꍇ�́A�Y�������̈ꎞ�t�@�C�����폜���čĎ��s���Ă��������B
echo �s�v�ɂȂ�����A���ׂĂ̈ꎞ�t�@�C���͍폜���č\���܂���B
echo.
:end_del_temp

echo ======================================================================
echo %output_mp4%
echo ----------------------------------------------------------------------
echo �����I��: %date% %time%
echo ======================================================================

shift
goto loop
:end

pause
