# dockerの立ち上げ方  

(M1とM1以外では若干動作が異なる)


### **1.Githubから必要なものをPULLしてくる**  
https://github.com/ayakamori0702/daizen  
必要なスクリプトやデータがあれば、追加して入れる
### **2.dockerfileをbuildする**  
```$ docker build -t maesyori:v0.0 .```  

確かめるとき
```& docker images```

### **3.docker runする**  
```$ source run.sh```  
このとき、run.shの **リポジトリ名:タグ名 またはイメージID** が合っているか確認する.
(M1の場合、最後の行はイメージIDでないとだめ)




