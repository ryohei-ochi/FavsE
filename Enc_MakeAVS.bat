@echo off

REM -----------------------------------------------------------------------
REM NVEncC�܂���x264�̃I�v�V����(�R�����g�C������Ă�������G���R�[�h�Ɏg�p����܂�)
REM -----------------------------------------------------------------------
set nvencc_opt=--avs --cqp 21:23:23
REM set x264_opt=--crf 21 --qpmin 10 --qcomp 0.8 --scenecut 50 --min-keyint 1 --direct auto --weightp 1 --bframes 4 --b-adapt 2 --b-pyramid normal --ref 4 --rc-lookahead 50 --qpstep 4 --aq-mode 2 --aq-strength 0.80 --me umh --subme 9 --psy-rd 0.6:0 --trellis 1 --no-fast-pskip --no-dct-decimate --thread-input

REM -----------------------------------------------------------------------
REM �t�H���_��(�K�v�ɉ����ď��������Ă�������)
REM -----------------------------------------------------------------------
set output_path=F:\Encode\
set bin_path=C:\DTV\bin\
set logo_path=%bin_path%join_logo_scp\logo\
set cut_result_path=%bin_path%join_logo_scp\result\

REM -----------------------------------------------------------------------
REM ���s�t�@�C���_��(�K�v�ɉ����ď��������Ă�������)
REM -----------------------------------------------------------------------
set nvencc=%bin_path%NVEncC.exe
set avs2pipemod=%bin_path%avs2pipemod.exe
set fawcl=%bin_path%fawcl.exe
set muxer=%bin_path%muxer.exe
set remuxer=%bin_path%remuxer.exe

set mediainfo=%bin_path%MediaInfo\MediaInfo.exe
set rplsinfo=%bin_path%rplsinfo.exe
set ts_spritter=%bin_path%TsSplitter\TsSplitter.exe
set ts_parser=%bin_path%ts_parser\ts_parser.exe
set join_logo_scp=%bin_path%join_logo_scp\jlse_bat.bat

REM -----------------------------------------------------------------------
REM ���[�v�����̊J�n
REM -----------------------------------------------------------------------
:loop
if "%~1" == "" goto end

if %~x1 == .ts (
  echo.
) else (
  echo [�G���[] �ϊ�����TS�t�@�C�����h���b�v���Ă��������B
  echo.
  goto :end
)
REM -----------------------------------------------------------------------
REM DVD�\�[�X������
REM -----------------------------------------------------------------------
set is_dvd=0
for /f "delims=" %%A in ('%mediainfo% %1 ^| grep "Width" ^| sed -r "s/Width *: (.*) pixels/\1/" ^| sed -r "s/ //"') do set width=%%A
if %width% == 720 set is_dvd=1

REM -----------------------------------------------------------------------
REM �ϐ��Z�b�g
REM -----------------------------------------------------------------------
set file_path=%~dp1
set file_name=%~n1
set file_fullpath=%~dpn1

if %is_dvd% == 1 goto :SET_DVD
set source_file_name=%file_fullpath%_HD
set cut_dir_name=%file_name%_HD
goto :END_SET
:SET_DVD
set source_file_name=%file_fullpath%
:END_SET
set source_file_fullpath=%source_file_name%.ts

set avs="%file_fullpath%.avs"
set output_enc="%output_path%%file_name%.enc.mp4"
set output_wav="%output_path%%file_name%.wav"
set output_aac="%output_path%%file_name%.aac"
set output_m4a="%output_path%%file_name%.m4a"
set output_mp4="%output_path%%file_name%.mp4"

echo ======================================================================
echo �����J�n
echo ======================================================================
echo %file_fullpath%
echo.

REM -----------------------------------------------------------------------
REM DVD�\�[�X�̂݃A�X�y�N�g���ύX
REM -----------------------------------------------------------------------
for /f "delims=" %%A in ('%mediainfo% "%source_file_fullpath%" ^| grep "Width" ^| sed -r "s/Width *: (.*) pixels/\1/" ^| sed -r "s/ //"') do set width=%%A
for /f "delims=" %%A in ('%mediainfo% "%source_file_fullpath%" ^| grep "Display aspect ratio" ^| sed -r "s/Display aspect ratio *: (.*)/\1/"') do set aspect=%%A

if %width% == 720 (
  if %aspect% == 16:9 (
    set sar=--sar 32:27
  ) else (
    set sar=--sar 8:9
  )
) else (
  set sar=--sar 1:1
)

echo ======================================================================
echo TSSplitter����
echo ======================================================================
if not exist "%source_file_fullpath%" (
  call %ts_spritter% -EIT -ECM -EMM -SD -1SEG "%file_fullpath%.ts"
) else (
   echo ���Ƀt�@�C�������݂��܂��B
)
echo.

echo ======================================================================
echo  ������������
echo ======================================================================
if not exist "%source_file_name% PID *.aac" (
  call %ts_parser% --mode da --delay-type 3 --rb-size 16384 --wb-size 32768 "%source_file_fullpath%"
) else (
  echo ���Ƀt�@�C�������݂��܂��B
)
for /f "usebackq tokens=*" %%A in (`dir /b "%source_file_name% PID *.aac"`) do set aac_fullpath=%file_path%%%A
echo.


echo ======================================================================
echo avs�t�@�C����������
echo ======================================================================
if exist %avs% del %avs%

echo SetMemoryMax(2048)>>%avs%
echo.>>%avs%

echo ### �t�@�C���ǂݍ��� ###>>%avs%
echo LWLibavVideoSource("%source_file_fullpath%", fpsnum=30000, fpsden=1001)>>%avs%
echo AudioDub(last, AACFaw("%aac_fullpath%"))>>%avs%
echo.>>%avs%

echo SetMTMode(2, 0)>>%avs%
echo.>>%avs%

echo ### �t�B�[���h�I�[�_�[ ###>>%avs%
for /f "delims=" %%A in ('%mediainfo% "%source_file_fullpath%" ^| grep "Scan type" ^| sed -r "s/Scan type *: (.*)/\1/"') do set scan_type=%%A
for /f "delims=" %%A in ('%mediainfo% "%source_file_fullpath%" ^| grep "Scan order" ^| sed -r "s/Scan order *: (.*)/\1/"') do set scan_order=%%A

if "%scan_type%" == "Progressive" (
  echo # %scan_type%>>%avs%
  goto :end_scan
)
if "%scan_order%" == "Top Field First" echo AssumeTFF()>>%avs%
if "%scan_order%" == "Bottom Field First" echo AssumeBFF()>>%avs%
:end_scan
echo.>>%avs%

if %is_dvd% == 1 goto :end_cm_logo_cut
echo SetMTMode(1, 0)>>%avs%
echo.>>%avs%

echo ### CM�J�b�g ###>>%avs%
set cut_fullpath="%cut_result_path%%cut_dir_name%\obs_cut.avs"
if exist %cut_fullpath% goto :end_cm_cut
call %join_logo_scp% "%source_file_fullpath%"
:end_cm_cut

sleep 2
for /f "usebackq tokens=*" %%A in (%cut_fullpath%) do set trim_line=%%A
echo %trim_line%>>%avs%
echo.>>%avs%

echo ### ���S���� ###>>%avs%
for /f "delims=" %%A in ('%rplsinfo% "%source_file_fullpath%" -c') do set service=%%A
echo #�T�[�r�X���F%service%>>%avs%
echo EraseLOGO("%logo_path%%service%.lgd", pos_x=0, pos_y=0, depth=128, yc_y=0, yc_u=0, yc_v=0, start=0, fadein=0, fadeout=0, end=-1, interlaced=true)>>%avs%
echo.>>%avs%

echo SetMTMode(2, 0)>>%avs%
echo.>>%avs%
:end_cm_logo_cut

if "%scan_type%" == "Progressive" goto :end_deint
echo ### �t�e���V�l / �C���^�[���[�X���� ###>>%avs%
set is_ivtc=0

if %is_dvd% == 0 goto :not_dvd
echo #TIVTC24P2()>>%avs%
echo #TDeint(edeint=nnedi3)>>%avs%
echo TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%
goto :end_not_dvd

:not_dvd
for /f "delims=" %%A in ('%rplsinfo% "%source_file_fullpath%" -g') do set genre=%%A
echo #�W���������F%genre%>>%avs%
if "%scan_type%" == "Progressive" goto :end_deint
echo %genre% | find "�f��" > NUL
if not ERRORLEVEL 1 goto :set_tivtc24p2
echo %genre% | find "�A�j��" > NUL
if not ERRORLEVEL 1 goto :set_tivtc24p2
goto :set_tdeint
goto :end_deint

:set_tivtc24p2
set is_ivtc=1
echo TIVTC24P2()>>%avs%
echo #TDeint(edeint=nnedi3)>>%avs%
echo #TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%
goto :end_deint
:set_tdeint
echo #TIVTC24P2()>>%avs%
echo TDeint(edeint=nnedi3)>>%avs%
echo #TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%
:end_deint

:end_not_dvd

if %is_dvd% == 1 goto :end_resize
echo ### ���T�C�Y ###>>%avs%
echo (Width() ^> 1280) ? Spline36Resize(1280, 720, 0, 0.6) : last>>%avs%
echo.>>%avs%

:end_resize

echo return last>>%avs%

if "%scan_type%" == "Progressive" goto :end_tivtc24p2
echo.>>%avs%
echo function TIVTC24P2(clip clip){>>%avs%
echo Deinted=clip.TDeint(order=-1,field=-1,edeint=clip.nnedi3(field=-1))>>%avs%
echo clip = clip.TFM(mode=6,order=-1,PP=7,slow=2,mChroma=true,clip2=Deinted)>>%avs%
echo clip = clip.TDecimate(mode=1)>>%avs%
echo return clip>>%avs%
echo }>>%avs%
:end_tivtc24p2

echo avs�t�@�C���𐶐����܂����B
echo.

echo ======================================================================
echo �f���G���R�[�h
echo ======================================================================
if not exist %output_enc% (
  if defined %nvencc_opt% call %nvencc% %nvencc_opt% %sar% -i %avs% -o %output_enc%
  if defined %x264_opt% call %x264% %x264_opt% %sar% -o %output_enc% %avs%
) else (
   echo ���Ƀt�@�C�������݂��܂��B
)
echo.

echo ======================================================================
echo ��������
echo ======================================================================
if not exist %output_wav% (
  call %avs2pipemod% -wav %avs% > %output_wav%
) else (
   echo ���Ƀt�@�C�������݂��܂��B
)
if not exist %output_aac% (
  call %fawcl% %output_wav% %output_aac%
) else (
   echo ���Ƀt�@�C�������݂��܂��B
)
echo.

echo ======================================================================
echo muxer
echo ======================================================================
call %muxer% -i %output_aac% -o %output_m4a%
echo.

echo ======================================================================
echo remuxer
echo ======================================================================
call %remuxer% -i %output_enc% -i %output_m4a% -o %output_mp4%
echo.

echo ======================================================================
echo �ꎞ�t�@�C���ɂ���
echo ======================================================================
REM echo �s�v�ɂȂ����ꎞ�t�@�C�����폜���܂��B
echo �������ꂽ�ꎞ�t�@�C���Q�͍ēx�G���R�[�h����ۂɎg�p�ł��܂��B
echo �s�v�ł���΍폜���Ă��������B
echo ��������蒼�����������̈ꎞ�t�@�C���̂ݍ폜���Ă����Ȃ����삵�܂��B
echo.

REM if exist %avs% del /f /q %avs%
REM if exist %file_fullpath%.lwi del /f /q %file_fullpath%.lwi
REM if exist %source_file_fullpath% del /f /q %source_file_fullpath%
REM if exist %source_file_fullpath%.lwi del /f /q %source_file_fullpath%.lwi
REM if exist %aac_fullpath% del /f /q %aac_fullpath%
REM if exist %aac_fullpath%.lwi del /f /q %aac_fullpath%.lwi
REM if exist %output_enc% del /f /q %output_enc%
REM if exist %output_wav% del /f /q %output_wav%
REM if exist %output_aac% del /f /q %output_aac%
REM if exist %output_m4a% del /f /q %output_m4a%

REM if not exist %avs% echo %avs%
REM if not exist %file_fullpath%.lwi echo %file_fullpath%.lwi
REM if not exist %source_file_fullpath% echo %source_file_fullpath%
REM if not exist %source_file_fullpath%.lwi echo %source_file_fullpath%.lwi
REM if not exist %aac_fullpath% echo %aac_fullpath%
REM if not exist %aac_fullpath%.lwi echo %aac_fullpath%.lwi
REM if not exist %output_enc% echo %output_enc%
REM if not exist %output_wav% echo %output_wav%
REM if not exist %output_aac% echo %output_aac%
REM if not exist %output_m4a% echo %output_m4a%
echo.

echo ======================================================================
echo �����I��: %date% %time%
echo ======================================================================

shift
goto loop
:end

pause
