#!/bin/sh

# set git identity
git config user.email "actions@github.com"
git config user.name "${GITHUB_ACTOR:-Github Actions}"

# clone the wiki repo
git clone "https://${GITHUB_OAUTH}@github.com/$OWNER/$REPO_NAME.wiki.git" .wiki

# run the python script
python parse.py -o ".wiki"

# navigate to the output directory
cd .wiki || exit

# stage changes
git add .

# commit using the last commit SHA as the message
git commit -m "$GITHUB_SHA"

# push the wiki repo
git push --set-upstream "https://${GITHUB_OAUTH}@github.com/$OWNER/$REPO_NAME.wiki.git" master
