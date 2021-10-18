## 正誤表（第1刷）

- p.v 目次 一番下の行に追加
    - 誤：（一番下の行に追加）
    - 正：4.6 秘密計算……………………102

- p.54 3章 上から11行目
    - 誤：1996年
    - 正：1994年

- p.70 3章 下から2行目（参考文献[2]）
    - 誤：https://cryptorating.eu/whitepapers/イーサリアム/イーサリアム_white_paper.pdf
    - 正：https://cryptorating.eu/whitepapers/Ethereum/Ethereum_white_paper.pdf

- p.75 4章 上から16行目（「散対数仮定（DL仮定）」の項）
    - 誤：生成限g
    - 正：生成元g

- p.75 4章 上から19行目（「CDH仮定」の項）
    - 誤：生成限g
    - 正：生成元g

- p.75 4章 上から22行目（「DDH仮定」の項）
    - 誤：生成限g
    - 正：生成元g

- p.102 4章 下から9行目
    - 誤：秘密計算
    - 正：4.6 秘密計算

- p.130 5章 上から3つ目のコード
    - 誤：
```
$ bitcoin-cli testmempoolaccept

‘[“02000000000101bc4f51d2e183933de3700b705803bfd997bc8724c04de6183ebcfccf7ba73dfd0100000000ffffffff0240420f00000000001600146fb60ab91b28a7694f9d84fbbe03e4675e83b063583e0f00000000001600142ecec71383a8b205357ecacadf06c12634d320140247304402203b3903282e6f5aa84b81aa90744baddadb8ae7b78c8a4a353982cdc9b007f3d802204d4780ea05c4cbd02aff75dfca82982aae5bb65318685d5c523e37beeb26610d0121023fc25fd67f73d8fd6d720e45b1ebf5d9b1788f253877166a45efb386bf15b2f600000000”]’
```

   正：

```
$ bitcoin-cli testmempoolaccept

‘[“02000000000101bc4f51d2e183933de3700b705803bfd997bc8724c04de6183ebcfccf7ba73dfd0100000000ffffffff0240420f00000000001600146fb60ab91b28a7694f9d84fbbe03e4675e83b063583e0f00000000001600142ecec71383a8b205357ecacadf06c12634d320140247304402203b3903282e6f5aa84b81aa90744baddadb8ae7b78c8a4a353982cdc9b007f3d802204d4780ea05c4cbd02aff75dfca82982aae5bb65318685d5c523e37beeb26610d0121023fc25fd67f73d8fd6d720e45b1ebf5d9b1788f253877166a45efb386bf15b2f600000000"]’
[
 {
   “txid”: “856fe6d990663065d548dec117013477e7558053070649ccaa4325f2df51f969",
   “allowed”: true,
   “vsize”: 141,
   “fees”: {
     “base”: 0.00001000
   }
 }
]
```

- p.151 6章 表6.8 の説明
    - 誤：（行は前半２ビットで後半３ビット）
    - 正：（行は前半２ビットで，列は後半３ビット）

- p.167 6章 上から7行目
    - 誤：ゲーム論
    - 正：ゲーム理論

- p.168 6章 上から7行目
    - 誤：ゲーム論
    - 正：ゲーム理論

- p.341 付録 上から4行目の数式の説明文
    - 誤：乗法逆元演算
![\begin{align*}
\frac{1}{x}
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5Cfrac%7B1%7D%7Bx%7D%0A%5Cend%7Balign%2A%7D%0A)
は加法逆元演算 
 ![\begin{align*}
-y
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A-y%0A%5Cend%7Balign%2A%7D%0A)
に写像される

    - 正：乗法逆元演算
![\begin{align*}
\frac{1}{a}
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5Cfrac%7B1%7D%7Ba%7D%0A%5Cend%7Balign%2A%7D%0A)
は加法逆元演算
![\begin{align*}
-x \quad (x = \log (a))
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A-x+%5Cquad+%28x+%3D+%5Clog+%28a%29%29%0A%5Cend%7Balign%2A%7D%0A)
に写像される

- p.347 付録「巡回群としてのGF(p<sup>n</sup>)」 下から4行目の数式
  - 誤：
![\begin{align*}
\theta^{1} = 1
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5Ctheta%5E%7B1%7D+%3D+1%0A%5Cend%7Balign%2A%7D%0A)

  - 正：
![\begin{align*}
\theta^{1} = \theta
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5Ctheta%5E%7B1%7D+%3D+%5Ctheta%0A%5Cend%7Balign%2A%7D%0A)

- p.351 付録「有限体上の楕円曲線」 上から6行目の数式
  - 誤：
![\begin{align*}
\{(x, y) \mid x, y \in G\!F(p) \} \cup \{ ( \infty, \infty ) \}
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5C%7B%28x%2C+y%29+%5Cmid+x%2C+y+%5Cin+G%5C%21F%28p%29+%5C%7D+%5Ccup+%5C%7B+%28+%5Cinfty%2C+%5Cinfty+%29+%5C%7D%0A%5Cend%7Balign%2A%7D%0A)

  - 正：
![\begin{align*}
\{(x, y) \mid x, y \in G\!F(p) \} \cup \{ ( \infty, \infty ) \}
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5C%7B%28x%2C+y%29+%5Cmid+x%2C+y+%5Cin+G%5C%21F%28p%29+%5C%7D+%5Ccup+%5C%7B+%28+%5Cinfty%2C+%5Cinfty+%29+%5C%7D%0A%5Cend%7Balign%2A%7D%0A)
． ここで (∞, ∞) は無限遠点O．

<!--
数式画像を生成するにあたり，以下サイトを使いました．
https://tex-image-link-generator.herokuapp.com/
-->
