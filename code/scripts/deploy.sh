LATEST_MD5=`aws s3api head-object --bucket 18f-terraform-workshop --key latest.tar.bz2 --output text --query '{MD:Metadata}' | cut -f 2`
CURRENT_MD5=`openssl md5 -binary /var/www/latest.tar.bz2 | base64`
if [[ $LATEST_MD5 != $CURRENT_MD5 ]]
then
    STAMP=$(date +%Y%m%d%I%M%S)
    aws s3 cp s3://18f-terraform-workshop/latest.tar.bz2 /var/www/
    cd /var/www
    mkdir $STAMP
    tar -xjf latest.tar.bz2 -C$STAMP --strip-components 1
    ln -sfT $STAMP html
fi