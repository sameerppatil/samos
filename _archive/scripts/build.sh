#!/bin/sh

echo "Before kicking of headers.sh"

set -e
. ./headers.sh

echo "Finished doing header part"
 
for PROJECT in $PROJECTS; do
  (cd $PROJECT && DESTDIR="$SYSROOT" $MAKE install)
done
