echo %1
cd %1

bash -c "../lua-doc-parser/build_actions.sh"

bash -c "../packager/release.sh -d"


pause
