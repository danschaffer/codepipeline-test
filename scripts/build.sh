#!/bin/bash

#
# builds the site
# requires environment variables:
#   ENV - stg or prod
#   ACCOUNT - aws account
#   BUCKET - base of the s3 bucket
#   REGIONS - space separated list of regions to deploy
#

set -ex

if [ -z "$BUCKET" ] || [ -z "$ENV" ] || [ -z "$REGIONS" ] || [ -z "$ACCOUNT" ] || [ -z "$DISTID" ]
then
    echo "All environment variables BUCKET, ENV, REGIONS must be set"
    exit 1
fi

echo "build: building site..."
mkdir dist
cd src
cp -r * ../dist

timestamp=$(date)
cd ../dist
sed "s/TIMESTAMP/$timestamp/" index.html > index.html.1
mv -f index.html.1 index.html
cat index.html


for REGION in $REGIONS
do
    echo "build: deploying to $REGION"
    export AWS_DEFAULT_REGION=$REGION
    aws s3 sync . s3://${BUCKET}-${ENV}-${ACCOUNT}-${REGION}
done

echo "build: invalidate cloudformation cache"
echo aws cloudfront create-invalidation --distribution-id $DISTID --paths /*

echo "build: done"
