@echo off

rem -----------------------------------------------------------------------
rem �����ݒ�
rem -----------------------------------------------------------------------
set program_path=C:\DTV\Encode\
set temp_path=F:\
set comp_path=F:\

rem -----------------------------------------------------------------------
rem �v���O�����E�t�@�C���̃p�X
rem -----------------------------------------------------------------------
set avs4x26x_path="%program_path%avs4x26x.exe"
set x264_path="%program_path%x264_64.exe"
REM set wavi_path="%program_path%wavi.exe"
set avs2wav_path="%program_path%avs2wav32.exe"
set qaac_path="%program_path%qaac.exe"
set muxer_path="%program_path%muxer.exe"
set remuxer_path="%program_path%remuxer.exe"

rem -----------------------------------------------------------------------
rem x264�p�����[�^
rem -----------------------------------------------------------------------
REM set quality=20
set quality=23
set aspect=1:1
REM set aspect=32:27
REM set aspect=8:9
rem -----------------------------------------------------------------------
set x264=--crf %quality% --sar %aspect% --level 4.1 --qpmin 0 --qpmax 69 --qpstep 4 --qcomp 0.75 --aq-mode 1 --aq-strength 1 --psy-rd 1:0 --bframes 3 --ref 3 --b-adapt 2 --b-pyramid "normal" --weightb --mixed-refs --direct "auto" --me "umh" --subme 9 --merange 16 --trellis 2 --8x8dct --partitions "p8x8,b8x8,i8x8,i4x4" --keyint 240 --min-keyint 24 --scenecut 60 --weightp 1 --threads 0 --thread-input

rem -----------------------------------------------------------------------
rem ���[�v�����̊J�n
rem -----------------------------------------------------------------------
:loop
if "%~1" == "" goto end

set input_avs="%~1"
set name=%~n1

rem -----------------------------------------------------------------------
rem �o�́E���̓p�X
rem -----------------------------------------------------------------------
set output_mp4="%temp_path%%name% [enc].mp4"
set output_wav="%temp_path%%name%.wav"
set output_aac="%temp_path%%name%.aac"
set output_m4a="%temp_path%%name%.m4a"
set complete_mp4="%comp_path%%name%.mp4"

echo ======================================================================
echo �����J�n
echo ======================================================================
echo %input_avs%
echo.

echo ======================================================================
echo x264�ŃG���R�[�h
echo ======================================================================
%avs4x26x_path% -L %x264_path% %x264% -o %output_mp4% %input_avs%
echo.

REM echo ======================================================================
REM echo wavi�ŉ����o��(wav)
REM echo ======================================================================
REM %wavi_path% %input_avs% %output_wav%
REM echo.

echo ======================================================================
echo avs2wav�ŉ����o��(wav)
echo ======================================================================
%avs2wav_path% %input_avs% %output_wav%
echo.

echo ======================================================================
echo qaac�ŉ����G���R�[�h(aac)
echo ======================================================================
%qaac_path% -q 2 --abr 128 --ignorelength %output_wav% -o %output_aac%
echo.

echo ======================================================================
echo L-SMASH�ŉ���mux
echo ======================================================================
%muxer_path% -i %output_aac% -o %output_m4a%
echo.

echo ======================================================================
echo L-SMASH�ŉf���E����remux
echo ======================================================================
%remuxer_path% -i %output_mp4% -i %output_m4a% -o %complete_mp4%
echo.

echo ======================================================================
echo �ꎞ�t�@�C���폜
echo ======================================================================
del /f /q %output_mp4%
del /f /q %output_wav%
del /f /q %output_aac%
del /f /q %output_m4a%
if not exist %output_mp4% echo %output_mp4%
if not exist %output_wav% echo %output_wav%
if not exist %output_aac% echo %output_aac%
if not exist %output_m4a% echo %output_m4a%
echo.
echo.

shift
goto loop
:end

pause
exit
