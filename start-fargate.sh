#!/bin/bash

#su -c "aws s3 sync s3://kin-mbp-media/ /var/www/html/shop/pub/media/" &
#cron && apache2-foreground
#su -c " mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-a10d2fe0.efs.ap-southeast-1.amazonaws.com:/ /var/www/html"
#su -c " mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-ad732aec.efs.ap-southeast-1.amazonaws.com:/ /var/www/html/shop/pub/media"
su -c  "id && cat /etc/passwd && ls -la /var/www/html && ls -la /var/www/html/shop/pub/media "  
apache2-foreground
su -c "ps aux "

