@echo off

REM -----------------------------------------------------------------------
REM NVEncC�̃I�v�V����
REM -----------------------------------------------------------------------
set NVCENC_OPTION=--avs --cqp 19:21:23 --lookahead 32 --aq --aq-temporal --aq-strength 0

REM -----------------------------------------------------------------------
REM �t�H���_��
REM -----------------------------------------------------------------------
set BIN_DIR=C:\DTV\bin\
set LOGO_DIR=%BIN_DIR%join_logo_scp\logo\
set OUTPUT_DIR=F:\Encode\

REM -----------------------------------------------------------------------
REM ���s�t�@�C����
REM -----------------------------------------------------------------------
set NVCENC=%BIN_DIR%NVEncC.exe
set MUXER=%BIN_DIR%muxer.exe
set REMUXER=%BIN_DIR%REMUXER.exe
set MEDIAINFO=%BIN_DIR%MediaInfo\MediaInfo.exe
set DGINDEX=%BIN_DIR%DGIndex\DGIndex.exe

REM -----------------------------------------------------------------------
REM ���[�v�����̊J�n
REM -----------------------------------------------------------------------
:loop
if "%~n1" == "" goto end

echo ======================================================================
echo �����J�n: %date% %time%
echo ======================================================================
echo %~dpn1
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
set ISDVD=0
for /f "delims=" %%A in ('%MEDIAINFO% %1 ^| grep "Width" ^| sed -r "s/Width *: (.*) pixels/\1/" ^| sed -r "s/ //"') do set WIDTH=%%A
if %WIDTH% == 720 set ISDVD=1

REM -----------------------------------------------------------------------
REM �ϐ��Z�b�g
REM -----------------------------------------------------------------------
set FILENAME=%~n1
set PATH_NAME=%~dp1
set FULLNAME=%~dpn1
set AVS="%FULLNAME%.avs"

set OUTPUT_ENC="%OUTPUT_DIR%%FILENAME%.enc.mp4"
set OUTPUT_MP4="%OUTPUT_DIR%%FILENAME%.mp4"
set OUTPUT_AAC="%OUTPUT_DIR%%FILENAME%.aac"

REM -----------------------------------------------------------------------
REM TS �s�v�f�[�^�폜
REM -----------------------------------------------------------------------
if not exist "%SOURCE_FULLNAME%" call %TS_SPRITTER% -EIT -ECM -EMM -SD -1SEG "%PATH_FILENAME%.ts"

REM -----------------------------------------------------------------------
REM TS �f���E��������
REM -----------------------------------------------------------------------
if not exist "%SOURCE_FILENAME%*DELAY*.*" (
  call %DGINDEX% -i "%SOURCE_FULLNAME%" -o "%SOURCE_FILENAME%" -ia 5 -fo 0 -yr 2 -om 2 -hide -exit
  if exist "%SOURCE_FILENAME%.log" del /f /q "%SOURCE_FILENAME%.log"
)
for /f "usebackq tokens=*" %%A in (`dir /b "%SOURCE_FILENAME%*DELAY*.*"`) do set AAC_FILE=%PATH_NAME%%%A
set D2V_FILE=%SOURCE_FILENAME%.d2v

for /f "usebackq tokens=*" %%A in (`dir /b "%SOURCE_FILENAME%*DELAY*.aac"`) do set AAC_FILE=%PATH_NAME%%%A

REM -----------------------------------------------------------------------
REM TS �f���E��������
REM -----------------------------------------------------------------------
if not exist "%SOURCE_FILENAME%*DELAY*.*" (
  call %DGINDEX% -i "%SOURCE_FULLNAME%" -o "%SOURCE_FILENAME%" -ia 5 -fo 0 -yr 2 -om 2 -hide -exit
  if exist "%SOURCE_FILENAME%.log" del /f /q "%SOURCE_FILENAME%.log"
)
for /f "usebackq tokens=*" %%A in (`dir /b "%SOURCE_FILENAME%*DELAY*.*"`) do set AAC_FILE=%PATH_NAME%%%A
set D2V_FILE=%SOURCE_FILENAME%.d2v

REM -----------------------------------------------------------------------
REM DVD�\�[�X�̂݃A�X�y�N�g���ݒ�
REM -----------------------------------------------------------------------
for /f "delims=" %%A in ('%MEDIAINFO% "%SOURCE_FULLNAME%" ^| grep "Width" ^| sed -r "s/Width *: (.*) pixels/\1/" ^| sed -r "s/ //"') do set WIDTH=%%A
for /f "delims=" %%A in ('%MEDIAINFO% "%SOURCE_FULLNAME%" ^| grep "Display aspect ratio" ^| sed -r "s/Display aspect ratio *: (.*)/\1/"') do set ASPECT=%%A
if %WIDTH% == 720 (
  if %ASPECT% == 16:9 (
    set SAR=--sar 32:27
  ) else (
    set SAR=--sar 8:9
  )
) else (
  set SAR=--sar 1:1
)

echo ======================================================================
echo NVEncC�ŉf���G���R�[�h
echo ======================================================================
REM call %NVCENC% %NVCENC_OPTION% %SAR% -i %AVS% -o %OUTPUT_ENC%
echo.

echo ======================================================================
echo L-SMASH�Ō���
echo ======================================================================
for /f "delims=" %%A in ('dir /b "%AAC_FILE%" ^| sed -r "s/.* DELAY ([^\.]*)ms.aac/\1/"') do set DELAY=%%A
call %MUXER% -i %OUTPUT_ENC% -i "%AAC_FILE%"?encoder-delay=%DELAY% -o %OUTPUT_MP4%
echo.

echo ======================================================================
echo �ꎞ�t�@�C���폜
echo ======================================================================
echo �s�v�ɂȂ����ꎞ�t�@�C�����폜���܂��B
echo.

REM if exist %OUTPUT_MP4% del /f /q %OUTPUT_ENC%
if not exist %OUTPUT_ENC% echo %OUTPUT_ENC%
echo.

echo ======================================================================
echo �����I��: %date% %time%
echo ======================================================================

shift
goto loop
:end

pause
exit
