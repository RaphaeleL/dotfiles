#!/bin/bash

# Proxy Settings
export HTTP_PROXY="http://campus-proxy.rz.bankenit.de:8080"
export HTTPS_PROXY="http://campus-proxy.rz.bankenit.de:8080"
export NO_PROXY="rz.bankenit.de,fiducia.de,ai-gateway.rz.bankenit.de"

# Username und Password 
export USER="xcxa1b9"
export PASSWORD="Tiger#Mango1Affe"

# AI Gateway Zertifikatskette
export NODE_EXTRA_CA_CERTS="$HOME/.continue/ai-gateway-rz-bankenit-de-zertifikatskette.pem"
launchctl setenv NODE_EXTRA_CA_CERTS "$HOME/.continue/ai-gateway-rz-bankenit-de-zertifikatskette.pem"
export AI_GATEWAY_USER="${USER}"
export AI_GATEWAY_PASSWORD="${PASSWORD}"
