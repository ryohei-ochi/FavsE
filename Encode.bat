@echo off

REM -----------------------------------------------------------------------
REM x264�p�����[�^ (�N�H���e�B = �A�j��19�`21, ����21�`23 ���x)
REM -----------------------------------------------------------------------
set quality=19
REM set quality=23
REM -----------------------------------------------------------------------
REM x264�p�����[�^ (�A�X�y�N�g�� = 1:1 or ���T�C�Y�ς�, 16:9, 4:3)
REM -----------------------------------------------------------------------
REM set aspect=1:1
REM set aspect=32:27
REM set aspect=8:9
REM -----------------------------------------------------------------------
REM x264�p�����[�^ (�\�[�X�^�C�v = �A�j��, ����)
REM -----------------------------------------------------------------------
REM set source_type=--psy-rd 0.2:0 --trellis 2
set source_type=--psy-rd 0.6:0 --trellis 1
REM -----------------------------------------------------------------------
REM x264�p�����[�^ (�ڍ�)
REM -----------------------------------------------------------------------
set x264=--crf %quality% --sar %aspect% --qpmin 10 --qcomp 0.8 --scenecut 50 --min-keyint 1 --direct auto --weightp 1 --bframes 4 --b-adapt 2 --b-pyramid normal --ref 4 --rc-lookahead 50 --qpstep 4 --aq-mode 2 --aq-strength 0.80 --me umh --subme 9 %source_type% --no-fast-pskip --no-dct-decimate --thread-input

REM -----------------------------------------------------------------------
REM �v���O�����t�H���_�Əo�͐�t�H���_
REM -----------------------------------------------------------------------
set program_dir=C:\DTV\Encode\
set output_dir=F:\Encode\

REM -----------------------------------------------------------------------
REM �v���O�����t�@�C����
REM -----------------------------------------------------------------------
set x264_path="%program_dir%x264_x64.exe"
set wavi_path="%program_dir%wavi_x64.exe"
set qaac_path="%program_dir%qaac64.exe"
set muxer_path="%program_dir%muxer.exe"
set remuxer_path="%program_dir%remuxer.exe"

REM -----------------------------------------------------------------------
REM ���[�v�����̊J�n
REM -----------------------------------------------------------------------
:loop
if "%~1" == "" goto end

set input_avs="%~1"
set filename=%~n1

REM -----------------------------------------------------------------------
REM �o�̓t�@�C����
REM -----------------------------------------------------------------------
set output_enc="%output_dir%%filename%.enc.mp4"
set output_wav="%output_dir%%filename%.wav"
set output_aac="%output_dir%%filename%.aac"
set output_m4a="%output_dir%%filename%.m4a"
set output_mp4="%output_dir%%filename%.mp4"

echo ======================================================================
echo �����J�n: %date% %time%
echo ======================================================================
echo %input_avs%
echo.

echo ======================================================================
echo x264�ŉf���G���R�[�h
echo ======================================================================
%x264_path% %x264% -o %output_enc% %input_avs%
echo.

echo ======================================================================
echo wavi�ŉ����o��(wav)
echo ======================================================================
%wavi_path% %input_avs% %output_wav%
echo.

echo ======================================================================
echo qaac�ŉ����G���R�[�h(aac)
echo ======================================================================
%qaac_path% -q 2 --abr 192 --ignorelength %output_wav% -o %output_aac%
echo.

echo ======================================================================
echo L-SMASH�ŉ���mux
echo ======================================================================
%muxer_path% -i %output_aac% -o %output_m4a%
echo.

echo ======================================================================
echo L-SMASH�ŉf���E����remux
echo ======================================================================
%remuxer_path% -i %output_enc% -i %output_m4a% -o %output_mp4%
echo.

echo ======================================================================
echo �ꎞ�t�@�C���폜
echo ======================================================================
echo �s�v�ɂȂ����ꎞ�t�@�C�����폜���܂��B
echo.
REM pause

if exist %output_mp4% del /f /q %output_enc%
if exist %output_mp4% del /f /q %output_wav%
if exist %output_mp4% del /f /q %output_aac%
if exist %output_mp4% del /f /q %output_m4a%

if not exist %output_enc% echo %output_enc%
if not exist %output_wav% echo %output_wav%
if not exist %output_aac% echo %output_aac%
if not exist %output_m4a% echo %output_m4a%
echo.

echo ======================================================================
echo �����I��: %date% %time%
echo ======================================================================

shift
goto loop
:end

pause
exit
