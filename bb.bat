@echo off
cls

if "%~1"=="" goto syntax
if "%~2"=="" goto syntax
if "%~3"=="" goto syntax
if "%~4"=="" goto syntax
if "%~5"=="" goto syntax
goto init

:init
set ip_addr=%3
set passwd=%4
set passwd_csi=YOUR_CSI_PASSWORD
set zip_path=C:\Program Files\7-Zip
set sdk_path=C:\Program Files\Research In Motion\BlackBerry WebWorks SDK 2.3.1.5
set sdk_bin_path=%sdk_path%\bin
set src_path=%HOMEDRIVE%\%HOMEPATH%\htdocs\webworks
set output_zip_path=%src_path%\bin
set output_cod_path=%src_path%\bin\bb

if (%3)==(usb) set ip_addr=169.254.0.1
if (%5)==(install) goto install_app
goto zip_files
rem goto package_files

:zip_files
echo --------------------------------------------------------------------------
echo Zipping files to %1\%2.zip...
echo --------------------------------------------------------------------------

if exist %output_zip_path%\%1\%2.zip del %output_zip_path%\%1\%2.zip
"%zip_path%\7z.exe" a %output_zip_path%\%1\%2.zip -r "-x!.git*" "-x!.svn" .\%1\%2\*
goto package_files

:package_files
echo.
echo --------------------------------------------------------------------------
echo Packaging files from %1\%2.zip...
echo --------------------------------------------------------------------------
echo.

cd %sdk_path%

if exist %output_cod_path%\%1\StandardInstall\%2.cod del %output_cod_path%\%1\StandardInstall\%2*.*
if exist %output_cod_path%\%1\OTAInstall\%2.cod del %output_cod_path%\%1\OTAInstall\%2*.*

bbwp.exe "%output_zip_path%\%1\%2.zip" -o "%output_cod_path%\%1" -g %passwd_csi%
goto install_app

:install_app
echo.
echo --------------------------------------------------------------------------
echo Installing app (%output_cod_path%\%1\StandardInstall\%2.cod) to device...
echo --------------------------------------------------------------------------
echo.

cd %sdk_bin_path%
JavaLoader.exe -w%passwd% load %output_cod_path%\%1\StandardInstall\%2.cod
goto quit

:quit
cd %src_path%

set ip_addr=
set passwd=
set passwd_csi=
set zip_path=
set sdk_path=
set sdk_bin_path=
set src_path=
set output_zip_path=
set output_cod_path=

echo.
echo --------------------------------------------------------------------------
goto end

:syntax
echo BB COD Packager and Installer Script
echo.
echo Syntax: bb.bat [path] [dirname] [ipaddr or usb] [password] [build or install]
goto end

:end
