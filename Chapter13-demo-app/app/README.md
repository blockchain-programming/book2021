# README

## regtest設定

パラメータを設定しなければ、有効なアドレスを作成できない。

```ruby
Bitcoin.chain_params = :regtest
```

## walletの扱い方

### wallet作成

* bitcoin-cli

```
# アプリを動かすだけなら、明示的にウォレットを作成する必要はない
$ bitcoin-cli createwallet
```

* bitcoinrb

ウォレットを経由せずとも適切な関数を呼びだせば鍵の生成は可能であるが、今回は `Bitcoin::Wallet` を使用した場合について紹介する。

```ruby
# ウォレットの作成時に wallet_id を指定しなければ連番で作られる
wallet = Bitcoin::Wallet::Base.create

# 作成済みのウォレットの呼び出し例
wallet = Bitcoin::Wallet::Base.load (wallet_id=1)

# 直近で使ったウォレットの呼び出し
wallet = Bitcoin::Wallet::Base.current_wallet

# DBを閉じる (はず)
wallet.close
```

LevelDB は複数のプロセスを同時に実行できないため、既にウォレットが呼び出されている状態で実行しようとすると `already held by process` というエラーが出る。

DBを閉じれば実行可能になると考えられるが、 内部で `leveldb.close` を呼び出す `wallet.close` を実行した直後では異なるエラーが出て実行できず、動作は未検証。

作成されたウォレットDBは以下の場所に保存されている。

* Linux: `~/.bitcoinrb/regtest/db/wallet/`

### ウォレット情報の設定・確認

* bitcoin-cli

```
# bitcoind に設定されているウォレット
$ bitcoin-cli getwalletinfo
```

* bitcoinrb

```ruby
# ウォレットの情報
wallet.to_h
```

### アドレス・鍵の管理

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

## bitcoin cliの呼び出し

一部機能は bitcoinrb に実装されていないため、bitcoin-cli の機能で補完する。
`config` は [README](../README.md) の bitcoin.conf と対応している。

```ruby
config = {schema: 'http', host: 'localhost', port: 18443, user: 'username', password: 'pass'}
client = Bitcoin::RPC::BitcoinCoreClient.new(config)

# 引数なし
client.listunspent
# bitcoin-cli にオプションを引数で渡すことができる
client.getaddressesbylabel('name') 
```

## アドレスのビットコイン残高の確認

bitcoin-cli の機能を使う

* `getbalance`: bitcoind のウォレットに含まれる全アドレスの残高の合計を取得(cliの `getnewaddress` を使ったアドレスのみ追跡可能)
* `getreceivedbyaddress`: コインベース以外の受け取った残高をアドレスベースで取得(条件は上記と同様)
* `listunspent`: コインベースも含めたすべての UTXO を取得し、UTXOのアドレスでフィルタをかけると各アドレスの残高を取得可能

`listunspent` などを使うためには、bitcoinrb 上で作成したアドレスを bitcoin-cli にインポートしておく必要がある。

```ruby
client.importaddress('<address>')
```

同様に `setlabel(address, label)`、 `importprivkey` などを使えば bitcoin-cli にアドレスと秘密鍵を登録することができるが、
`solvable: false, spendable: false` の状態から変化しないため、bitcoinrbを用いて生成したアドレスで `sendtoaddress` などの関数は利用できないと考えられる。

## UTXOの利用

複数の UTXO をインプットにしたトランザクションをブロードキャストした際などに `bad-txns-input-missingorspent` というエラーが出ることがある。

トランザクションが存在することとそれが未使用であることを bitcoin-cli で確認しているため、それ以外の条件でエラーが生じていると考えられる。

適切なトランザクション手数料と UTXO を含めていれば実行できるかもしれないが、未検証。

## 未解決・未実装の内容

* 複数の UTXO をインプットにしたトランザクションのブロードキャスト
* ユーザ間の送金
  * 現在の販売所の仕組みは、取引所のアドレスからユーザのアドレスに宛てたトランザクションを作成しているため、ユーザのアドレスに置き換えることで実装できると考えられる。
* コールドウォレット化