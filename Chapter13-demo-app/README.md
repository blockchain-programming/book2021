# README

## Environment

以下の環境で動作確認済み。

* Ruby 2.6.3
* Rails 5.2.4.1
* Ubuntu 16.04 / macOS HighSierra

## 起動方法

### bitcoindの準備

* regtestで起動するときの設定内容 (bitcoin.conf)

```
regtest=1
txindex=1

server=1
rest=1

daemon=1

rpcuser=username
rpcpassword=pass

[regtest]
rpcport=18443
```

* 設定ファイルを置くディレクトリ
  * Linux: ~/.bitcoin/
  * macOS: /Users/\<username>/Library/Application Support/Bitcoin/

* 起動コマンド

```
$ bitcoind
```

設定ファイルに `regtest=1` を記述しているので、オプションは必要ない。

### LevelDBの準備

* Linux
```
$ apt-get install libleveldb-dev
```

* macOS

```
$ brew install leveldb
```

* Gemのパッケージも予めインストールしておく

```
# Linux
$ gem install leveldb-native

# macOS
# ビルド時にオプションが必要
$ gem install leveldb-native -- --with-cxxflags=-std=c++11
```

### bundle

```
$ gem install bundler -v 2.1.2
$ bundle install
```

### Webサーバの起動

```
$ rails s
```

環境構築以外については [README](./app/README.md) を参照
