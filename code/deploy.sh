#!/usr/bin/env bash

tar -cjf latest.tar.bz2 app
MD5=`openssl md5 -binary latest.tar.bz2 | base64`
aws s3api put-object --bucket 18f-terraform-workshop --key latest.tar.bz2 --body latest.tar.bz2 --metadata md5chksum=$MD5 --content-md5 $MD5
aws s3 sync scripts s3://18f-terraform-workshop/