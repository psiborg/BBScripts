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
set passwd_csk=YOUR_CSK_PASSWORD
set passwd_p12=YOUR_P12_PASSWORD
set zip_path=C:\Program Files\7-Zip
set sdk_path=C:\Program Files\Research In Motion\BlackBerry WebWorks SDK for TabletOS 2.2.0.5\bbwp
set sdk_bin_path=%sdk_path%\blackberry-tablet-sdk\bin
set src_path=%HOMEDRIVE%\%HOMEPATH%\htdocs\webworks
set output_zip_path=%src_path%\bin
set output_bar_path=%src_path%\bin\pb

if (%3)==(usb) set ip_addr=169.254.0.1
if (%5)==(install) goto install_app
goto zip_files

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

if exist %output_bar_path%\%1\%2.bar del %output_bar_path%\%1\%2.bar

bbwp.exe "%output_zip_path%\%1\%2.zip" -o "%output_bar_path%\%1" -buildId 0 -gcsk %passwd_csk% -gp12 %passwd_p12% -v -d

goto install_app

:install_app
echo.
echo --------------------------------------------------------------------------
echo Installing app (%1\%2.bar) to %ip_addr%...
echo --------------------------------------------------------------------------
echo.

cd %sdk_bin_path%
call blackberry-deploy -installApp -password %passwd% -device %ip_addr% -package %output_bar_path%\%1\%2.bar
goto quit

:quit
cd %src_path%

set ip_addr=
set passwd=
set passwd_csk=
set passwd_p12=
set zip_path=
set sdk_path=
set sdk_bin_path=
set src_path=
set output_zip_path=
set output_bar_path=

echo.
echo --------------------------------------------------------------------------
goto end

:syntax
echo PlayBook BAR Packager and Installer Script
echo.
echo Syntax: pb.bat [path] [dirname] [ipaddr or usb] [password] [build or install]
goto end

:end
