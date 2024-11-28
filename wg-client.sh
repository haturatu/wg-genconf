#!/bin/bash

# CONFファイルの名前とパス
CONF_DIR="/etc/wireguard"

# WGサーバーの公開鍵
echo "WireGuardサーバーの公開鍵を入力してください:"
read -r SERVER_PUBLIC_KEY

# サーバーのエンドポイント
echo "サーバーのエンドポイント (IPアドレスとポート) を入力してください (例: 192.168.1.100:51820):"
read -r SERVER_ENDPOINT

# クライアント名を指定
echo "クライアント名(例: wg0)"
read -r CLIENT_NAME

# クライアントのIPアドレス
echo "クライアントのIPアドレスを入力してください (例: 10.32.0.2/24):"
read -r CLIENT_ADDRESS
IP_LIMIT=$(echo "$CLIENT_ADDRESS" | awk -F. '{print $1"."$2"."$3}' | sed "s/$/.0\/24/g")

# VPNを通すセグメント
echo "WireGuard VPN許可するネットワーク (例: 全てWireGuardを全て通る - 0.0.0.0/0 限られたネットワーク - $IP_LIMIT):"
read -r ALLOWED_IPS

# 必要なディレクトリを作成
if [ ! -d "$CONF_DIR" ]; then
    mkdir -p "$CONF_DIR" || exit 1
fi

CONF="$CONF_DIR/$CLIENT_NAME.conf"

# クライアントの秘密鍵と公開鍵を生成
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo "$CLIENT_PRIVATE_KEY" | wg pubkey)

# 事前共有鍵を生成
PRESHARED_KEY=$(wg genpsk)

# クライアントの配置ファイルを生成
cat <<EOF > $CONF
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = $CLIENT_ADDRESS
DNS = 8.8.8.8

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
AllowedIPs = $ALLOWED_IPS
Endpoint = $SERVER_ENDPOINT
PreSharedKey = $PRESHARED_KEY
PersistentKeepalive = 25
EOF

# 配置ファイルのパーミッションを設定
chmod 700 "$CONF_DIR"
chmod 600 $CONF

# QRコードを生成、qrencodeが存在すれば表示
command -v qrencode && qrencode -t utf8 < $CONF

echo "クライアント配置ファイル ($CONF) が生成されました。"
command -v qrencode && echo "QRコードがコンソールに表示されています。"

echo "
サーバー側に以下を設定してください。
[Peer] 
PublicKey = $CLIENT_PUBLIC_KEY 
PreSharedKey = $PRESHARED_KEY 
AllowedIPs = $(echo "$CLIENT_ADDRESS" | awk -F/ '{print $1}')/0または32等 
PersistentKeepalive = 25"

