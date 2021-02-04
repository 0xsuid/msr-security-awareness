@echo off

:start
echo Starting Execution
goto Menu

:download
CLS
echo =================================
echo Downloading Database
mkdir %~dp0..\..\data\popular-4k & cd %~dp0..\..\data\popular-4k
for /F %%I in ('curl -s https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/ ^| grep -Po "(?<=<a href="")[^^"".]*(\.csv\.gz|\.sql)"') do (
    echo Downloading %%I & curl --progress-bar -O https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/%%I
)
sed -i 's/zcat/gzip -cd/g' load.sql
echo Downloading CVE Manager
cd %~dp0..\code\
curl -O https://raw.githubusercontent.com/0xsuid/cve_manager/master/cve_manager.py
echo Download Complete
goto Menu

:loadDataset
cls
echo =================================
echo 1. Create Database with index - Very Slow Loading, little bit faster exec.
echo 2. Create Database without index - Faster Loading, little bit slower exec.
echo =================================
set /p op=Type option:
if "%op%"=="1" goto CreateDbIndex
if "%op%"=="2" goto CreateDbNoIndex

:createDbIndex
echo =================================
echo Loading Dataset into Database - est. time(~4-5 hours):
cd %~dp0..\..\data\popular-4k
psql swhgd-popular-4k < load.sql -U postgres
echo Finished Loading Dataset into Database
goto Menu

:createDbNoIndex
echo =================================
echo Loading Dataset into Database - est. time(~30-45 mins):
xcopy /y %~dp0..\..\process\sql\load_no_index.sql %~dp0..\..\data\popular-4k
cd %~dp0..\..\data\popular-4k
E:\PostgreSQL\bin\createdb -U postgres swhgd-popular-4k
E:\PostgreSQL\bin\psql -U postgres swhgd-popular-4k < load_no_index.sql
echo Finished Loading Dataset into Database
goto Menu

:createTables
cls
echo =================================
echo Creating Table cve_revs - est. time(~3-4 mins)
psql swhgd-popular-4k < %~dp0..\..\process\sql\create_table_cve_revs.sql postgres
echo Successfully Created Table cve_revs
echo Creating Table cve_revs_js - est. time(~20-30 mins)
psql swhgd-popular-4k < %~dp0..\..\process\sql\create_table_cve_revs_js.sql postgres
echo Successfully Created Table cve_revs_js
echo Creating Table cve_revs_py - est. time(~5-10 mins)
psql swhgd-popular-4k < %~dp0..\..\process\sql\create_table_cve_revs_py.sql postgres
echo Successfully Created Table cve_revs_py
goto Menu

:cveData
cls
echo =================================
echo Downloading NVD ^& Parsing CVE
rmdir /S /Q %~dp0..\..\data\nvd
rmdir /S /Q %~dp0..\..\data\cve_parsed
python %~dp0..\code\cve_manager.py -d -p -csv -i  %~dp0..\..\data\nvd\ -o %~dp0..\..\data\cve_parsed\

:Menu
echo =================================
echo 1. Download Dataset ^& CVE Manager
echo 2. Load Dataset into Database
echo 3. Create Tables (cve_revs,cve_revs_js,cve_revs_py)
echo 4. Download NVD ^& Get CVE related issues
echo 5. Exit
echo =================================
set /p op=Type option:
if "%op%"=="1" goto download
if "%op%"=="2" goto loadDataset
if "%op%"=="3" goto createTables
if "%op%"=="4" goto cveData
if "%op%"=="5" goto exit

:exit
@exit