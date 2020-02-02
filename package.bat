echo %1
cd %1

bash -c "../packager/release.sh -d"

pause
