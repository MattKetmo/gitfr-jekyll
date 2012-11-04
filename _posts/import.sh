#!/bin/sh

# Import a post from blogofile to jekyll format

set -e

FILE=$1
if [ ! -f "$FILE" ]; then
    echo "File $1 does not exist" && exit
fi

DATE=$(head -n 10 $FILE | egrep "^date:" | sed -e 's/^date: \([0-9]*\)\/\([0-9]*\)\/\([0-9]*\).*/\1-\2-\3/')

SLUG=$(head -n 10 $FILE | egrep "^slug:") || true
if [ "$SLUG" ]; then
    SLUG=$(echo $SLUG | sed -e 's/^slug: \(.*\)/\1/')
else
    SLUG=$(echo $FILE | sed -e 's/[0-9]*-\(.*\)\.markdown/\1/')
fi

sed -i '' '2 i\
layout: post
' $FILE

sed -i '' 's/categories: \(.*\)/categories: [\1]/' $FILE

mv $FILE "$DATE-$SLUG.markdown"
