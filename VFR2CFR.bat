@echo off

set ffmpeg_path="%program_path%ffmpeg.exe"
set output_path=F:\

rem ====================================================
rem ���[�v�����̊J�n
rem ====================================================
:loop
if "%~1" == "" goto end

set input_file="%~1"
set output_file="%output_path%%~n1"

echo ====================================================
echo ffmpeg�Ńt���[�����[�g�ύX
echo ====================================================
echo %input_file%
%ffmpeg_path% -i %input_file% -vsync 1 -vcodec libx264 -preset fast -crf 18 -r 23.976 -acodec copy %output_file%.mp4
echo.

shift
goto loop
:end

pause
