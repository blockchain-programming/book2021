# 付録 演習

## 演習課題


### 演習課題：排他的論理和を使った暗号化と復号化を行うプログラムを作成してください
### 解答例


```ruby
# 暗号化
def encrypt(message,key)
  m=message.unpack("U*")                	# 文字列のビットベクトル変換
  k=key.unpack("U*")                    	# 暗号鍵のビットベクトル変換
  m.zip(k).map{|a,b|a^b}                	# zipして XOR
end
# 復号化
def decrypt(code,key)
  k=key.unpack("U*")                      	# 暗号鍵のビットベクトル変換
  code.zip(k).map{|a,b|a^b}.pack("U*")    	# XORして文字列変換
end
```


### ★演習課題　ユークリッドの互除法（誤差法）のプログラムを作成してください

### 解答例

```ruby
# ユークリッドの誤差法
def gcd(a,b)
  if a%b==0 then return b
  else gcd(b,a%b)
  end
end
```

### ★演習課題 拡張ユークリッド互除法のプログラムを作成してください
a=92378, b= 226765 のときのベズーの方程式の解を求めてください

### ■解答例

```ruby
def egcd(a,b)                                             
  if a%b==0 then [0,1,b]        	 # 再帰の基底 a*0 + b*1 = b 
  else
    xp,yp,gcd = egcd(b,a%b) 	# 再帰 b*xp + a%b*yp = d
    [yp,xp-(a/b)*yp,gcd]   	# 再帰の復帰処理x=yp,y=xp-(a/b)*yp
  end
end
# ベズー方程式 92378x + 226765y=d の解
egcd(92378,226765)
=> [-27, 11, 209]
```

### ★演習課題 剰余群Z/nZ の乗法逆元を求めるプログラムを作成し、Z/4Z における 1/3 を計算してください  
### ■解答例

```ruby
# 拡張ユークリッド互除法 egcd(a,b) を利用
def inverse(a,n)
  x,y,d=egcd(a,n)
  return x%n                                        
end
inverse(3,4)
=>3
```

### ★演習課題 剰余群Z/nZ のnが2つの素数p q の積で、暗号化の指数（公開鍵）がeのとき、復号化の指数（秘密鍵）を求めるプログラムを作成してください。
p= 227, q=191, e= 61のとき、復号化の指数（秘密鍵）d を求めてください
m=12345　をメッセージとし、n=pq, 暗号化をc=me mod n、復号化を cd mod n としたときに、暗号文が d で正しく復号化されることを確認してください

### ■解答例

```ruby
# 乗法逆元 inverse(a,n) を利用
def privateKey(p,q,e)
  return inverse(e,(p-1)*(q-1))                               
end
p=227
q=191
n=p*q
e= 61
# 秘密鍵の生成
d=privateKey(p,q,e)
=> 32381
# 平文メッセージ
msg=12345
# 暗号化
enc=(msg**e)%n
# 復号化
dec=(enc**d)%n
=> 12345
```


### ★演習課題 中国剰余定理による剰余群の変換として
a=x mod p, b=x mod qのとき、c=x mod pq

### ■解答例

```ruby

# 中国剰余定理による剰余群変換
#	拡張ユークリッド互除法関数が前提
def crt(a,b,p,q)
  s,t,d = egcd(p,q)		# 拡張ユークリッド互除法
  (b*s*p+a*t*q)%(p*q)
end
# 実行
# a=5, b=3, p=7, q=11
crt(5,3,7,11)
=> 47
# 逆変換
47%7
47%11
=> 5
=> 3
```

### ★演習課題　オイラーの位数関数Φを実装してください
1から100までの整数について位数を求めてください


### ■解答例

```ruby
# オイラーのΦ関数
# 	ユークリッドの互除法 gcd(a,b) を利用します
def totient(n)
  (1..n).select{|x|gcd(n,x)==1}.size
end
# 実行
p (1..100).map{|y|totient(y)}
```

### ★演習課題　バイナリ法によるべき剰余計算を実装してください

### ■解答例

```ruby 
# バイナリ法によるべき剰余計算
def powmod(a,e,m)
  (e.bit_length-2).downto(0).reduce(a) do |p,i| 		# ビット列を操作する
    if e[i] ==0 then p=(p**2)%m
    else p=(((p**2)%m)*a)%m
    end
  end
end
```

### ★演習課題　フェルマーテストで巨大素数を生成するプログラムを作成してください

### ■解答例

```ruby
#　フェルマーテストによる素数生成
#    最大公約数egcd(a,b) とべき剰余計算powmod(a,n,m)を利用
require 'securerandom'
def ftPrime(size)
  n=0
  begin
    n=SecureRandom.random_number(2**size)
    a=rand(2**size)
    b=rand(2**size)
  end until n%2 !=0 && n%3 !=0 && egcd(a,n)[2]==1 && egcd(b,n)[2]==1 && powmod(a,(n-1),n)==1 && powmod(b,(n-1),n)==1 
  return n
end
```

### ★演習課題　RSA暗号の基本機能を実装して、検証してください

### ■解答例

```ruby

# 拡張ユークリッド互除法
def egcd(a,b)
  if a%b==0 then [0,1,b]
  else
    xp,yp,gcd = egcd(b,a%b)
    [yp,xp-(a/b)*yp,gcd]
  end
end
# 素数生成
require 'securerandom'
def ftPrime(size)
  n=0
  begin
    n=SecureRandom.random_number(2**size)
    a=rand(2**size)
    b=rand(2**size)
  end until n%2 !=0 && n%3 !=0 && egcd(a,n)[2]==1 && egcd(b,n)[2]==1 && powmod(a,(n-1),n)==1 && powmod(b,(n-1),n)==1 
  return n
end
# べき剰余計算
def powmod(a,e,m)
  (e.bit_length-2).downto(0).reduce(a) do |x,i|
    if e[i] ==0 then x=(x*x)%m
    else x=(((x*x)%m)*a)%m
    end
  end
end
# 鍵生成 （2048bit）
p,q= [ftPrime(1024), ftPrime(1024)]
n=p*q				# 公開鍵 n
e=65537				# 公開鍵 e
fai=(p-1)*(q-1)
d=egcd(e,fai)[0]%fai		# 秘密鍵 d
# 平文メッセージ
m=12345678987654321
# 暗号化
c=powmod(m,e,n)
# 復号化
dm=powmod(c,d,n)
```

### ★演習課題　自分が効率的だと思う離散対数を求めるプログラムを作成し
下の離散対数 x とその実行時間を測定してください
1=6x mod 3977219
1=6x mod 25968871

### ■解答例

```ruby
# 離散対数問題のしらみつぶし法
# べき剰余計算
def powmod(a,e,m)
  (e.bit_length-2).downto(0).reduce(a) do |x,i|
    if e[i] ==0 then x=(x*x)%m
    else x=(((x*x)%m)*a)%m
    end
  end
end
def dl(y,g,p)
  for x in (1..p)
    return x if powmod(g,x,p)==y
  end
end
t0=Time.now
puts dl(1,6,3977219)
puts Time.now-t0
t0=Time.now
puts dl(1,6,25968871)
puts Time.now-t0
```

### ★演習課題　素数p に対して、aが{1,2,...p-1} に対するオイラーの基準のリストを計算するプログラムを作成してください

### ■解答例

```ruby
# オイラーの基準
def euler(a,p)
  ((a**((p-1)/2))%p==1 ? 1 : -1)
end
# aに関するオイラーの基準のリスト
def test(p)
  (1..(p-1)).map.with_index{|a,i|[i,euler(a,11)]}
end
```

### ★演習課題　係数体 GF(3)の２次の多項式 f(x)=x2+2x+2が既約多項式であることを確認してください。

### ■解答例

```ruby
g1(x)=x	f(x)/x = x(x+2)+2　			（余り）
g2(x)=1+x	f(x)/(1+x) = (x+1)(x+1)+1　	（余り）
g3(x)=2+x	f(x)/(2+x) = (x+2)x+2　	（余り）
g4(x)=2x	f(x)/2x = 2x☓(2x+1)+2　	（余り）
g5(x)=1+2x	f(x)/(1+2x) = (2x+1)2x+2　	（余り）
g6(x)=2+2x	f(x)/(2+2x) = (2x+2)(2x+2)+1　（余り）
```

### ★演習課題　ベクトル表現された係数体GF(p) 上の多項式の乗算を行うプログラムを作成してください

### ■解答例

```ruby
# 関数定義 多項式の乗算（ベクトル表現）
def product(a,b,p)
  r=Array.new(a.size+b.size-1,0)
  a.map.with_index do |x,i|
    b.map.with_index do |y,j|
       r[i+j]=(r[i+j]+(x*y))%p
    end
  end
  return r
end
# 実行
f=[1,1]   		# f(x)=1+x
g=[2,1]		# g(x)=2+x
product(f,g,3)	# GF(3) 上の多項式の乗算
```

### ★演習課題　多項式のベクトル表現に対して、既約多項式p(x) に関する剰余計算を行うプログラムを作成してください

### ■解答例

```ruby

# 関数 product を前提とする
# 関数定義 多項式の剰余（ベクトル表現）
pol=[2,2,1]				# pol=2+2x+x^2 既約多項式
def mod(f,pol,p)
  (pol.size-f.size).times {f<<0} 	# ベクトルのサイズを揃える
  q=f[-1]/pol[-1]			# f/pol の商
  qpol=pol.map{|x|(q*x)%p}		# 既約多項式のベクトル要素を商倍する
  return f.zip(qpol).map{|x,y|(x-y)%p}[0..pol.size-2]
end
# 実行
f=  [1,0,2]   		# f(x)=1+2x^2
# (θ+1 )☓(2θ+2) = 1
# (θ+1 )☓(2θ+1) = 2θ
t1=[1,1]
t2=[2,2]
t3=[1,2]
mod(product(t1,t2,3),pol,3)
mod(product(t1,t3,3),pol,3)
```

### ★演習課題　GF(pn)の元を生成元としてべき乗するプログラムを作成してください

### ■解答例

```ruby
# 関数 product , mod を前提とする
pol=[2,2,1]		# pol=2+2x+x^2 既約多項式
def pow(n,f,pol,p)
  r=[1,0]
  n.times {r=mod(product(f,r,p),pol,p)}
  return r
end
# 実行---------------------------------
f=[0,1]		# θ
(0..8).each{|i|p(pow(i,f,pol,3))}
```

###★演習課題　GF(32)の各元を生成元とする巡回群の位数を求めるプログラムを作成してください

### ■解答例

```ruby
# 関数 product , mod, pow  を前提とする
pol=[2,2,1]		# pol=2+2x+x^2 既約多項式
def order(f,pol,p)
  o=0
  begin
    o+=1
  end until pow(o,f,pol,3)==[1,0]
  return [f,o]
end
# 実行
list=[[1,0],[2,0],[0,1],[1,1],[2,1],[0,2],[1,2],[2,2]]
list.map{|f|p(order(f,pol,3))}
# 実行結果
[[1, 0], 1]	# 1
[[2, 0], 2]	# 2
[[0, 1], 8]	# θ
[[1, 1], 4]	# θ+1
[[2, 1], 8]	# θ+2
[[0, 2], 8]	# 2θ
[[1, 2], 8]	# 2θ+1
[[2, 2], 4]	# 2θ+2
```















