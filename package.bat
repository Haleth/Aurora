echo %1
cd %1

bash -c "../lua-doc-parser/build.sh"

bash -c "../packager/release.sh -do"

bash -c "../packager/release.sh -do -g 1.13.3 -m .pkgmeta-classic"

pause
