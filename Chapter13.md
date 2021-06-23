# 13章 ブロックチェーンを利用したシステム構成

## 課題
1. 仮想通貨取引所のサンプルコードをダウンロードして動作させてください。
1. 仮想通貨取引所のサンプルコードのワレットを作成し，秘密鍵のバックアップとリストアを行ってください。
1. 不正防止機能付き試験出題・回答システムを作成してください。

## 1. 仮想通貨取引所のサンプルコードをダウンロードして動作させてください。

### 回答例

[サンプルコード](https://github.com/blockchain-programming/book2021/tree/master/Chapter13-demo-app)をダウンロードします。gitが利用できる場合は、以下のコマンドから入手します。

```
$ git clone https://github.com/blockchain-programming/book2021.git
```

[README](https://github.com/blockchain-programming/book2021/tree/master/Chapter13-demo-app#readme)の手順に従って、実行してください。

実行環境によってはエラーメッセージが出る可能性があります。エラーメッセージの内容に応じて、修正してください。TIPsがあれば、IssueやWikiに投稿ください。

## 2. 仮想通貨取引所のサンプルコードのワレットを作成し，秘密鍵のバックアップとリストアを行ってください。

### 回答例（ヒント）

アドレス・鍵の管理は次のように行います。

* bitcoin-cli

```
# アドレスの作成（オプションでラベル指定可能）
# この関数を用いて作成したアドレス宛てに generatetoaddress を実行すると、
# solvable: true, spendable: true
# となり、sendtoaddress が使用可能
$ bitcoin-cli getnewaddress [<name>]

# nameラベルをつけたアドレスリストを取得する
# 戻り値にはアドレスとその目的 (受け取り用 / おつり用) が含まれる
$ bitcoin-cli getaddressesbylabel <name>
```

* bitcoinrb

```ruby
wallet = Bitcoin::Wallet::Base.load(wallet_id=1)

# m84'/1'/0'
# BIP84 (native segwit) のウォレット、対象通貨はビットコイン (1)、アカウントのインデックスは0 
account = wallet.master_key.key.derive(84, true).derive(1, true).derive(0, true)

# m84/1'/0'/0/0
# アドレスはお釣り用ではない(0)、アドレスのインデックスは0  
receive_key = account.derive(0).derive(0)

# アドレス
receive_key.addr
# 公開鍵
receive_key.pub
receive_key.key.pubkey 
# 秘密鍵
receive_key.key.priv_key 
# 秘密鍵 (WIF) 
receive_key.key.to_wif 

# receive_key 自体は以下の方法でも取得できる
# 戻り値のクラスが異なるため、公開鍵や秘密鍵を取得するときに上記の方法の一部は使えない
# アカウント、アドレスのインデックスは0
account = wallet.accounts[0]
receive_key = account.derived_receive_keys[0]
```

## 3.  不正防止機能付き試験出題・回答システムを作成してください。

### 回答例

略。

実装の参考として、電子情報通信学会の論文をご参照ください。
https://www.ieice.org/ken/paper/20190308k19z/
