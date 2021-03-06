git remote add -t gh-pages -f origin-gh-pages https://github.com/${TRAVIS_REPO_SLUG}
git fetch origin-gh-pages
# Clear any changes to package[-lock].json
git checkout -- .
git checkout gh-pages
git checkout ${TRAVIS_BRANCH} -- ./docs
rm -fr ./_static
mv docs/* . -f
git rm -r docs


if [ "${TRAVIS_BRANCH}" == "master" ]
then
  export VERSION="latest"
else
  export VERSION="${TRAVIS_BRANCH}"
fi
node_modules/.bin/aglio -i data-broker.apib -o apiary_${VERSION}.html

git add apiary_${VERSION}.html
git commit -m 'Updating gh-pages' --amend
git push --force http://${GITHUB_TOKEN}:x-oauth-basic@github.com/${TRAVIS_REPO_SLUG} gh-pages
git checkout -- .
git clean -fd
git checkout ${TRAVIS_BRANCH}
