#!/bin/sh

# set git identity
git config --global user.email "actions@github.com"
git config --global user.name "${GITHUB_ACTOR:-Github Actions}"

# clone the wiki repo
git clone "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.wiki.git" wiki

ls

# run the python script
python parse.py -o "wiki"

# navigate to the output directory
cd wiki || exit

# stage changes
git add .

# commit using the last commit SHA as the message
git commit -m "$GITHUB_SHA"

# push the wiki repo
git push "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.wiki.git" master
