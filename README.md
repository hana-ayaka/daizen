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
