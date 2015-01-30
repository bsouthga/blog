#!/bin/bash
# Copy Site code to server
# 01/29/15

# generate site tarball and ship
echo Generating tarball ...
tar czfP dist.tar.gz dist/

echo Copying tarball to server ...
scp dist.tar.gz root@bsou.io:/var/www/

echo Unpacking tarball on server ...
# unpack site materials
ssh root@bsou.io <<ENDSSH
  cd /var/www/ ;
  tar -xzf dist.tar.gz ;
  rm -rf html ;
  mv dist html ;
  rm dist.tar.gz ;
ENDSSH

# cleanup
echo Cleaning up
rm dist.tar.gz

