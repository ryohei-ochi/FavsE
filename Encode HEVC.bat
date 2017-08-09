@echo off

REM -----------------------------------------------------------------------
REM NVEncC�p�����[�^
REM -----------------------------------------------------------------------
set bitrate=2600
set maxbitrate=16000
REM -------------------------------
REM set bitrate=3500
REM set maxbitrate=26000
REM -------------------------------
REM set bitrate=12000
REM set maxbitrate=45000
REM -----------------------------------------------------------------------
REM NVEncC�p�����[�^ (�A�X�y�N�g�� = 1:1 or ���T�C�Y�ς�, 16:9, 4:3)
REM -----------------------------------------------------------------------
set aspect=--sar 32:27
REM set aspect=--sar 8:9
REM -----------------------------------------------------------------------
REM NVEncC�p�����[�^ (�ڍ�)
REM -----------------------------------------------------------------------
set nvcencc=--avs -c hevc --vbrhq %bitrate% --maxbitrate %maxbitrate% %aspect% --vbr-quality 0 --aq --aq-strength 0 --lookahead 20

REM -----------------------------------------------------------------------
REM �v���O�����t�H���_�Əo�͐�t�H���_
REM -----------------------------------------------------------------------
set program_dir=C:\DTV\Encode\
set output_dir=F:\Encode\

REM -----------------------------------------------------------------------
REM �v���O�����t�@�C����
REM -----------------------------------------------------------------------
REM set nvcencc_path="%program_dir%NVEncC64.exe"
set nvcencc_path="%program_dir%NVEncC64.exe"
set wavi_path="%program_dir%wavi_x64.exe"
set qaac_path="%program_dir%qaac64.exe"
set muxer_path="%program_dir%muxer.exe"
set remuxer_path="%program_dir%remuxer.exe"
set ffmpeg_path="%program_dir%ffmpeg.exe"

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
echo %filename%
echo.

echo ======================================================================
echo NVEncC�ŉf���G���R�[�h
echo ======================================================================
%nvcencc_path% %nvcencc% -i %input_avs% -o %output_enc%
REM %ffmpeg_path% -y -i %input_avs% -an -pix_fmt yuv420p -f yuv4mpegpipe - | %nvcencc_path% --y4m %nvcencc% -i - -o %output_enc%
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
