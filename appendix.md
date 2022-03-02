# 付録 数学的基礎

## 整数論

#### 排他的論理和

```ruby
data=0b1010     # データ
=> 10
key = 0b1100    # 暗号鍵
=> 12

# 排他的論理和による暗号化
e = data^key
=> 6
# 復号化
e^key
=> 10

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
def fraction(a,n)
  x,y,d=egcd(a,n)
  return x%n                                        
end

fraction(11,17)
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
@primes = eratosthenes([*2..10000],[])

# フェルマーの小定理
def fermat(a,p)
  (a**(p-1))%p
end

# 実験
a=rand(100)
@primes[0..100].each{|prime| 
     if a%prime !=0 then 
       p [prime, fermat(a,prime)]
     end
}
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

 $ \varphi(n) $
 
 n と互いに素な1 以上 n 以下の自然数の個数


$ n=\prod_{k=1}^d p_k^{e_k} $

に対して

$ \varphi(n)= \prod_{k=1}^d (p_k^{e_k} - p_k^{e_k - 1})$

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
φ(mn) = φ(m)φ(n)

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

$  a^{\varphi(m)} \equiv1 \mod  m $

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
$  a^{\varphi(m)+1} \equiv a \mod  m $

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

#### モンゴメリ法

#### <img src="https://render.githubusercontent.com/render/math?math=\displaystyle 2^{\omega}-ary">法

### 素数生成

#### フェルマーテスト

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
(1..12).map{|a|qfactor2(10,a,13)}
=> [[26, 65], [], [39, 52], [13, 104], [], [], [], [], [13], [26, 91], [], [13]]
```

## 有限体論

GF(p) の演算表の作成

```ruby
# 加法の演算表
def gf_add(p)
    t=Hash.new
    (0..(p-1)).each do |i|
        t[i]={}
        (0..(p-1)).each do |j|
            t[i][j]=(i+j)%p
        end
    end
    return t
end

gf3a = gf_add(3)
=>
 {0=>{0=>0, 1=>1, 2=>2}, 1=>{0=>1, 1=>2, 2=>0}, 2=>{0=>2, 1=>0, 2=>1}}
gf3a[2][2]
=> 1
# 乗法の演算表
def gf_prod(p)
    t=Hash.new
    (0..(p-1)).each do |i|
        t[i]={}
        (0..(p-1)).each do |j|
            t[i][j]=(i*j)%p
        end
    end
    return t
end

gf3p = gf_prod(3)
=>
 {0=>{0=>0, 1=>0, 2=>0}, 1=>{0=>0, 1=>1, 2=>2}, 2=>{0=>0, 1=>2, 2=>1}}
gf3p[2][1]
=> 2
```


## 楕円曲線

### 楕円曲線上の2点P,Qの加法

### 有限体上の楕円曲線

#### GF(p) での楕円曲線上の加法

#### 楕円曲線の点のスカラー倍とその挙動

#### 楕円曲線上の点のスカラー倍の高速化













