#!/bin/bash

#
# Copyright (c) 2012 by Jinna Software Associates
#
# Utility script to recompile assets for production mode and upload them
# to production app running on EC2. The assets get extracted and relinked
# automatically.
#

rm -rf public/assets/*

echo "Precompiling the assets"
date
rake assets:precompile
date
basename=assets-`date +%s`
bundle=$basename.tgz
(
cd public
echo "Renaming assets to $basename"
mv assets $basename
tar -czf ../$bundle $basename
echo "Renaming $basename to assets"
mv $basename assets
)

echo "Copying to EC2"
PRODUCTION_PATH=/home/ec2-user/rails/production/sherlock-www
KEY_PATH=../amazon/amazonmicro2.pem
scp -i $KEY_PATH $bundle $AMAZON_PI:$PRODUCTION_PATH/public/
echo "Relinking to use the new bundle"
ssh -i $KEY_PATH -t $AMAZON_PI "cd $PRODUCTION_PATH/public;tar -xzf $bundle;rm $bundle; rm assets;ln -s $basename assets;sudo apachectl restart"

rm -rf public/assets/*

