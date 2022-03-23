# numpy cheatsheet
## 基本
| 説明 | 書き方 | 例、コメント |
| :-- | :-- | :-- |
| 読み込み | `import numpy as np` | |
| 連続リスト | `np.arange(1,5)` | => `np.array([1,2,3,4])` |
| ステップ指定連続リスト | `x=np.arange(0,1,0.1)` | => `x=[0,0.1,0.2,..,0.9]` |
| 各要素への関数作用 | `f(x)` | => `[f(0),f(0.1),f(0.2),..,f(0.9)]` |
| 行列 | `A=np.array([[1,2],[3,4],[5,6]])` |  |
| タイプ変更 | `A.reshape(2,3)` | => `np.array([[1,2,3],[4,5,6]])` |
| 転置行列 | `A.T` | => `np.array([[1,3,5],[2,4,6]])` |
| 第i列 | `A[:,i-1]` |  `A.T[i-1]` でも良い|
| 列を取り出す | `x,y=A` | `x=A[:,0],y=A[:,1]` と同じ |
| 第i行 | `A[i-1]` |  |
| 階数 | `np.linalg.matrix_rank(A)` | |
| 逆行列 | `np.linalg.inv(A)` | |
| 固有値と固有ベクトル | `np.linalg.eig(A)` | |
| 対称行列の固有値と正規直交固有ベクトル | `np.linalg.eigh(A)` | |
| 0以上m<font color="red">以下</font>のランダム整数 | `np.random.randint(m)` | 
| n以上m<font color="red">以下</font>のランダム整数 | `np.random.randint(n,m)` | 
| [0,1]区間の一様分布に従うランダム実数 | `np.random.random()` | 


## numpy.ndarray
+ $s$次元. $(k_0,k_1,\cdots,k_{s-1})$型ndarray
    + テンソル $(T_{i_0i_1i_2\cdots i_{s-1}})_{0\leq i_0<k_0, 0\leq i_1<k_1,\cdots}$
    + a.shape :  (k_0,k_1,\cdots,k_{s-1})

+ 値の取り出しx[i], x[i,j] など
    + 値変更は x[i]=同じ長さのarray, x[i,j]=3 など

+  例. (2,2,3)型: (2,3) ndarray の ２成分リスト 
    + 例 x=np.array([[[1,2,3],[4,5,6]],[[7,8,9],[10,11,12]]])
    + x[0]=np.array([[1,2,3],[4,5,6]])
	+ x[0,1]=np.array([4,5,6])
	+ x[0,1,1]=5

+ arrayの一部を取り出す
    1. x[slice,slice]で部分arrayを設定  slice は a:b:step   
	2. x[:,2] はベクトル(*,), 
    3. x[:,2:3] は(*,1)型

+ ndarray の生成
    + `np.linspace(a,b,N)`  [a,b]の間のN個の数(デフォルトでN=50)
    + `np.arange(a,b,dt)`   [a,b]の間の数、dt刻み
    + `np.zeros((3,4))`   ゼロを成分とする(3,4)型のndarray	
    + `np.ones((3,4))`   1を成分とする(3,4)型のndarray		
    + `np.eye(4)`  ４次単位行列
    + `np.meshgrid(x,y): array x,yの直積と、

+ random 関数
    + np.random.randint(a,b)  a以上b以下のランダム整数	
	+ np.random.random()   [0,1]のランダムな数
	+ np.random.choice(a)  list a から一つをランダムに選ぶ
　　　　　+ np.random.choice(a, size=None, replace=True, p=None)
          size 個選ぶ、 replace=True だと重複OK, p は各要素を選ぶ確率¶

+ array の合成
    + np.vstack([a,b,c]) は 同列数のa,b,cを縦に結合
	+ np.hstack([a,b,c]) は同行数のarray a,b,cを横に結合

+ array の取り出し
    + x[x>0] x>0 の行を取り出す
	+ i,j=np.where(X!=0) で i,jは, ０でない要素の住所の第一成分リスト、第二成分リスト

