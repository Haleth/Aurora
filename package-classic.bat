echo %1
cd %1

bash -c "../packager/release.sh -d -g 1.13.3 -m .pkgmeta-classic"

pause
