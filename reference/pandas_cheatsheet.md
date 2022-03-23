# Pandas の基本的用法

## 読み込み
+ `import pandas as pd`

## シリーズ定義
+ pd.Series(１次元データ、index=成分名のリスト)

## データフレーム定義
+ pd.DataFrame(二次元データ,columns=列の名称リスト,index=行の名称リスト)
   + df= pd.DataFrame([[1,2],[3,4],[5,6]],columns=["x","y"],index=["p","q","r"])

## ndarray に戻す
+ df.to_numpy()

## 情報の取り出しと変更

+ 名前による
   + `x`列  df["x"], `df.x`もOK
      + 新しいデータに書き換え df["x"]=新しい値のリスト   
   + `p`行  df.loc["p"]
      + 新しいデータに書き換え df.loc["p"]=新しい値のリスト   
   + `p`行`x`列 df.loc["p","x"]  df.x["p"], df.loc["p"]["x"]
      + 書き換え  df.loc["p","x"]=新しい値

+ 行番号、列番号による
   + $j$列 df.iloc[:,j]    df[df.columns[j]]
   + $i$行 df.iloc[i]
   + $(i,j)$成分 df.iloc[i,j]   
   
## 情報の追加
+ 名を指定して列を追加（既存名だと上書き）
   + df["new"]=dfの行数と同じ長さのリスト
       + df.loc[:,"new"] でもよい
   + df["new"]=np.ones(4)

+ 名を指定して行を追加
   + df.loc["new"]= df の列数と同じ長さのリスト

## 変換(df は変わらない)
+ 列の一部を取り出す  df[コラム名のリスト]

+ 列の削除  df.drop(columns=削除するコラムのリスト)
   + df.drop(columns=["id","color"])
   + df.drop(columns=df.columns[:2]) 最初の２列を捨てる

+ 順番入替、重複
    + df[コラム名のリスト] で、そのリストをコラムとするdf を返す 
    + 例 df[["z","y","x"]] 
    + 例 df[reversed(df.columns)]  で列の順番を逆転

+ コラム名の変更
    + df.columns=新しい列名リスト（長さは len(df.columns) )
    + df.index=新しい行名リスト 
    + rename による部分変更
        + df.rename({"x":"X"},{"a":"A"})
+ 転置  df.T 

## 計算
+ 各行に関数f を適用して得られる pd.series  ( index は df.index)
   df.apply(f,axis=1)

+ 各列に関数f を適用して得られる pd.series  ( index は df.columns )
   df.apply(f,axis=0), あるいは単にdf.apply(f)

## 値で並べ替え
+ 列について並べ替える
   + df.sort_values(コラム名,ascending=True)   コラム名の列を昇順で（デフォルト)

+ 複数列について   
   + df.sort_values(列名リスト,ascending={True,False,..})    各コラムの昇順・降順をリストで指定
   
+ 行について並べ変える
   + df.sort_values(行名リスト, axis=1)

## コラム名・インデックス名を並べ替える
+ inplace=False とするとdfは書き換えない. デフォルトでは描き変わる
   + df.sort_index(axis=1,inplace=False,ascending=False). 列名を降順に並べ替える. 
   + df.sort_index(). 行名を並べ替える. 
   
## 検索
+ ある列の要素についての条件で検索
   + df[df.x>2,axis=1] ... x成分が2より大きい行を取り出す
   + df[np.all([df.x>0, df.y<0]),axis=0] x成分が正、y成分が負の行を取り出す   
   + これは df[df.apply(lambda w: w.x>0 and w.y<0,axis=1)] ともかける
   + 正式には df[df.apply(lambda w: w["x"]>0 and w["y"]<0,axis=1)] 

+ ある行の要素についての条件で検索
   + df.loc[:,df.loc["a"]>0]  .  a行が正の列を取り出す
   + df.loc[:, np.all([df.loc["a"]>0, df.loc["b"]<0],axis=0)]
     df.loc[:,df.apply(lambda x:x["a"]>0 and x["b"]<0)]

## グループ分
+ df.groupby(列名)
   + df.groupby(列名のリスト)
+ dfgr=df.groupby(列名のリスト)
    結果のタイプはpandas.core.groupby.generic.DataFrameGroupBy
+ dfgr.indices は 辞書. キーは指定列値のタプル、値は、指定列がそのタプルとなる行名のリスト	
   + dfgr.indices.keys により、指定列値のタプル全体

+ 列clistの値keyとなる行を選ぶ(key はタプル）
   df.loc[df.groupby(clist).indices[key]]

   + 例. df.loc[df.groupby([0,1]).indices[(-2,-2)]

+ df.sort_values(列名リスト) でもグループわけは見える:下左 



  同様の表示は次の関数で得られる`make_df(df,[0,1])`　下右 
  
<img src="../img/sort_values.png" height=800>
<img src="../img/groupby2.png" height=800>

~~~~~
	def list2str(u):
		if isinstance(u,list):
			return("-".join([str(i) for i in u]))
		else:
			return str(u)

	def listminus(xlist,ylist):
		return [u for u in xlist if not(u in ylist)]

	def make_df(df,clist):
		dfgr=df.groupby(clist)
		dfgrind=dfgr.indices
		dfx=pd.DataFrame()
		xlist=listminus(df.columns,clist)
		counter=0
		for u in dfgrind.keys():
			for w in dfgrind[u]:
				dfx.loc[counter,"key"]=list2str(u)
				for j in xlist:
					dfx.loc[counter,j]=df.loc[w,j]
				counter+=1
		dfxlast=dfx[xlist].astype(int)
		dfxlast["index"]=dfx.key
		dfxlast=dfxlast[ ["index", *xlist]]
		return dfxlast

	def selected(df,clist,key):
		dfgr=df.groupby(clist)
		dfgrind=dfgr.indices
		xlist=listminus(df.columns,clist)
		return df.loc[dfgrind[key],xlist]
~~~~~    

 




