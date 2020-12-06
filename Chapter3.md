# 3章 演習

## 演習課題

* ρ法を用いて暗号学的ハッシュ関数の衝突ペアを求めてください。ただし，利用する暗号学的ハッシュ関数は SHA-256の先頭２バイトを取る関数とします。

## 回答例

```ruby
require 'digest'

# SHA-256 の先頭16ビットに限定したハッシュ関数
def sha(x)
	Digest::SHA256.hexdigest(x)[0..8]
end

# ρ法による衝突ペアの探索
def roh(h0)
    ppsm,ppdm=h0,h0
    psm=sha(ppsm)  		# single hash
    pdm=sha(sha(ppdm))	# double hash
    sm=sha(psm)  			# single hash
    dm=sha(sha(pdm))		# double hash
	begin
     ppsm,ppdm=psm,pdm
     psm,pdm=sm,dm
	  sm=sha(psm)				# single hash
	  dm=sha(sha(pdm))		# double hash
	  puts "---"
     p [ppsm,ppdm]
     p [psm,pdm]
	  p [sm,dm]
	end until sm==dm
	return [sha(pdm),ppsm]
end
roh('0000')
```

