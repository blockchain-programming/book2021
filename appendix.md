# 付録 数学的基礎

## 整数論

#### ビットベクトル変換

メッセージの文字列なども数値に変換すればビットの列とみなすことができ、プログラムで排他的論理和などの処理ができます。実際の暗号システムでは、文字単位ではなく、128ビットなどのブロック単位で処理が行われます。

さらに、CPUの違いやOSの違いを超えた標準的なエンコード方法（BER, DER, CER など）で暗号文の交換が行われます。

```ruby
# メッセージの文字列のビットベクトル（数値）変換
m = "これは平文の message です"
numbers = m.unpack("U*")
=> [12371, 12428, 12399, 24179, 25991, 12398, 32, 109, 101, 115, 115, 97, 103, 101, 32, 12391, 12377]

# BER エンコード（ISO/IEC 8825-1:1995 : Basic Encoding Rules(BER) による整数の符号化）
ber = numbers.pack("w*")
=> "\xE0S\xE1\f\xE0o\x81\xBCs\x81\xCB\a\xE0n message \xE0g\xE0Y"

# BER デコード
dnumbers = ber.unpack("w*")
=> [12371, 12428, 12399, 24179, 25991, 12398, 32, 109, 101, 115, 115, 97, 103, 101, 32, 12391, 12377]

# 数値の配列化されたメッセージの文字列への復元
decode = dnumbers.pack("U*")
=> "これは平文の message です"
```

#### 排他的論理和

排他的論理和による暗号化と復号化（ワンタイムパッド）

```ruby
require 'securerandom'

# 暗号化
def encrypt(message,key)
  m=message.unpack("U*")            # 文字列の数値列変換
  k=key.unpack("U*")                # 暗号鍵の数値列変換
  numbers =m.zip(k).map{|a,b|a^b}   # 数値とごに排他的論理和を実施
  return numbers.pack("w*")         # 数値の配列をBERエンコード
end

# 復号化
def decrypt(ber,key)
  c = ber.unpack("w*")
  k=key.unpack("U*")                # 暗号鍵のビットベクトル変換
  c.zip(k).map{|a,b|a^b}.pack("U*") # 数値とごに排他的論理和を実施
end

# 暗号化
m = "これは平文の message です"
# 暗号鍵生成（メセージと同じサイズのランダムな文字列を毎回生成）
key = (1..m.size).map{("!".."z").to_a[SecureRandom.random_number(90)]}.join
=> "-bow+8S@7TSA'K)@X"
# 暗号化
ber = encrypt(m,key)
=> "\xE0\r\xE16\xE0.\x81\xBCO\x81\xCBl\xE03|*M\"\x17>\x16Ug\xE0R\xE0\x1E"

# 復号化（暗号鍵が必要）
decrypt(ber,key)
=> "これは平文の message です"
```

### ユークリッドの互除法
a,b の最大公約数を求める

```ruby
# ユークリッドの互差法
def gcs(a,b)
    if a>=b then
        if a==b then return b
        else gcs(b,a-b)
        end
    else gcs(b,a)
    end
end

# ユークリッドの互除法
def gcd(a,b)
    if a%b==0 then return b
    else gcd(b,a%b)
    end
end
```

### 拡張ユークリッド互除法

ベズー方程式 ax + by = gcd の x,y,gcd を求める

```ruby
def egcd(a,b)                                             
  if a%b==0 then [0,1,b]    # 再帰の基底 a*0 + b*1 = b 
  else
    xp,yp,gcd = egcd(b,a%b) # 再帰 b*xp + a%b*yp = d
    [yp,xp-(a/b)*yp,gcd]    # 再帰の復帰処理x=yp,y=xp-(a/b)*yp
  end
end

# ベズー方程式 92378x + 226765y=d の解
egcd(92378,226765)
=> [-27, 11, 209]
```

### Z/nZの分数（乗法逆元）

1/a mod n を求める

```ruby
# 拡張ユークリッド互除法 egcd(a,b) を利用
def inv(a,n)
  x,y,d=egcd(a,n)
  return x%n                                        
end

inv(11,17)
=> 14
```

## RSA暗号

#### フェルマーの小定理

```ruby
# エラトステネスのふるいによる素数リスト生成
def eratosthenes(a,primes)
    if a==[] then primes
    else
        p=a.shift
        eratosthenes(a.reject{|x|x%p==0}, primes<<p)
    end
end
# @primes に10000 以下の素数のリスト
@primes = eratosthenes([*2..70000],[])

# フェルマーの小定理
def fermat(a,p)
  (a**(p-1))%p
end

# 実験
a=rand(10000)
a
@primes[0..100].map{|prime| fermat(a,prime) if a%prime !=0}
```

#### 2項定理


```ruby
def combi(n,r)
  if n==r or r==0 then 1
  else
     combi(n-1,r) + combi(n-1,r-1)
  end
end

(0..10).map{|n|(0..n).map{|r|combi(n,r)}}
[1]
[1, 1]
[1, 2, 1]
[1, 3, 3, 1]
[1, 4, 6, 4, 1]
[1, 5, 10, 10, 5, 1]
[1, 6, 15, 20, 15, 6, 1]
[1, 7, 21, 35, 35, 21, 7, 1]
[1, 8, 28, 56, 70, 56, 28, 8, 1]
[1, 9, 36, 84, 126, 126, 84, 36, 9, 1]
[1, 10, 45, 120, 210, 252, 210, 120, 45, 10, 1]

```

#### 中国剰余定理

```ruby
# 中国剰余定理による剰余群変換
def crt(a,b,p,q)
  s,t,d = egcd(p,q)     # 拡張ユークリッド互除法
  (b*s*p+a*t*q)%(p*q)
end
# a=5, b=3, p=7, q=11
crt(5,3,7,11)
=> 47
```

### 規約剰余類とオイラーのΦ関数

```ruby
# 素因数分解（素数リストを利用した素朴な方法）

def factorize(n)
    # nの約数になる素数のリスト
    primes=@primes.select{|p|n%p==0} 
    primes.map do |p| 
        factor=[p,0]
        while n%p==0 do
            factor[1]+=1
            n=n/p
        end 
     factor
   end
end

# 実行 1514200 の素因数分解
factorize(1514200)
=> [[2, 3], [5, 2], [67, 1], [113, 1]]
```

#### オイラーの位数関数Φ関数

<img src="https://render.githubusercontent.com/render/math?math=\displaystyle \varphi(n)  ">
 n と互いに素な1 以上 n 以下の自然数の個数
<img src="https://render.githubusercontent.com/render/math?math=\displaystyle n=\prod_{k=1}^d p_k^{e_k} ">
に対して
<img src="https://render.githubusercontent.com/render/math?math=\displaystyle \varphi(n)= \prod_{k=1}^d (p_k^{e_k} - p_k^{e_k - 1})">

```ruby
def phi(n)
    factorize(n).reduce(1) do |m,f|
        m*((f[0]**f[1]-f[0]**(f[1]-1)))
    end
end

# 実験
(1..100).map{|n|[n,phi(n)]}
```

#### オイラーの位数関数Φの性質

オイラーのトーシエント関数Φの乗法性
mとnが互いに素のとき

<img src="https://render.githubusercontent.com/render/math?math=\displaystyle \varphi(mn)=\varphi(m)\varphi(n) ">

```ruby
def phitest
  m,n=1,1
   begin
      m=rand(1000)
      n=rand(1000)
    end until gcd(m,n)==1
    phi(m*n)==phi(m)*phi(n)
end

# 実験
100.times{p phitest}
```

#### オイラーの定理

<img src="https://render.githubusercontent.com/render/math?math=\displaystyle a^{\varphi(m)} \equiv1 \mod  m  ">

```ruby
def euler(a,m)
    powmod(a,phi(m),m)
end
# 実験
(1..100).map{|n|[n,euler(n,10)]}
# n が 10 と互いに素のときに 1
(1..100).map{|n|[n,euler(n,11)]}
# n が 11 と互いに素のときに 1
```

#### オイラーの定理の一般化

mが2つの素数 p,qの積の場合

<img src="https://render.githubusercontent.com/render/math?math=\displaystyle  a^{\varphi(m)+1} \equiv a \mod  m   ">

```ruby
p = @primes[rand(50)]
q = @primes[rand(50)]
m = p*q
# 実験（すべてのペアが一致していることを確認する）
(1..100).map{|n|[n%m,(euler(n,m)*n)%m]}
```
mが3つの素数 p,q,rの積の場合

```ruby
m = 2*2*5
# 実験（一致しないペアが存在する）
(1..100).map{|n|[n%m,(euler(n,m)*n)%m]}
```

### べき剰余計算のバイナリ法による効率化

#### バイナリ法

17の(2の4096乗)乗 mod (2**1024)-1 を求める

```ruby
# バイナリ法によるべき剰余計算
def powmod(a,e,m)
  (e.bit_length-2).downto(0).reduce(a) do |p,i|         # ビット列を操作する
    if e[i] ==0 then p=(p**2)%m
    else p=(((p**2)%m)*a)%m
    end
  end
end

powmod(17,2**4096,(2**1024)-1)
=> 16389423416652745237915618915717058940598471185754300539405146966289607963419298830725886944008496847755511996883865659347708227325988344659961158970043729163983049312415085064039690600920749569927252697793325247026707024896947088219694807985942819231342342434115325667197010146673709137709401133943194291446
```

### 素数生成

#### フェルマーテストによる素数生成

2 の1024乗サイズの素数を生成する

```ruby
#　フェルマーテストによる素数生成
require 'securerandom'

def ftPrime(size)
  n=0
  begin
    n=SecureRandom.random_number(2**size)
  end until n%2 !=0 && n%3 !=0 && n%5 !=0 && n%7 !=0 && n%11 !=0 && powmod(2,(n-1),n)==1 && powmod(3,(n-1),n)==1 && powmod(5,(n-1),n)==1
  return n
end

ftPrime(1024)
=> 157513970041789289764558966554858427712422157424298563516545346906568066797603235494937152274863168150620059770439381978788645253077840175021242505536159590665762695705694773670290340388163525821676874460757895013678803522725106251914869580639423165478715227838162936394966665449367242985167606217033431998351
```

### RSA暗号の実装

```ruby
# 拡張ユークリッド互除法
def egcd(a,b)
  if a%b==0 then [0,1,b]
  else
    xp,yp,gcd = egcd(b,a%b)
    [yp,xp-(a/b)*yp,gcd]
  end
end

# バイナリ法によるべき剰余計算
def powmod(a,e,m)
  (e.bit_length-2).downto(0).reduce(a) do |p,i|         # ビット列を操作する
    if e[i] ==0 then p=(p**2)%m
    else p=(((p**2)%m)*a)%m
    end
  end
end

#　フェルマーテストによる素数生成
require 'securerandom'
def ftPrime(size)
  n=0
  begin
    n=SecureRandom.random_number(2**size)
  end until n%2 !=0 && n%3 !=0 && n%7 !=0 && n%11 !=0 && powmod(2,(n-1),n)==1 && powmod(3,(n-1),n)==1 && powmod(5,(n-1),n)==1
  return n
end

# 中国剰余定理による剰余群変換
def crt(a,b,p,q)
  s,t,d = egcd(p,q)     # 拡張ユークリッド互除法
  (b*s*p+a*t*q)%(p*q)
end

# RSA鍵生成 （2048bit）
p,q= [ftPrime(1024), ftPrime(1024)]
n=p*q                           # 公開鍵 n
e=65537                         # 公開鍵 e
fai = (p-1)*(q-1)
d=egcd(e,fai)[0]%fai            # 秘密鍵 d

# 復号化（中国剰余定理で効率化）
def dec(c,d,p,q)
    crt(powmod(c,d,p),powmod(c,d,q),p,q)
end
# 平文メッセージ
m = 12345678901234567890

# 暗号化
c = powmod(m,e,n)
# 復号化
m_dec = powmod(c,d,n)
# 復号化（中国剰余定理で効率化）
m_dec = dec(c,d,p,q)
```

### 平方剰余

<img src="https://render.githubusercontent.com/render/math?math=\displaystyle x^{2} = -1 ">の解を調べる

```ruby
# pを因数として含むものは、mod p で余りが0になる
def qfactor(n,p)
     (1..n).map{|x|x**2+1}.select{|x|
        x%p==0
    }
end

# 実験
# x**2=-1 は、mod 5 で解を持つ
qfactor(10,5)
=> [5, 10, 50, 65]
# x**2=-1 は、mod 3 で解を持たない
qfactor(10000,3)
=> []
```

<img src="https://render.githubusercontent.com/render/math?math=\displaystyle x^{2} = -a ">の解を調べる


```ruby
# pを因数として含むものは、mod p で余りが0になる
def qfactor2(n,a,p)
     (1..n).map{|x|x**2+a}.select{|x|
        x%p==0
    }
end

# 実験
p=13
(1..(p-1)).map{|a|qfactor2(10,a,p)}
=> [[26, 65], [], [39, 52], [13, 104], [], [], [], [], [13], [26, 91], [], [13]]
```

#### オイラーの基準

```ruby
# オイラーの基準
def euler_criterion(a,p)
    if (a**((p-1)/2))%p==1 then  1
    else -1
    end
end

# 素数p に関するオイラーの基準のテスト
def euler_criterion_test(p)
  (1..(p-1)).map.with_index{|a,i|[i+1, euler_criterion(a,p)]}
end

euler_criterion_test(13)
=> 
[[1, 1], [2, -1], [3, 1], [4, 1], [5, -1], [6, -1], [7, -1], [8, -1], [9, 1], [10, 1], [11, -1], [12, 1]]
```

## 有限体論

GF(p) の演算表の作成

```ruby
# 加法の演算表
def gfa(a,b,p)
    (a+b)%p
end

# 加法逆元（負の数）
def neg(a,p)
    p-a
end


# 加法の演算表
def gfa_table(p)
    t=Hash.new
    (0..(p-1)).each do |a|
        t[a]={}
        (0..(p-1)).each do |b|
            t[a][b]=gf_add(a,b,p)
        end
    end
    return t
end

gf3a = gfa_table(3)
=>
 {0=>{0=>0, 1=>1, 2=>2}, 1=>{0=>1, 1=>2, 2=>0}, 2=>{0=>2, 1=>0, 2=>1}}
gf3a[2][2]
=> 1

# 乗法
def gfp(a,b,p)
    (a*b)%p
end

# 乗法逆元（拡張ユークリッド互除法を利用）
# 拡張ユークリッド互除法
def egcd(a,b)
  if a%b==0 then [0,1,b]
  else
    xp,yp,gcd = egcd(b,a%b)
    [yp,xp-(a/b)*yp,gcd]
  end
end

def inv(a,p)
    egcd(a,p)[0]%p
end

# 乗法の演算表
def gfp_table(p)
    t=Hash.new
    (0..(p-1)).each do |a|
        t[a]={}
        (0..(p-1)).each do |b|
            t[a][b]=gfp(a,b,p)
        end
    end
    return t
end

gf3p = gfp_table(3)
=>
 {0=>{0=>0, 1=>0, 2=>0}, 1=>{0=>0, 1=>1, 2=>2}, 2=>{0=>0, 1=>2, 2=>1}}
gf3p[2][1]
=> 2
```

## 楕円曲線

#### GF(p) での楕円曲線上の加法

<img src="https://render.githubusercontent.com/render/math?math=\displaystyle x_1 = x_2, y_1 + y_2 = 0  mod(p)">
のとき
<img src="https://render.githubusercontent.com/render/math?math=\displaystyle R' = P + Q = O = (\infty, \infty) ">

それ以外のとき

直線PQの傾き lambda

![formula](https://render.githubusercontent.com/render/math?math=R=(x_3,y_3))


<img src="https://render.githubusercontent.com/render/math?math=\displaystyle R(x_4,y_4)=(x_3,-y_3)">

```ruby
def ec_add(pp,qq,a,p)
  x1,y1,x2,y2=pp[0],pp[1],qq[0],qq[1]
  if x1=='inf' and y1=='inf' then
    retuen [x2,y2]
  elsif x2=='inf' and y2=='inf' then
    return [x1,y1]
  elsif x1==x2 and gfa(y1,y2,p)==0 then
    return ['inf','inf']
  else
    lm = lamb(x1,x2,y1,y2,a,p)
    lmsq = gfp(lm,lm,p)
    lmsq_x1 = gfa(lmsq,neg(x1,p),p)
    x3=gfa(lmsq_x1,neg(x2,p),p)
    x3_x1 = gfa(x3,neg(x1,p),p)
    y3 = gfa(gfp(lm,x3_x1,p),y1,p)
    return [x3,neg(y3,p)]
  end
end
```

```ruby

# 直線の傾き
def lamb(x1,x2,y1,y2,a,p)
    if x1==x2 and y1==y2 then
        y1_2 = gfp(2,y1,p)
        x1sq_3 = gfp(3,gfp(x1,x1,p),p)
        x1sq_3_a = gfa(x1sq_3,a,p)
        gfp(x1sq_3_a,inv(y1_2,p),p)
    else
        x2x1=inv(gfa(x2,neg(x1,p),p),p)
        y2y1=    gfa(y2,neg(y1,p),p)
        gfp(y2y1,x2x1,p)
    end
end
```

#### 楕円曲線の点のスカラー倍とその挙動

```ruby
# 点Gのスカラー倍

def scalarP(n,pp,a,p)
    p0=pp
    n.times do
        pp=ec_add(p0,pp,a,p)
    end
    return pp
end

```

 楕円曲線上の点
 
 <img src="https://latex.codecogs.com/gif.latex? y^2=x^3+3x+3 (mod 13)"/>の場合
 
```ruby
# 平方剰余のオイラーの基準で p=  13 の解の存在場所を知る

euler_criterion_test(13)
=> 
[[1, 1], [2, -1], [3, 1], [4, 1], [5, -1], [6, -1], [7, -1], [8, -1], [9, 1], [10, 1], [11, -1], [12, 1]]
```

式の右辺は、1,3,4,9,10,12 だけ。
x=1 なら　右辺は、  7 OK
x=2                 4 OK
x=3                 0 NG
x=4                 1 OK
x=5                 0 NG
x=6                 3 OK
x=7                 3 OK
x=8                 6 NG
x=9                 5 NG
x=10                6 NG
x=11                2 NG
x=12                12 OK
x=0                 0 OK

```ruby
# x=4 のとき、x^3+3x+3=1 なので、y=1
#  したがって　y=1,x=4 [4,1] は楕円曲線上の点
# 巡回群になっていることを確認

p=13
a=3
p0=[4,1]
(1..20).map{|n|scalarP(n,p0,a,p)}
=> 
[[2, 11],
 [6, 9],
 [6, 4],
 [2, 2],
 [4, 12],
 ["inf", "inf"],
 [4, 1],
 [2, 11],
 [6, 9],
 [6, 4],
 [2, 2],
 [4, 12],
 ["inf", "inf"],
 [4, 1],
 [2, 11],
 [6, 9],
 [6, 4],
 [2, 2],
 [4, 12],
 ["inf", "inf"]]
```

#### 楕円曲線上の点のスカラー倍の高速化


バイナリ法による高速化

```ruby
# バイナリ法によるスカラー倍計算
def scalarPB(n,pp,a,p)
  (n.bit_length-2).downto(0).reduce(pp) do |pp,i|  # ビット列を操作する
    if n[i] ==0 then pp=ec_add(pp,pp,a,p)
    else pp=ec_add(pp,ec_add(pp,pp,a,p),a,p)
    end
  end
end
```

速度比較実験

![tex](https://latex.codecogs.com/gif.latex?y^2 = x^3 +3x+3 mod (9910))
とすると

```ruby
p=9901
e=euler_criterion_test(p)
e[0..5]
# => [[1, -1], [2, 1], [3, -1], [4, 1], [5, 1], [6, 1]]
```

 x=2 のとき、式の右辺は、4 なので、y=2
 p0=[2,2] は楕円曲線上の点

```ruby
p=9901
a=3
p0=[2,2]

# 低速版
 (1..5000).map{|n|scalarP(n,p0,a,p)}
 
# バイナリ法による高速版
 (1..5000).map{|n|scalarPB(n,p0,a,p)}
```










