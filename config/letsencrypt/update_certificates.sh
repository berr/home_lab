#!/bin/sh

certbot renew | tee /current_cert/renew_log.txt

grep -q "No renewals were attempted" /current_cert/renew_log.txt
ALREADY_UPDATED=$?

if [ ! $ALREADY_UPDATED ]
then
        echo "Updating"
        cp /etc/letsencrypt/live/berr.dev/* /current_cert
        cd /current_cert
        openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem -out domain.pfx -passout pass:
        chown 1000:1000 /current_cert/*
fi

echo Finished
