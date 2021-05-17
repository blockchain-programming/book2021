# 1章 演習

### 演習

* 暗号学的ハッシュ関数 SHA256 のライブラリを利用して，データ "12345" と "12346" のハッ シュ値を求めるプログラムを作成してください。
* データの配列 ["0001","0002","0003","0004"] を入力，IV="0000" として，SHA256 による ハッシュチェーンと最終データのハッシュ値を出力するプログラムを作成してください。
* ハッシュチェーンと最終データのハッシュ値を入力とし，IV="0000" として，ハッシュチェーンの正統性を検証するプログラムを作成してください。
* 実際に SHA256 による HashCash 法を実装してください。

### 課題

* サトシ・ナカモト論文を最後まで精読してください。
* Bitcoin Core をインストールしてください。

ただし接続するネットワークは本物の仮想通貨を扱う mainnet ではなく，実験や開発のため のネットワークである signet にしてください。

[Bitcoin core Signet ノードの構築](https://github.com/ShigeichiroYamasaki/yamalabo/blob/master/bitcoin-core-signet.md)

## 演習課題

* 暗号学的ハッシュ関数 SHA256 のライブラリを利用して，データ"12345" と"12346" のハッシュ値を求めるプログラムを作成してください。

## 回答例

```ruby
# SHA256による暗号学的ハッシュ関数の実行
require 'digest/sha2'
Digest::SHA256.hexdigest "12345"
=> "5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5"
Digest::SHA256.hexdigest "12346"
=> "34d128f5b3dede622e107438fbefabdf0519ebab21ac7b6f2075f974d09ce524"
```

## 演習課題

* データの配列 ["0001","0002","0003","0004"] を入力，IV="0000" として，SHA256によるハッシュチェーンと最終データのハッシュ値を出力するプログラムを作成してください。

* ハッシュチェーンと最終データのハッシュ値を入力とし，IV="0000" として，ハッシュチェーンの正統性を検証するプログラムを作成してください。



## 回答例

```ruby
# 1. ハッシュチェーンと最終データのハッシュ値を出力するプログラム

require 'digest/sha2'

# 手動で実験
#  データとハッシュ値のデリミタを":" とします

IV="0000"
d1="0001"+":"+Digest::SHA256.hexdigest(IV)
d2="0002"+":"+Digest::SHA256.hexdigest(d1)
d3="0003"+":"+Digest::SHA256.hexdigest(d2)
d4="0004"+":"+Digest::SHA256.hexdigest(d3)

# data: データの配列，
# chain: ハッシュチェーン, 
# phash: 直前データのハッシュ値

def hashchain_and_lasthash(data,hashchain,phash)
  if data==[] then [hashchain,phash]
  else
    d=data.shift+':'+phash
    hashchain<<d
    hash=Digest::SHA256.hexdigest(d)
    hashchain_and_lasthash(data,hashchain,hash)
  end
end

data=["0001","0002","0003","0004"]
phash0=Digest::SHA256.hexdigest("0000")   # 初期データを"0000" としたハッシュ値
hashchain,lasthash = hashchain_and_lasthash(data,[],phash0)
```

```ruby
# 2. ハッシュチェーンと最終データのハッシュ値を入力として，ハッシュチェーンの正統性を検証する
# hashchain: ハッシュチェーン
# phash: 直前のデータのハッシュ値
# lasthash: 最終ハッシュ値

def verifyhashchain(hashchain,phash,lasthash)
  if hashchain==[] then phash==lasthash
  else
    d=hashchain.shift
    chash=d.split(':')[1]
    hash=Digest::SHA256.hexdigest(d)
    if phash==chash then verifyhashchain(hashchain,hash,lasthash)
    else false
    end
  end
end

phash0=Digest::SHA256.hexdigest("0000")  # 初期データを"0000" としたハッシュ値
verifyhashchain(hashchain,phash0,lasthash)

```

## 演習課題

* 実際に SHA256 によるHashCash法を実装してください。

難易度を 2240として，難易度未満のハッシュ値を得るための入力値とそのハッシュ値を求める実験を行ってください。
実験を100回繰り返して，ハッシュ値が得られるまでの平均時間と分散を求めてください
平均1秒でターゲット未満のハッシュ値が得られる難易度をできるだけ正確に求めてください。



## 回答例

```ruby
require 'openssl'

# (1)hashcash法の実装

def hashcash(target)
  hash=0
  pow=""
  begin
      pow=rand(target).to_s
      hash=OpenSSL::Digest.hexdigest('sha256',pow).to_i(16)
  end until hash<target
  return [pow,hash]
end

hashcash(2**240)
```

```ruby

# (2)　実験結果の平均と分散

def hashcashTime(target)
  t0=Time.now
  hashcash(target)
  return Time.now-t0
end

data=(1..100).map{|x|hashcashTime(2**240)}
average=data.sum/100
average
variance=data.map{|x|(x-average)**2}.sum/0
variance

```

```ruby
# (3) 平均1秒に難易度を調整する　（所要時間は難易度に対して線形と考える）

# 難易度 target= (2**240)/(1/average)

data2=(1..50).map{|x|hashcashTime(((2**240)/(1/average)).to_i)}
average2=data2.sum/50.0
average2
```


## 課題


## bitcoin core

bitcoin core はSatroshi Nakamoto によって開発が開始されたビットコインの参照実装です。

```
