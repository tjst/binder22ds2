# plotly の基本的な使い方
## 読み込み
+ `import plotly.express as px`
+ `import plotly.graph_objects as go`
+ `import plotly.figure_factory as ff`

## px に基本的な使い方
+ X,Y,class : 長さ$k$のリスト
  `px.scatter(x=X,y=Y,color=class)` 点(X[i],Y[i])を、class に応じた色でうつ。


+ df: データフレームで "x","y"というコラムがあり、数値データである時、

  `px.scatter(df,x="x",y="y")`  各行を座標とする点をプロット
  
  `px.line(df,x="x",y="y")`  各行を座標とする点をつなぐ線分をプロット  

+ `t=np.linspace(5,-5)` 

   `px.line(x=t,y=np.sin(t))` で sin　の曲線を描ける.
                 
   `px.line(x=np.sin(3*t),y=np.cos(5*t))` でサイクロイドが描ける

+ 細かい調整
   
   + 最初に `fig=px.scatter(df,x="x",y="y")`  最後に `fig.show()`

   + xy軸の比を同じに `fig.update_yaxes(scaleanchor="x", scaleratio=1)`

   + X,Y軸タイトルを指定 

       `fig.update_xaxes(title="x")`
       `fig.update_yaxes(title="y")`

   + update_layout  で、複雑な修正ができる

        `fig.update_layout(title="タイトル名",title_x=0.5,
                  xaxis_title = "x", yaxis_title="y",
				  width = 800, height = 400,
                  font=dict(family="Times",size=18,color="black"))`

+ dataframe を引数に置くこと
   + df:データフレーム. コラムに "x","y","class" がある時
     `px.scatter(df,x="x",y="y",color="class")` で、(x,y)をクラス別に色をつけてプロット


## go の基本的な使い方

+ `t=np.linspace(5,-5)`として

		fig = go.Figure(data=[
			go.Scatter(x=t, y=np.sin(t), name="sin"),
			go.Scatter(x=t, y=np.cos(t), name="cos"),
		])
		fig.show()

+ `fig=go.Figure()` で初めて
   `fig.add_trace(...)`
   `fig.update_layout(...)` 
   で描いていく.
   
+ px.scatter と同じ
 `fig.add_trace(go.Scatter(x=t, y=np.sin(t), name="sin")`  

   + 点プロットは　`mode="scatter"` とする
   
## 平面曲線の表示（等高線表示)
+ f は２変数関数. propagete 可能

~~~~~~
def show_curve(f,xrange=[0,1],yrange=[0,1],T=20,start=0,end=0,size=1):
    import numpy as np
    import plotly.graph_objects as go
    xmin,xmax=xrange
    ymin,ymax=yrange
    a0=np.linspace(xmin,xmax,T)
    b0=np.linspace(ymin,ymax,T)
    x,y=np.meshgrid(a0,b0)
    F=go.Figure()
    F.add_contour(x=a0,y=b0,z=f(x,y),colorscale="oranges",
        contours=dict(
            start=start, # 等高線の高さの最小値
            end=end,    # 等高線の高さの最大値
            size=size, # 描く間隔
            coloring='lines',
            showlabels=True
        ))
    F.update_yaxes(scaleanchor="x", scaleratio=1)
    F.show()
~~~~~~
		
+ 例 `show_curve(lambda x,y:y**2-x**3+x,xrange=[-5,5],yrange=[-5,5],start=-10,end=10,size=2)`

<img src="../img/plotly_curve.png" width=500>


## 曲面表示
+ 

~~~~~~
def my_surface_plot(f,xmin=-1,xmax=1,ymin=-1,ymax=1,K=50,opacity=0.5):
    import numpy as np
    import plotly.graph_objects as go
    a0=np.linspace(xmin,xmax,K)
    b0=np.linspace(ymin,ymax,K)
    x,y=np.meshgrid(a0,b0)
    F=go.Figure()
    F.add_surface(x=x,y=y,z=f(x,y),opacity=opacity)   
    F.show()
~~~~~~


## ff(figure.factory) の使い方
+ ベクトル場 
   + x,y は 平面の格子点のx,y射影
   + u,v は (x,y)でのベクトル方向

   `fig = ff.create_quiver(x,y, u, v,name="ベクトル場 ",scaleratio=1)`


## ベクトル場と解曲線の表示関数
+ 使うもの ff, scipy.integrate 
+ gradは ２変数から２変数への関数

~~~~~~~
def calculate_vf(grad,xrange=[0,1],yrange=[0,1],T=20):
    xmin,xmax=xrange
    ymin,ymax=yrange
    x0,y0 = np.meshgrid(np.linspace(xmin,xmax,T),np.linspace(ymin,ymax,T))
    x1,y1=x0.reshape(T*T),y0.reshape(T*T)
    u,v=np.array([grad([x1[i],y1[i]])  for i in range(T*T)]).T
    u0,v0=u.reshape(T,T)                        ,v.reshape(T,T)
    return [x0,y0,u0,v0]

def show_vf(grad,xrange=[0,2],yrange=[0,2],T=10,opacity=0.5):
    import plotly.figure_factory as ff
    x,y,u,v= calculate_vf(grad,xrange=xrange,yrange=yrange,T=T)
    return ff.create_quiver(x,y, u, v,name="(-0.1) x ベクトル場 ",scaleratio=1,opacity=opacity)
~~~~~~~

+ 例
 `show_vf(lambda u:[-u[1],u[0]],xrange=[-2,2],yrange=[-2,2])`

<img src="../img/plotly_ff_vf.png" width=500>

## 解曲線の表示

~~~~~~~
def show_sol(grad,init,tmax=1,xrange=[0,2],yrange=[0,2],t_eval=100,width=600,opacity=0.5):
    from scipy.integrate import solve_ivp
    import numpy as np
    fig=show_vf(grad,xrange=xrange,yrange=yrange,opacity=opacity)
    result=solve_ivp(lambda t,v: grad(v),(0,tmax), init,t_eval=np.linspace(0,tmax,t_eval))
    sol=pd.DataFrame((result.y).T,columns=["x","y"])
    sol["t"]=result["t"]
    fig.add_scatter(x=sol.x,y=sol.y,name="解曲線")
    fig.add_scatter(x=sol.iloc[[0,]].x,y=sol.iloc[[0,]].y,mode="markers",name="初期点")
    fig.add_scatter(x=sol.iloc[[-1]].x,y=sol.iloc[[-1]].y,mode="markers",name="最終点")
    #fig.update_layout(dict(width=600))
    fig.update_layout(width=width)   
    return fig
~~~~~~~

## add_shape (第６回）
+ 線分追加  type="line"

   (x,y) と (u,v) を結ぶ線分を追加

   データフレーム df の欄名が "x","y","u","v" の場合
   
   直線の形状はオプション `line=dict(...)` で指定
   
~~~~~~~
   fig.add_shape(type="line",xref="x",yref="y",
        x0=df.x,y0=df.y,x1=df.u,y1=df.v,
        line=dict(color=mycolor(nc),width=1))
~~~~~~~



<!-- -------- -->

<!-- fig = px.scatter(x=x, y=y, -->
<!--                  log_y = True, -->
<!--                  width = 800, height = 400, -->
<!--                 color_discrete_sequence=["red"]) -->

<!-- -------- -->

<!-- import plotly.graph_objects as go -->
<!-- fig = go.Figure() -->
<!-- fig.add_trace(go.Scatter(x=xs, y=sins, name="sin")) -->
<!-- fig.add_trace(go.Scatter(x=xs, y=randoms, name="random")) -->
<!-- fig.show() # 上と同じ結果 -->

<!-- fig.update_xaxes(title="x") # X軸タイトルを指定 -->
<!-- fig.update_yaxes(title="y") # Y軸タイトルを指定 -->

<!-- fig.update_xaxes(range=(1,3)) # X軸の最大最小値を指定 -->
<!--  # X軸に range slider を表示（下図参照） -->
<!-- fig.update_xaxes(rangeslider={"visible":True})  -->

<!--  # 軸のスケールをX軸と同じに（plt.axis("equal")） -->
<!-- fig.update_yaxes(scaleanchor="x", scaleratio=1) -->


<!-- fig.update_layout(title="Title") # グラフタイトルを設定 -->
<!-- fig.update_layout(font={"family":"Meiryo", "size":20}) # フォントファミリとフォントサイズを指定 -->
<!-- fig.update_layout(showlegend=True) # 凡例を強制的に表示（デフォルトでは複数系列あると表示） -->
<!-- fig.update_layout(xaxis_type="linear", yaxis_type="log") # X軸はリニアスケール、Y軸はログスケールに -->
<!-- fig.update_layout(width=800, height=600) # 図の高さを幅を指定 -->
<!-- fig.update_layout(template="plotly_white") # 白背景のテーマに変更 -->

<!-- fig.add_trace(go.Scatter(x=xs, y=sins, name="sin")) -->

<!-- ---------- -->
