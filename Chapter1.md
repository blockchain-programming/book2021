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
data1="0001"+":"+Digest::SHA256.hexdigest(IV)
data2="0002"+":"+Digest::SHA256.hexdigest(data1)
data3="0003"+":"+Digest::SHA256.hexdigest(data2)
data4="0004"+":"+Digest::SHA256.hexdigest(data3)

# data_list: データの配列，
# hashchain: ハッシュチェーン, 
# prev_hash: 直前データのハッシュ値

def hashchain_and_lasthash(data_list,hashchain,prev_hash)
  if data_list==[] then [hashchain,prev_hash]
  else
    d=data_list.shift+':'+prev_hash
    hashchain<<d
    hash=Digest::SHA256.hexdigest(d)
    hashchain_and_lasthash(data_list,hashchain,hash)
  end
end

data_list=["0001","0002","0003","0004"]
prev_hash0=Digest::SHA256.hexdigest("0000")   # 初期データを"0000" としたハッシュ値
hashchain, lasthash = hashchain_and_lasthash(data_list,[],prev_hash0)

# 確認
hashchain
=> 
["0001:9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0",
 "0002:ea33cc2bf83ebba45c4870bb43b2c3fab4f00c2705313d80e80a61f12f32da5d",
 "0003:940e4ad5051baa5d19dc5e4c9750db738ef1af5ae3a733a9ff7e0d37d06751e8",
 "0004:639923390dbc370e858731b0e11ba3c6dc12fd52eefe6a0217a250c0c3e7219c"]
 
lasthash
=> "9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0"
```

```ruby
# 2. ハッシュチェーンと最終データのハッシュ値を入力として，ハッシュチェーンの正統性を検証する
# hashchain: ハッシュチェーン
# prev_hash: 直前のデータのハッシュ値
# lasthash: 最終ハッシュ値

def verifyhashchain(hashchain,prev_hash,lasthash)
  if hashchain==[] then prev_hash==lasthash
  else
    d=hashchain.shift
    chash=d.split(':')[1]
    hash=Digest::SHA256.hexdigest(d)
    if prev_hash==chash then verifyhashchain(hashchain,hash,lasthash)
    else false
    end
  end
end

prev_hash0=Digest::SHA256.hexdigest("0000")  # 初期データを"0000" としたハッシュ値

# 検証
verifyhashchain(hashchain,prev_hash0,lasthash)
=> true

```

## 演習課題

* 実際に SHA256 によるHashCash法を実装してください。

	* 難易度を 2^240として，難易度未満のハッシュ値を得るための入力値とそのハッシュ値を求め。
	* 実験を100回繰り返して，ハッシュ値が得られるまでの平均時間と分散を求めてください
	* 平均1秒でターゲット未満のハッシュ値が得られる難易度をできるだけ正確に求めてください。

## 回答例

(1)hashcash法の実装

```ruby
require 'openssl'

def hashcash(target)
  hash=0
  pow=""
  begin
      pow=rand(target).to_s
      hash=OpenSSL::Digest.hexdigest('sha256',pow).to_i(16)
  end until hash<target
  return [pow,hash]
end

# 確認
hashcash(2**235)
```

(2)　実験結果の平均と分散

```ruby
def hashcashTime(target)
  t0=Time.now
  hashcash(target)
  return Time.now-t0
end

# 実験
hashcashTime(2**240)
hashcashTime(2**239)
hashcashTime(2**238)
hashcashTime(2**237)
hashcashTime(2**236)
hashcashTime(2**235)

# 100回実験する
N=100
TARGET=2**240
data=(1..N).map{|x|hashcashTime(TARGET)}
# 平均時間
average=data.sum/N
average
# 分散
variance=data.map{|x|(x-average)**2}.sum/N
variance

```

(3) 平均1秒に難易度を調整する　（所要時間は難易度に対して線形と考える）

```ruby
# 難易度 
target= TARGET/(1/average)
data2=(1..N).map{|x|hashcashTime((TARGET/(1/average)).to_i)}
average2=data2.sum/N
average2
```
