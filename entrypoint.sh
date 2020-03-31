#!/bin/sh

set -e

echo '👍 ENTRYPOINT Install Bundler'
gem install bundler
gem environment | echo
echo '👍 ENTRYPOINT HAS STARTED—INSTALLING THE GEM BUNDLE'
bundle config path vendor/bundle
bundle install --jobs 4 --retry 3
bundle list | grep "jekyll ("

# echo 'attempting to chmod ruby folder (for action cache)'
# chmod -R 744 ./ruby

echo '👍 BUNDLE INSTALLED—BUILDING THE SITE'
bundle exec jekyll build -d ./build
echo '👍 THE SITE IS BUILT—PUSHING IT BACK TO GITHUB-PAGES'
cd build
ls -al
remote_repo="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
remote_branch="gh-pages"
git init
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

# Creates the CNAME to my website.
echo "zachzhao.dev" > CNAME
git add .
echo -n 'Files to Commit:' && ls -l | wc -l
git commit -m 'action build'
git push --force $remote_repo master:$remote_branch
rm -fr .git
cd ../
echo '👍 GREAT SUCCESS!'
