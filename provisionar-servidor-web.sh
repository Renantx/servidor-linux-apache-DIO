#!/bin/bash

# =============================================================================
# Infraestrutura como Código (IaC)
# Script de provisionamento de um servidor web (Apache)
# =============================================================================
# Atualiza o sistema, instala Apache2 e unzip, baixa a aplicação de exemplo
# e publica os arquivos no diretório padrão do Apache (/var/www/html).
# =============================================================================

set -euo pipefail

APP_URL="https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip"
TMP_DIR="/tmp"
ZIP_FILE="${TMP_DIR}/main.zip"
APP_DIR="${TMP_DIR}/linux-site-dio-main"
WEB_ROOT="/var/www/html"

echo "=============================================="
echo " Provisionamento do Servidor Web (Apache)"
echo "=============================================="
echo

# Exige privilégios de administrador
if [ "$(id -u)" -ne 0 ]; then
  echo "Erro: execute este script como root (use sudo)."
  exit 1
fi

echo "[1/6] Atualizando o servidor..."
apt-get update -y
apt-get upgrade -y

echo
echo "[2/6] Instalando Apache2 e unzip..."
apt-get install apache2 unzip -y

echo
echo "[3/6] Baixando a aplicação em ${TMP_DIR}..."
cd "${TMP_DIR}"
rm -f "${ZIP_FILE}"
wget -O "${ZIP_FILE}" "${APP_URL}"

echo
echo "[4/6] Descompactando a aplicação..."
rm -rf "${APP_DIR}"
unzip -o "${ZIP_FILE}" -d "${TMP_DIR}"

echo
echo "[5/6] Publicando arquivos em ${WEB_ROOT}..."
rm -rf "${WEB_ROOT:?}"/*
cp -R "${APP_DIR}"/* "${WEB_ROOT}/"

echo
echo "[6/6] Reiniciando o Apache..."
systemctl restart apache2
systemctl enable apache2

echo
echo "=============================================="
echo " Provisionamento concluído com sucesso!"
echo "=============================================="
echo
echo "Status do Apache:"
systemctl status apache2 --no-pager -l || true
echo
echo "Acesse o site pelo IP da máquina, por exemplo:"
echo "  http://$(hostname -I | awk '{print $1}')"
echo
