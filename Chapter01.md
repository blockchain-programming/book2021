# 1章 ブロックチェーン技術の原点


## 課題

1. 暗号学的ハッシュ関数 SHA256 のライブラリを利用して，データ "12345" と "12346" のハッ シュ値を求めるプログラムを作成してください。
1. データの配列 ["0001","0002","0003","0004"] を入力，IV="0000" として，SHA256 による ハッシュチェーンと最終データのハッシュ値を出力するプログラムを作成してください。
1. ハッシュチェーンと最終データのハッシュ値を入力とし，IV="0000" として，ハッシュチェーンの正統性を検証するプログラムを作成してください。
1. 実際に SHA256 による HashCash 法を実装してください。
1. サトシ・ナカモト論文を最後まで精読してください。
1. Bitcoin Core をインストールしてください。

----

### 1. 暗号学的ハッシュ関数 SHA256 のライブラリを利用して，データ"12345" と"12346" のハッシュ値を求めるプログラムを作成してください。

#### 回答例　(以下Ruby言語の例）


```ruby
# SHA256による暗号学的ハッシュ関数の実行
require 'digest'

Digest::SHA256.hexdigest "12345"
=> "5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5"

Digest::SHA256.hexdigest "12346"
=> "34d128f5b3dede622e107438fbefabdf0519ebab21ac7b6f2075f974d09ce524"
```

### 2. データの配列 ["0001","0002","0003","0004"] を入力，IV="0000" として，SHA256によるハッシュチェーンと最終データのハッシュ値を出力するプログラムを作成してください。


#### 回答例

(1) まず手動でハッシュチェーンを作成してみます。

```ruby
require 'digest'

# データの配列 ["0001","0002","0003","0004"] がデータ
# IV="0000" 
# データとハッシュ値のデリミタを":" とします
# ハッシュチェーン
IV="0000"    
block1="0001"+":"+IV
block2="0002"+":"+Digest::SHA256.hexdigest(block1)
block3="0003"+":"+Digest::SHA256.hexdigest(block2)
block4="0004"+":"+Digest::SHA256.hexdigest(block3)
hashchain=[block1, block2, block3, block4]
lasthash=Digest::SHA256.hexdigest(block4)

# ハッシュチェーン
hashchain
=> 
["0001:0000",
 "0002:5114fae697241bc0cf0d914d637ee368919ef2d4bc49302289141c71a00ec6b2",
 "0003:b1d7dfe29aeaaba6fadaceffce8d6709e4c5cdfa80ce7673b62d4dcc66fcea2e",
 "0004:43371bcb864782ec393fa830eae758ad1e2b172989e8763074fa7a576a8cfe55"]
 
# 最終ハッシュ値
lasthash
=> "9455075057982b2d43c6fcaa9e5e75058efd43a21107f67526515face5c48365"
```

(2) プログラムとして実装

```ruby
# data_list: データの配列
IV="0000"    
data_list=["0001","0002","0003","0004"]

# prev_hash: 直前ブロックのハッシュ値

# ハッシュチェーンの生成
def hashchain(data_list,prev_hash)
  data_list.map{|data|
    block=data+':'+prev_hash
    prev_hash=Digest::SHA256.hexdigest(block)
    block
  }
end

# 実行
blockchain=hashchain(data_list,IV)
=> 
["0001:0000",
 "0002:5114fae697241bc0cf0d914d637ee368919ef2d4bc49302289141c71a00ec6b2",
 "0003:b1d7dfe29aeaaba6fadaceffce8d6709e4c5cdfa80ce7673b62d4dcc66fcea2e",
 "0004:43371bcb864782ec393fa830eae758ad1e2b172989e8763074fa7a576a8cfe55"]
 
 # 最終ハッシュ値
lasthash=Digest::SHA256.hexdigest(blockchain[-1])
=> "9455075057982b2d43c6fcaa9e5e75058efd43a21107f67526515face5c48365"
```

### 3. ハッシュチェーンと最終データのハッシュ値を入力とし，IV="0000" として，ハッシュチェーンの正統性を検証するプログラムを作成してください。

#### 回答例

検証する内容

* すべてのブロックで，ブロック中に埋め込まれている「直前のブロックのハッシュ値」が実際に直前のブロックのハッシュ値に一致する
* 最後のブロックのハッシュ値が最終ハッシュ値に一致する
 
```ruby
# blockchain: ハッシュチェーン
# prev_hash: 直前のブロックのハッシュ値
# lasthash: 最終ハッシュ値

def verifyhashchain(hashchain,prev_hash,lasthash)
  hashchain.map{|block|
    hash=block.split(':')[1]
    if hash==prev_hash then
       prev_hash=Digest::SHA256.hexdigest(block)
       true
    else
       false
    end
  }.all? and (prev_hash==lasthash)
end

# ハッシュチェーンの検証
verifyhashchain(blockchain,IV,lasthash)
=> true

```

### 4.  実際に SHA256 によるHashCash法を実装してください。

* 難易度を<img src="https://latex.codecogs.com/gif.latex?2^{240}" />として，難易度未満のハッシュ値を得るための入力値とそのハッシュ値を求める。
* 実験を100回繰り返して，ハッシュ値が得られるまでの平均時間と分散を求めてください
* 平均1秒でターゲット未満のハッシュ値が得られる難易度をできるだけ正確に求めてください。

#### 回答例

(1)hashcash法の実装

```ruby
require 'digest'

# 難易度ターゲットを設定し，ランダムに選んだプルーフオブワークの原像とそのハッシュ値を求める

def hashcash(target)
  hash=0
  pow=""
  size=2**256
  begin
    pow=rand(size).to_s
    hash=Digest::SHA256.hexdigest(pow).to_i(16)
  end until hash<target
  return [pow,hash]
end

# 難易度を2**240として確認
hashcash(2**240)

```

(2)　実験結果の平均と分散

```ruby

# 実行時間の測定

def hashcashTime(target)
  t0=Time.now
  hashcash(target)
  return Time.now-t0
end

# 難易度を変えて実験する

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

(3) マイニング時間が平均1秒になるように難易度を調整する　（所要時間は難易度に対して線形と考える）

```ruby
# 難易度 
target= TARGET*average
data2=(1..N).map{|x|hashcashTime(target)}
average2=data2.sum/N
```

### 5. サトシ・ナカモト論文を最後まで精読してください。

#### 参考

[https://bitcoin.org/bitcoin.pdf](https://bitcoin.org/bitcoin.pdf)

### 6.Bitcoin Core をインストールしてください。

ただし接続するネットワークは本物の仮想通貨を扱う mainnet ではなく，実験や開発のため のネットワークである signet にしてください。


#### 参考

[Bitcoin core Signet ノードの構築](https://github.com/ShigeichiroYamasaki/yamalabo/blob/master/bitcoin-core-signet.md)
