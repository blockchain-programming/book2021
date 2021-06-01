# 4章 ブロックチェーンを構成する暗号技術の基礎

## 課題

1. SHA-256の出力を先頭40ビットに制限した弱い暗号学的ハッシュ関数と，それに対してフロイドの循環検出法で衝突ペアを発見するプログラムを実装し，実行評価してください。
1. データの配列からマークルルートを計算するプログラムを作成してください。1. マークルツリーを利用して効率的にデータの包含証明を行うプロトコルを設計し，実装してください。1. 楕円曲線Schnorr署名による署名作成プログラムと署名検証プログラムを実装してください。

--
### SHA-256の出力を先頭40ビットに制限した弱い暗号学的ハッシュ関数と，それに対してフロイドの循環検出法で衝突ペアを発見するプログラムを実装し，実行評価してください。

### 回答例

```ruby
require 'digest'

# SHA-256 の先頭40ビットに限定したハッシュ関数
def sha40(x)
	Digest::SHA256.hexdigest(x)[0..9]
end

# ρ法による衝突ペアの探索
def rho(h0)
    kame,usagi=h0,h0
    begin
        kame=sha40(kame)            # single hash
        usagi=sha40(sha40(usagi))   # double hash
    end until kame==usagi           # loop 1
    goryu=kame                      # 合流地点
    kame=h0
    begin
        kame_prev,goryu_prev=kame,goryu
        kame=sha40(kame_prev)       # h0からスタート
        goryu=sha40(goryu_prev)     # 合流地点からスタート
    end until kame==goryu           # ハッシュ値が一致
    return [kame_prev,goryu_prev]
end

# 実験

pair=rho("0000000000")

# pair が衝突ペアになっていることの確認

[sha40(pair[0]),sha40(pair[1])]
```



### 2. データの配列からマークルルートを計算するプログラムを作成してください。

### 2. 回答例

テスト用データの配列の作成(サイズは2のべき乗とします)

```ruby
data=(1..1000).map{rand(10000).to_s}
```

マークルルートの作成

```ruby
require 'digest'

def mercle_root(data)
    if data.size==1 then data[0]
    else
        mercle_root(data.each_slice(2).map{|d|
            if d.size==2 then Digest::SHA256.hexdigest(d[0]+d[1])
            else Digest::SHA256.hexdigest(d[0]+d[0])
            end
        })
    end
end

mercle_root(data)
```




