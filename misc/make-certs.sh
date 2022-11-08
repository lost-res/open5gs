#!/bin/sh

if [ 1 -ne $# ]
then
    echo You must specify output directory : ./make-certs.sh ../config/tls
    exit;
fi

rm -rf demoCA
mkdir demoCA
echo 01 > demoCA/serial
touch demoCA/index.txt

# CA self certificate
openssl req -new -x509 -days 3650 -newkey rsa:2048 -nodes -keyout $1/ca.key -out $1/ca.crt \
    -subj /CN=ca.localdomain/C=KO/ST=Seoul/O=NeoPlane

# mme
openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -out $1/mme.key
openssl req -new -key $1/mme.key -out $1/mme.csr \
    -subj /CN=mme.localdomain/C=KO/ST=Seoul/O=NeoPlane
openssl ca -cert $1/ca.crt -days 3650 -keyfile $1/ca.key -in $1/mme.csr -out $1/mme.crt -outdir . -batch -notext

# hss
openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -out $1/hss.key
openssl req -new -key $1/hss.key -out $1/hss.csr \
    -subj /CN=hss.localdomain/C=KO/ST=Seoul/O=NeoPlane
openssl ca -cert $1/ca.crt -days 3650 -keyfile $1/ca.key -in $1/hss.csr -out $1/hss.crt -outdir . -batch -notext

# smf
openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -out $1/smf.key
openssl req -new -key $1/smf.key -out $1/smf.csr \
    -subj /CN=smf.localdomain/C=KO/ST=Seoul/O=NeoPlane
openssl ca -cert $1/ca.crt -days 3650 -keyfile $1/ca.key -in $1/smf.csr -out $1/smf.crt -outdir . -batch -notext

# pcrf
openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -out $1/pcrf.key
openssl req -new -key $1/pcrf.key -out $1/pcrf.csr \
    -subj /CN=pcrf.localdomain/C=KO/ST=Seoul/O=NeoPlane
openssl ca -cert $1/ca.crt -days 3650 -keyfile $1/ca.key -in $1/pcrf.csr -out $1/pcrf.crt -outdir . -batch -notext

rm -rf demoCA
rm -f 01.pem 02.pem 03.pem 04.pem
