# 4章 ブロックチェーンを構成する暗号技術の基礎

## 課題

1. SHA-256の出力を先頭40ビットに制限した弱い暗号学的ハッシュ関数と，それに対してフロイドの循環検出法で衝突ペアを発見するプログラムを実装し，実行評価してください。
1. データの配列からマークルルートを計算するプログラムを作成してください。1. 非対話Schnorrのゼロ知識証明プロトコルを設計し証明者と検証者のプログラムを実装してください。1. 楕円曲線Schnorr署名による署名作成プログラムと署名検証プログラムを実装してください。

--
### 1. SHA-256の出力を先頭40ビットに制限した弱い暗号学的ハッシュ関数と，それに対してフロイドの循環検出法で衝突ペアを発見するプログラムを実装し，実行評価してください。

### 1. 回答例

```ruby
require 'digest'

# SHA-256 の先頭40ビットに限定した暗号学的ハッシュ関数

def sha40(x)
    Digest::SHA256.hexdigest(x)[0..9]
end

# ρ法による暗号学的ハッシュ関数の衝突ペアの探索

def rho(h0)
    kame,usagi=h0,h0
    begin
        kame=sha40(kame)                # single hashの系列
        usagi=sha40(sha40(usagi))       # double hashの系列
    end until kame==usagi               # loop の合流
    goryu=kame                          # 合流地点を記憶
    kame=h0
    begin
        kame_p,goryu_p=kame,goryu # 直前のデータ（ハッシュ値の原像）を記憶
        kame=sha40(kame)                # h0から再スタートする系列
        goryu=sha40(goryu)              # 合流地点からスタートする系列
    end until kame==goryu               # ハッシュ値が一致
    return [kame_p,goryu_p]             # ハッシュ値の原像ペアを出力
end

# 実験

pair=rho("0000000000")

# pair が衝突ペアになっていることの確認

[sha40(pair[0]),sha40(pair[1])]
```



### 2. データの配列からマークルルートを計算するプログラムを作成してください。

余力のある人は，データ要素とマークルルートから包含証明をするプログラムも作成してみてください。

### 2. 回答例

* テスト用データ

```ruby
list=(1..2000).map{|n|(n*1000).to_s}

# テストデータの確認
list
```

* マークルルートの作成

```ruby
require 'digest'

# データのハッシュ値のリスト作成

def mercle_root(list)
    leaves=list.map{|d| Digest::SHA256.hexdigest(d)}
    mroot(leaves)
end

# マークルルートの作成

def mroot(leaves)
    if leaves.size==1 then leaves[0]
    else
        mroot(leaves.each_slice(2).map do|d|
            if d.size==2 then 
                Digest::SHA256.hexdigest(d[0]+d[1])
            else 
                Digest::SHA256.hexdigest(d[0]+d[0])
            end
        end)
    end
end

root=mercle_root(list)
```

* マークルツリーの作成

```ruby
require 'digest'

# データの配列を木構造の葉の列に変換

def mercle_tree(list)
    tree=list.map{|d| [Digest::SHA256.hexdigest(d),[]]}
    mtree(tree)
end

# マークルツリーを構成
def mtree(tree)
    if tree.size==1 then tree[0]
    else
      mtree(tree.each_slice(2).map do |d|
            if d.size==2 then 
                hash=Digest::SHA256.hexdigest(d[0][0]+d[1][0])
                node=[hash,[d[0],d[1]]]
            else 
                hash=Digest::SHA256.hexdigest(d[0][0]+d[0][0])
                node=[hash,[d[0],d[0]]]
            end
            node
        end)
    end
end

# 実行
tree=mercle_tree(list)

# 確認
tree
```

* マークルパスの構成

```ruby
def merkle_path(tree,hash)
    h=tree[0]                                   # ノードのハッシュ値
    bL=tree[1][0]                               # 左枝
    bR=tree[1][1]                               # 右枝
    if bL[0]==hash then                         # 左枝のハッシュ値が対象と一致
        if bL[1]==[] then                       # 葉ノード
            ['*',bR[0]]                         # 逆の右枝のハッシュ値がパスになる
        end
    elsif bR[0]==hash then                      # 右枝のハッシュ値が対象と一致
        if bR[1]==[] then                       # 葉ノード
            [bL[0],'*']                         # 逆の左枝のハッシュ値がパスになる
        end
    else                                        # 両方の枝のハッシュ値が対象と不一致
        if bL[1] != [] and bR[1] != [] then      # 葉でないノード           
            pL=merkle_path(bL,hash)             # 左枝のパスを探索
            pR=merkle_path(bR,hash)             # 右枝のパスを探索
            if pL != [] then                    # 左枝のパスが空でない
                [pL,bR[0]]                      # 逆の右枝のハッシュ値をパスに追加
            elsif pR != [] then                 # 右枝のパスが空でない
                [bL[0],pR]                      # 逆の左枝のハッシュ値をパスに追加
            else
                []
            end
        else  
            []           
        end
    end
end    
            
# 実行
hash=Digest::SHA256.hexdigest("10000")
hash2=Digest::SHA256.hexdigest("23000")

path=merkle_path(tree,hash)
path
```


### 3. 非対話Schnorrのゼロ知識証明プロトコルを設計し証明者と検証者のプログラムを実装してください。

#### 回答例

* 楕円曲線暗号についてECDSAライブラリを利用します。

```ruby
require 'ecdsa'
require 'securerandom'
require 'digest'

# 楕円曲線としてsecp256k1 を利用します。
ec = ECDSA::Group::Secp256k1

# 位数
n = ec.order

# ベースポイント
G= ec.generator

# 証明者の秘密鍵
d= SecureRandom.random_number(n-1)

# 証明者の公開鍵
 P=G*d
```

* 証明者の処理

```ruby
# 乱数生成
r= SecureRandom.random_number(n-1)

# コミットメントの生成（自己内部で処理するので，送信はしない）
R=G*r

# 2次元データのR2をスカラーに変換（x座標の値だけとりだす）
R1= R.x

# チャレンジ（自己生成）
e=Digest::SHA256.hexdigest(R1.to_s).to_i(16)
s=(r+e*d)%n

# 検証者へ渡す情報
[R, s]
```

* 検証者の処理

```ruby
R1= R.x
e=Digest::SHA256.hexdigest(R1.to_s).to_i(16)

# 検証処理
G*s == R+P*e
=> true
```

### 4. 楕円曲線Schnorr署名による署名作成プログラムと署名検証プログラムを実装してください。


#### 回答例

* 楕円曲線暗号についてECDSAライブラリを利用します。

```ruby
require 'ecdsa'
require 'securerandom'
require 'digest'

# 楕円曲線としてsecp256k1 を利用します。
ec = ECDSA::Group::Secp256k1

# 位数
n = ec.order

# ベースポイント
G= ec.generator

# 証明者の秘密鍵
d= SecureRandom.random_number(n-1)

# 証明者の公開鍵
 P=G*d
```

* 署名者の処理

```ruby
# メッセージ
m="世界さんこんにちは"

# 乱数生成
r= SecureRandom.random_number(n-1)

# チャレンジ
R=G*r

# 2次元データのRをスカラーに変換(Rのx座標)
R1= R.x

# e はメッセージmとスカラー化したRとの連接データのハッシュ値
e=Digest::SHA256.hexdigest(R1.to_s + m).to_i(16)

# e に対する秘密鍵d によるデジタル署名
s=(r+e*d)%n

# 検証者へ渡す情報（メッセージとデジタル署名）
m
[R, s]
```

* 検証者の処理

```ruby
# 2次元データのRをスカラーに変換(Rのx座標)
R1= R.x
e=Digest::SHA256.hexdigest(R1.to_s+m).to_i(16)

# 検証処理
G*s == R+P*e
=> true
```

