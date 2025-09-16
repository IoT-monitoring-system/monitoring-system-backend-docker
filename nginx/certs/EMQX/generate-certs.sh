#!/bin/bash
set -e

OPENSSL_CNF="openssl.cnf"
DAYS_CA=3650        # Root CA validity (10 years)
DAYS_CERT=365       # Server/Client cert validity (1 year)

echo "[*] Generating Root CA..."
openssl genrsa -out rootCA.key 4096
openssl req -x509 -new -key rootCA.key -sha256 -days $DAYS_CA \
    -out rootCA.pem -config $OPENSSL_CNF

echo "[*] Generating Server Key & CSR..."
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -config $OPENSSL_CNF

echo "[*] Signing Server Certificate..."
openssl x509 -req -in server.csr \
    -CA rootCA.pem -CAkey rootCA.key -CAcreateserial \
    -out server.crt -days $DAYS_CERT -sha256 \
    -extfile openssl.cnf -extensions v3_server

cat server.crt rootCA.pem > server-fullchain.crt

echo "[*] Generating Client Key & CSR..."
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr -config $OPENSSL_CNF

echo "[*] Signing Client Certificate..."
openssl x509 -req -in client.csr \
    -CA rootCA.pem -CAkey rootCA.key -CAserial rootCA.srl \
    -out client.crt -days $DAYS_CERT -sha256 \
    -extfile openssl.cnf -extensions v3_client

cat client.crt rootCA.pem > client-fullchain.crt

echo "[*] Verifying Certificates..."
openssl verify -CAfile rootCA.pem server.crt
openssl verify -CAfile rootCA.pem client.crt

echo "[*] Done"
echo "Generated files:"
ls -1 rootCA.* server.* client.*