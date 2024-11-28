# wg-genconf
WireGuard VPNのセットアップに必要な`conf`ファイルを生成します。  

## wg-client.sh
クライアント側のVPNの設定ファイルを設定します。  
対話式に答えることで作成されます。  
デフォルトでの`DNS`は`Google`の`8.8.8.8`です。  

```bash
chmod +x wg-client.sh
sudo ./wg-client.sh
WireGuardサーバーの公開鍵を入力してください:
WireGurrdサーバーのPubKey
サーバーのエンドポイント (IPアドレスとポート) を入力してください (例: 192.168.1.100:51820):
WireGurad VPNが立ち上がってるサーバー先
クライアント名(例: wg0)
クライアント名(設定ファイルにも使われます)
クライアントのIPアドレスを入力してください (例: 10.32.0.2/24):
VPN上に作るセグメント
WireGuard VPN許可するネットワーク (例: 全てWireGuardを全て通る - 0.0.0.0/0 限られたネットワーク - ):
VPNをどこまで適応させるか 0.0.0.0/0 -> 全てWireGuard VPN経由 10.32.0.2/24 -> /24のサブネットマスク値に対応する、他にセットアップされているネットワークだけ到達出来るようにする
```
最後に、`サーバー側に以下を設定してください。`と帰ってきた出力をサーバー側の設定ファイルに追記します。
