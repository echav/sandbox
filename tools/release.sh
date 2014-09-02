SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"
GIT_DIR=$SCRIPT_DIR/..
VERSION_REGEX='^[0-9]+\.[0-9]+$'
ROOT_FILE=qme-widget.php

_exit() {
    echo "An unexpected error occurred > $2"
    exit $1
}

# If not specified, prompt version number
INPUT=$1
if [ -z $1 ]; then
    echo -n "Version number : "
    read INPUT
fi

# Check version number
echo "$INPUT" | grep -E "$VERSION_REGEX" &> /dev/null
if [ ! $? == 0 ]; then
    _exit 1 "Version number [$INPUT] should match regular expression [$VERSION_REGEX]."
fi
VERSION_NB="$INPUT"

# Move to git root directory, checkout master and pull
echo "Checkout master and pull..."
pushd $GIT_DIR &> /dev/null || _exit 2 "Cannot move to git root ditectory [$GIT_DIR]."
git checkout master &> /dev/null || _exit 3 "Cannot checkout master. Have you commited your changes ?"
git pull &> /dev/null || _exit 4 "Error on git pull"

# Change the version number
# Weirdness of MacOS, cannot get it to work with -i flag -> using tmp file
sed "s/Version:\([ \t]*\)[0-9][0-9]*\.[0-9][0-9]*/Version:\1$VERSION_NB/" $ROOT_FILE > $ROOT_FILE.tmp
mv $ROOT_FILE.tmp $ROOT_FILE

git commit -a -m"bump version $VERSION_NB"
git push




