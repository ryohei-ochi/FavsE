@echo off

set logos_path=C:\DTV\Encode\logos\

:loop
if "%~1" == "" goto end

set avs_file="%~dpn1.avs"
echo %avs_file%

echo avsource = %1>> %avs_file%
echo.>> %avs_file%

echo ### LSMASHSource�ł̓ǂݍ��� ###>> %avs_file%
echo #LWLibavVideoSource(avsource, dr=true, repeat=true, dominance=1, fpsnum=30000, fpsden=1001)>> %avs_file%
echo LWLibavVideoSource(avsource, dr=true, repeat=true, dominance=1).AssumeFPS(30000, 1001)>> %avs_file%
echo AudioDub(last, LWLibavAudioSource(avsource, av_sync=true, layout="stereo"))>> %avs_file%
echo.>> %avs_file%

echo SetMTMode(2, 0)>> %avs_file%
echo.>> %avs_file%

echo ### DirectShowSource�ł̓ǂݍ��� ###>> %avs_file%
echo #DirectShowSource(avsource, fps=30000.0 / 1001.0, convertfps=true)>> %avs_file%
echo.>> %avs_file%

echo ### AviSource�ł̓ǂݍ��� ###>> %avs_file%
echo #AviSource(avsource)>> %avs_file%
echo.>> %avs_file%

echo ### LWLibavVideoSource��dr=true���w�肵���ꍇ�̍������� ###>> %avs_file%
echo (height() == 1088) ? Crop(0, 0, 0, -8) : SetMTMode(2)>> %avs_file%
echo.>> %avs_file%

echo ### ��������(idx+sub) ###>> %avs_file%
echo #VobSub("")>> %avs_file%
echo.>> %avs_file%

echo ### �J�b�g�ҏW ###>> %avs_file%
echo.>> %avs_file%

echo ### �����ǃ��S�t�@�C���w��i���S�������s���ꍇ�̂݁j ###>> %avs_file%
echo logoname = "">> %avs_file%
echo #logoname = "NHK BS1.lgd">> %avs_file%
echo #logoname = "NHK BS�v���~�A��.lgd">> %avs_file%
echo #logoname = "BS���e��.lgd">> %avs_file%
echo #logoname = "BS����.lgd">> %avs_file%
echo #logoname = "�a�r�����P.lgd">> %avs_file%
echo #logoname = "BS-TBS.lgd">> %avs_file%
echo #logoname = "BS�W���p��.lgd">> %avs_file%
echo #logoname = "BS�t�W.lgd">> %avs_file%
echo #logoname = "WOWOW�v���C��.lgd">> %avs_file%
echo #logoname = "�v�n�v�n�v���C�u.lgd">> %avs_file%
echo #logoname = "�v�n�v�n�v�V�l�}.lgd">> %avs_file%
echo #logoname = "�X�^�[�`�����l�� STAR1.lgd">> %avs_file%
echo #logoname = "�X�^�[�`�����l���Q.lgd">> %avs_file%
echo #logoname = "�X�^�[�`�����l���R.lgd">> %avs_file%
echo #logoname = "�C�}�W�J�a�r�E�f��.lgd">> %avs_file%
echo #logoname = "BS11.lgd">> %avs_file%
echo #logoname = "TwellV.lgd">> %avs_file%
echo #logoname = "�a�r�A�j�}�b�N�X.lgd">> %avs_file%
echo #logoname = "�a�r���{�f���傃��.lgd">> %avs_file%
echo #logoname = "���C�e���r.lgd">> %avs_file%
echo #logoname = "�����e���r.lgd">> %avs_file%
echo #logoname = "�����e���r�P.lgd">> %avs_file%
echo #logoname = "�b�a�b�e���r.lgd">> %avs_file%
echo #logoname = "���`�e��.lgd">> %avs_file%
echo.>> %avs_file%

echo ### ���S�����ilogoname���w�肳��Ă���ꍇ�̂݁j ###>> %avs_file%
echo logofile = (logoname != "") ? "C:\DTV\Encode\logos\" + logoname : "">> %avs_file%
echo (logofile != "") ? EraseLOGO(logofile=logofile, pos_x=0, pos_y=0, depth=128, yc_y=0, yc_u=0, yc_v=0, start=0, fadein=0, fadeout=0, end=-1, interlaced=true) : SetMTMode(2)>> %avs_file%
echo.>> %avs_file%

echo ### �N���b�v ###>> %avs_file%
echo #Crop(8, 0, -8, 0)>> %avs_file%
echo.>> %avs_file%

echo ### �h��Ԃ�(���S�t�@�C���������ꍇ) ###>> %avs_file%
echo #Letterbox(116, 0)>> %avs_file%
echo.>> %avs_file%

echo #AssumeTFF()>> %avs_file%
echo.>> %avs_file%

echo ### �t�e���V�l + �C���^�[���[�X����(��҂͌y��) ###>> %avs_file%
echo TIVTC24P2()>> %avs_file%
echo #TDeint(mode=0, order=1, type=3, tryweave=true).TDecimate(mode=1, hybrid=0)>> %avs_file%
echo.>> %avs_file%

echo ### �t�e���V�l�̂� ###>> %avs_file%
echo #TDecimate(mode=1, hybrid=0)>> %avs_file%
echo.>> %avs_file%

echo ### �C���^�[���[�X�����̂�(��҂͌y��) ###>> %avs_file%
echo #TDeint(order=1, edeint=nnedi3, emask=TMM2())>> %avs_file%
echo #TDeint(order=1, edeint=nnedi3)>> %avs_file%
echo.>> %avs_file%

echo ### ���T�C�Y(x264���ŃA�X�y�N�g����w�肵�Ă��悢) ###>> %avs_file%
echo Spline36Resize(1280, 720)>> %avs_file%
echo #Spline36Resize(854, 480)>> %avs_file%
echo #Spline36Resize(640, 480)>> %avs_file%
echo.>> %avs_file%

echo ### �A�b�v�R���o�[�g(SD->HD�g��) ###>> %avs_file%
echo #nnedi3_rpow2(rfactor=2, nsize=4, nns=0, qual=1, cshift="spline36resize", fwidth=1280, fheight=720, ep0=4)>> %avs_file%
echo.>> %avs_file%

echo ### �m�C�Y���� ###>> %avs_file%
echo #FFT3DFilter(sigma=1.5, beta=1, plane=4, bw=32, bh=32, ow=16, oh=16, bt=3, sharpen=0, interlaced=false, wintype=0)>> %avs_file%
echo #hqdn3d(2)>> %avs_file%
echo.>> %avs_file%

echo ### �V���[�v�� ###>> %avs_file%
echo #Import("C:\Program Files (x86)\AviSynth\plugins\LSFmod.v1.9.avsi");>> %avs_file%
echo #SetMTMode(6)>> %avs_file%
echo #LSFmod(defaults="slow", strength=40, dest_x=1280, dest_y=720)>> %avs_file%
echo.>> %avs_file%

echo return last>> %avs_file%
echo.>> %avs_file%

echo function TIVTC24P2(clip clip){>> %avs_file%
echo Deinted=clip.TDeint(order=-1,field=-1,edeint=clip.nnedi3(field=-1))>> %avs_file%
echo clip = clip.TFM(mode=6,order=-1,PP=7,slow=2,mChroma=true,clip2=Deinted)>> %avs_file%
echo clip = clip.TDecimate(mode=1)>> %avs_file%
echo return clip>> %avs_file%
echo }>> %avs_file%
echo.>> %avs_file%

shift
goto loop
:end

exit
