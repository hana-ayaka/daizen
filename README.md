# 前処理大全をDockerコンテナごと作成する  

### **1.imageをpullする**
[Docker Hub](https://hub.docker.com/r/jupyter/datascience-notebook/tags)  
今回は```jupyter/datascience-notebook:bada6c21e945```使用  
必要に応じて適宜変更

***  

### **2. 作業ディレクトリを作成**  
ディレクトリを作成し、前処理に必要なデータとスクリプトを投入  
  
  * run.sh  
```
#!/bin/sh

docker \
  run \
  -it \
  -p 8008:8888 \
  --platform=linux/amd64 \
  -v $(pwd):/home/jovyan/work \
  --workdir=/home/jovyan/work \
  jupyter/datascience-notebook:bada6c21e945
  ```
  * Dockerfile  
  ```
FROM jupyter/datascience-notebook:bada6c21e945


WORKDIR home/jovyan/work

EXPOSE 8888

ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser" , "--allow-root", "--NotebookApp.token=''"]
```
  (必要であれば)  
  * docker-compose.yml  

***  

### **3. docker run**  

作業フォルダに移動して、シェル数リプとを起動する  
```$ source run.sh```  
***
### **4. jupyterlabを立ち上げる**

ブラウザ上で　`localhost:8008:8888` を立ち上げる  
8008:8888のサーバーを使用中であれば、シェルスクリプトのポート番号を変更する必要あり  
  
***  

 ### **5.必要なライブラリをインポートする**  
```conda update conda```  
* [変数表示するためのライブラリ](https://github.com/lckr/jupyterlab-variableInspector)    
  ```conda install -c conda-forge jupyterlab-variableinspector```  
* pandas-profiling  
  ```conda install -c conda-forge pandas-profiling```  


***
 ### **6.commitしてimageを圧縮ファイルに変換する**  
 [docker commitの仕方](https://www.hobby-happymylife.com/環境構築/docker_package_save/)　　

[加藤さんメモ](https://riken-share.ent.box.com/notes/803741575708)    

[圧縮の仕方](https://qiita.com/leomaro7/items/e5474e67a8e41536f0ff)  

 サーバーをシャットダウンして、  
 ```$ docker ps -a```
 で該当のコンテナを確認する  
 例)
 ```
CONTAINER ID   IMAGE                                       COMMAND                  CREATED              STATUS                        PORTS                    NAMES
ca0ec00dca7f   jupyter/datascience-notebook:bada6c21e945   "tini -g -- start-no…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:8008->8888/tcp   priceless_mirzakhani
```
コミットする  
```$ docker commit CONTAINER ID repository名:tag名 ```  
保存できているか確認  
```$ docker images```  
例)  
```
REPOSITORY                     TAG            IMAGE ID       CREATED         SIZE
jupyter/datascience-notebook   bada6c21e945   3e42253ea027   6 seconds ago   7.45GB
```
圧縮する  
```$ docker save IMAGE ID > image.tar``` 　

 ### **7.圧縮ファイルを解凍して立ち上げ、ライブラリが入っているか確認する**  

解凍する  
```$ docker load -i image.tar```  
保存できているか確認  
```$ docker images``` 
```
docker-daizen % docker images
REPOSITORY                     TAG       IMAGE ID       CREATED          SIZE
<none>                         <none>    3e42253ea027   31 minutes ago   7.45GB
```

ここで、docker run してもDockerfileに書かれたものが起動してしまう（ライブラリなどを入れる前の）
どのように起動したら良いか調べる必要あり

とりあえず、run.shを書き換える(立ち上げるイメージIDを記載)    
  * run.sh  
```
#!/bin/sh

docker \
  run \
  -it \
  -p 8008:8888 \
  --platform=linux/amd64 \
  -v $(pwd):/home/jovyan/work \
  --workdir=/home/jovyan/work \
  3e42253ea027
  ```  

→うまく立ち上がった！しかしREPOSITORY,TAGが<none>だと、いくつもdocker立ち上げたときにわかりづらい・・・。commitの段階で、オプションがあるのではないか・・・？  
[コミット時のタグ付](https://zenn.dev/suiudou/articles/9493fa8c4c7369)  
[docker tagコマンドのタグ付](https://www.memotansu.jp/docker/657/)  

 ### **7.サーバーにimageをコピーして起動できるか確認する**  
 今回試したサーバー：  
``` $ docker load -i image.tar```  
```$ docker images```   
```REPOSITORY                     TAG                    IMAGE ID       CREATED         SIZE
<none>                         <none>                 3e42253ea027   5 days ago      7.45GB
```  
→立ち上がった！しかしどこで見るのか分からない。。。　　
念の為のlog
```
  mori@DL-BoxII:/home/kato/work/data_share/docker-maesyori$ source run.sh
Entered start.sh with args: jupyter lab
Executing the command: jupyter lab
[I 2022-11-18 06:46:58.466 ServerApp] jupyterlab | extension was successfully linked.
[W 2022-11-18 06:46:58.470 NotebookApp] 'ip' has moved from NotebookApp to ServerApp. This config will be passed to ServerApp. Be sure to update your config before our next release.
[W 2022-11-18 06:46:58.470 NotebookApp] 'port' has moved from NotebookApp to ServerApp. This config will be passed to ServerApp. Be sure to update your config before our next release.
[W 2022-11-18 06:46:58.470 NotebookApp] 'port' has moved from NotebookApp to ServerApp. This config will be passed to ServerApp. Be sure to update your config before our next release.
[I 2022-11-18 06:46:58.477 ServerApp] nbclassic | extension was successfully linked.
[I 2022-11-18 06:46:58.656 ServerApp] notebook_shim | extension was successfully linked.
[I 2022-11-18 06:46:58.672 ServerApp] notebook_shim | extension was successfully loaded.
[I 2022-11-18 06:46:58.672 LabApp] JupyterLab extension loaded from /opt/conda/lib/python3.10/site-packages/jupyterlab
[I 2022-11-18 06:46:58.672 LabApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[I 2022-11-18 06:46:58.675 ServerApp] jupyterlab | extension was successfully loaded.
[I 2022-11-18 06:46:58.678 ServerApp] nbclassic | extension was successfully loaded.
[I 2022-11-18 06:46:58.679 ServerApp] Serving notebooks from local directory: /home/jovyan/work
[I 2022-11-18 06:46:58.679 ServerApp] Jupyter Server 1.23.1 is running at:
[I 2022-11-18 06:46:58.679 ServerApp] http://d2b44c13c114:8888/lab?token=6ed8f76030b1a4c8bbf3cdb5f23c61988b19e507c50e34fc
[I 2022-11-18 06:46:58.679 ServerApp]  or http://127.0.0.1:8888/lab?token=6ed8f76030b1a4c8bbf3cdb5f23c61988b19e507c50e34fc
[I 2022-11-18 06:46:58.679 ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 2022-11-18 06:46:58.681 ServerApp]

    To access the server, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/jpserver-7-open.html
    Or copy and paste one of these URLs:
        http://d2b44c13c114:8888/lab?token=6ed8f76030b1a4c8bbf3cdb5f23c61988b19e507c50e34fc
     or http://127.0.0.1:8888/lab?token=6ed8f76030b1a4c8bbf3cdb5f23c61988b19e507c50e34fc
```  

[リモートサーバーのjupyterに接続するには](https://www.servernote.net/article.cgi?id=connect-remote-jupyter-notebook)  
[SSH先のサーバ上のjupyter notebookをローカルPCで操作する](https://sishida21.github.io/2019/12/12/remote-jupyter-notebook/)  

普通に「ipアドレス:8008(ポート番号)」で設定可能だった  
