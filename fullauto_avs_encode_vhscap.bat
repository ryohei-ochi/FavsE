@echo off

echo FullAuto AVS Encode VHSCap 1.04

REM ----------------------------------------------------------------------
REM avs������Ɉꎞ��~����CM�J�b�g���ʂ��m�F�E�ҏW���邩�i1:����, 0:���Ȃ��j
REM ----------------------------------------------------------------------
set check_avs=1

REM ----------------------------------------------------------------------
REM �I����Ɉꎞ�t�@�C�����폜���邩�i1:����, 0:���Ȃ��j
REM ----------------------------------------------------------------------
set del_temp=0

REM ----------------------------------------------------------------------
REM �G���R�[�_�̃I�v�V�����i�r�b�g���[�g�A�A�X�y�N�g��͎����ݒ�j
REM ----------------------------------------------------------------------
set x264_opt=--preset slower --crf 19 --partitions p8x8,b8x8,i8x8,i4x4 --ref 6 --no-fast-pskip --no-dct-decimate

REM ----------------------------------------------------------------------
REM �t�H���_��(�K�v�ɉ����ď��������Ă�������)
REM ----------------------------------------------------------------------
set output_path=F:\Encode\
set bin_path=C:\DTV\bin\

REM ----------------------------------------------------------------------
REM ���s�t�@�C���_��(�K�v�ɉ����ď��������Ă�������)
REM ----------------------------------------------------------------------
set x264=%bin_path%x264.exe
set avs2pipemod=%bin_path%avs2pipemod.exe
set qaac=%bin_path%qaac.exe
set muxer=%bin_path%muxer.exe
set remuxer=%bin_path%remuxer.exe

:loop
if "%~1" == "" goto end

if %~x1 == .avi (
  echo.
) else (
  echo [�G���[] �ϊ�����AVI�t�@�C�����h���b�v���Ă��������B
  echo.
  goto end
)

echo ======================================================================
echo %~1
echo ----------------------------------------------------------------------
echo �����J�n: %date% %time%
echo ======================================================================
echo.

REM ----------------------------------------------------------------------
REM �ϐ��Z�b�g
REM ----------------------------------------------------------------------
set file_path=%~dp1
set file_name=%~n1
set file_fullname=%~dpn1
set file_fullpath=%~1

set source_fullpath=%file_fullname%.avi

set avs="%file_fullname%.avs"
set output_enc="%output_path%%file_name%.enc.mp4"
set output_wav="%output_path%%file_name%.wav"
set output_aac="%output_path%%file_name%.aac"
set output_m4a="%output_path%%file_name%.m4a"
set output_mp4="%output_path%%file_name%.mp4"

echo ----------------------------------------------------------------------
echo avs�t�@�C����������
echo ----------------------------------------------------------------------
if exist %avs% (
  echo ���Ƀt�@�C�������݂��܂��B
  goto end_avs
)

echo SetMemoryMax(2048)>>%avs%
echo.>>%avs%

echo ### �t�@�C���ǂݍ��� ###>>%avs%
echo AVISource("%source_fullpath%")>>%avs%
echo.>>%avs%

echo SetMTMode(2, 0)>>%avs%
echo.>>%avs%

echo ### �N���b�v�Ɠh��Ԃ� ###>>%avs%
echo Crop(8, 0, -8, -0)>>%avs%
echo Letterbox(0, 8, 0, 0)>>%avs%
echo.>>%avs%

echo ### �C���^�[���[�X���� ###>>%avs%
echo AssumeTFF()>>%avs%
echo #TDeint(edeint=nnedi3)>>%avs%
echo TDeint(mode=1, edeint=nnedi3(field=-2))>>%avs%
echo.>>%avs%

echo ### ���T�C�Y ###>>%avs%
echo LanczosResize(640, 480)>>%avs%
echo.>>%avs%

echo ### �V���[�v�� ###>>%avs%
echo #Sharpen(0.02)>>%avs%
echo.>>%avs%

echo ### �J�b�g�ҏW ###>>%avs%
echo #Trim()>>%avs%
echo.>>%avs%

echo return last>>%avs%

echo avs�t�@�C���𐶐����܂����B

:end_avs
echo.

if %check_avs% == 1 (
  echo ��avs�t�@�C���m�F�I�v�V�������ݒ肳��Ă��܂��B
  echo ��avs�t�@�C����AvsPmod��AviUtl�Ŋm�F�E�ҏW���Ă��������B
  echo ���m�F�E�ҏW������͏����𑱍s�ł��܂��B
  echo.
  pause
)
echo.

echo ----------------------------------------------------------------------
echo �f���G���R�[�h
echo ----------------------------------------------------------------------
if not exist %output_enc% (
  call %x264% %x264_opt% %sar% -o %output_enc% %avs%
) else (
  echo ���Ƀt�@�C�������݂��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo ��������
echo ----------------------------------------------------------------------
if not exist %output_wav% (
  call %avs2pipemod% -wav %avs% > %output_wav%
) else (
  echo ���Ƀt�@�C�������݂��܂��B
)
if not exist %output_aac% (
  call %qaac% -q 2 --tvbr 91 %output_wav% -o %output_aac%
) else (
  echo ���Ƀt�@�C�������݂��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo muxer����
echo ----------------------------------------------------------------------
if not exist %output_m4a% (
  call %muxer% -i %output_aac% -o %output_m4a%
) else (
  echo ���Ƀt�@�C�������݂��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo remuxer����
echo ----------------------------------------------------------------------
if not exist %output_mp4% (
  call %remuxer% -i %output_enc% -i %output_m4a% -o %output_mp4%
) else (
  echo ���Ƀt�@�C�������݂��܂��B
)
echo.

echo ----------------------------------------------------------------------
echo �ꎞ�t�@�C������
echo ----------------------------------------------------------------------
if %del_temp% == 0 goto no_del_temp
echo �s�v�ɂȂ����ꎞ�t�@�C�����폜���܂��B
echo.
if exist "%file_fullname%.lwi" del /f /q "%file_fullname%.lwi"
if exist "%source_fullpath%.lwi" del /f /q "%source_fullpath%.lwi"
if exist %avs% del /f /q %avs%
if exist %output_enc% del /f /q %output_enc%
if exist %output_wav% del /f /q %output_wav%
if exist %output_aac% del /f /q %output_aac%
if exist %output_m4a% del /f /q %output_m4a%

if not exist "%file_fullname%.lwi" echo "%file_fullname%.lwi"
if not exist "%source_fullpath%.lwi" echo "%source_fullpath%.lwi"
if not exist %avs% echo %avs%
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
echo %~1
echo ----------------------------------------------------------------------
echo �����I��: %date% %time%
echo ======================================================================

shift
goto loop
:end

pause
