@echo off
:: T�rk�e karakter deste�i
chcp 1254 > NUL 2>&1

:: Y�netici yetkisi kontrol� ve y�kseltme
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Y�netici yetkisi isteniyor...
    goto UACPrompt
) else ( 
    goto gotAdmin 
)

:UACPrompt
    :: VBScript ile y�netici yetkisi alma
    set "vbsFile=%temp%\getadmin.vbs"
    echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsFile%"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%vbsFile%"
    call "%vbsFile%"
    del "%vbsFile%"
    exit /B

:gotAdmin
    :: �al��ma dizinini script konumuna ayarla
    pushd "%CD%"
    CD /D "%~dp0"

:: Konsol ba�l��� ve renk ayar� (0A = Siyah arka plan, A��k ye�il yaz�)
title pipiCleaner
color 0A

:: Versiyon de�i�kenini belirle
set version=v1.0.0

:: ASCII Art Logo ve Program Ba�l���
echo.
echo            _       _ ________                          
echo     ____  (_)___  (_) ____/ /__  ____ _____  ___  _____
echo    / __ \/ / __ \/ / /   / / _ \/ __ \`/ __ \/ _ \/ ___/
echo   / /_/ / / /_/ / / /___/ /  __/ /_/ / / / /  __/ /    
echo  / .___/_/ .___/_/\____/_/\___/\__,_/_/ /_/\___/_/     
echo /_/     /_/                                            
echo.
echo             pipiCleaner - Sistem Temizlik Arac� %version%
echo ================================================

:: Temizlenecek alanlar�n listesi
echo.
echo Temizlenecek alanlar:
echo - Ge�ici Dosyalar (Temp Klas�r�)
echo - Prefetch �nbelle�i
echo - Geri D�n���m Kutusu
echo - Son Kullan�lanlar
echo - Windows G�ncelleme �nbelle�i
echo - �nternet Ge�ici Dosyalar�
echo.

:: Kullan�c� onay� alma
echo Temizli�e ba�lamak i�in 'E' tu�una, iptal etmek i�in 'H' tu�una bas�n.
choice /C EH /N /M "Devam etmek istiyor musunuz (E/H)? "

:: �ptal durumu kontrol�
if %errorlevel%==2 (
    echo.
    echo ��lem iptal edildi.
	echo.
    echo ��kmak i�in bir tu�a bas�n.
    pause >nul 2>&1
    exit
)

echo.
echo Temizlik ba�l�yor...
echo.

:: Temp Klas�r� Temizleme
echo Ge�ici dosyalar temizleniyor...
del /f /s /q "%temp%\*.*" >nul 2>&1
for /d %%i in ("%temp%\*") do rd /s /q "%%i" >nul 2>&1
if %errorlevel%==0 (
    echo [+] TEMP klas�r� temizlendi
	echo.
    md %temp% >nul 2>&1
) else (
    echo [X] TEMP klas�r� temizlenemedi
	echo.
)

:: Prefetch �nbelle�i Temizleme
echo Prefetch �nbelle�i temizleniyor...
del /s /q C:\Windows\Prefetch\*.* >nul 2>&1
if %errorlevel%==0 (
    echo [+] Prefetch �nbelle�i temizlendi
	echo.
) else (
    echo [X] Prefetch �nbelle�i temizlenemedi
	echo.
)

:: Geri D�n���m Kutusu Temizleme
echo Geri D�n���m Kutusu temizleniyor...
rd /s /q %systemdrive%\$Recycle.bin >nul 2>&1
if %errorlevel%==0 (
    echo [+] Geri D�n���m Kutusu temizlendi
	echo.
) else (
    echo [X] Geri D�n���m Kutusu temizlenemedi
	echo.
)

:: Son Kullan�lanlar Temizleme
echo Son kullan�lanlar temizleniyor...
del /f /s /q %APPDATA%\Microsoft\Windows\Recent\*.* >nul 2>&1
if %errorlevel%==0 (
    echo [+] Son kullan�lanlar temizlendi
	echo.
) else (
    echo [X] Son kullan�lanlar temizlenemedi
	echo.
)

:: Windows Update �nbelle�i Temizleme
echo Windows g�ncelleme �nbelle�i temizleniyor...
del /s /q C:\Windows\SoftwareDistribution\Download\*.* >nul 2>&1
if %errorlevel%==0 (
    echo [+] Windows g�ncelleme �nbelle�i temizlendi
	echo.
) else (
    echo [X] Windows g�ncelleme �nbelle�i temizlenemedi
	echo.
)

:: �nternet Ge�ici Dosyalar� Temizleme
echo �nternet ge�ici dosyalar� temizleniyor...
del /s /q "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*.*" >nul 2>&1
if %errorlevel%==0 (
    echo [+] �nternet ge�ici dosyalar� temizlendi
	echo.
) else (
    echo [X] �nternet ge�ici dosyalar� temizlenemedi
	echo.
)

:: Temizlik Sonu
echo.
echo ================================================
echo                Temizlik Tamamland�!
echo ================================================
echo.
echo ��kmak i�in bir tu�a bas�n.
pause >nul 2>&1
exit