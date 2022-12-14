# dockerの立ち上げ方  

(M1とM1以外では動作が異なる)
## M1チップ以外の場合  

### **1.Githubから必要なものをPULLしてくる**  
https://github.com/ayakamori0702/daizen  

### **2.dockerfileをbuildする**  
```$ docker build -t ja-maesyori:v0.0 .```  

確かめるとき
```& docker images```

### **3.docker runする**  
```$ source run.sh```  
このとき、run.shの```リポジトリ名:タグ名 またはコミットID``` が合っているか確認する.
***
## M1チップの場合  
### **1.image.tarをdocker loadする**  
``` $ docker load -i image.tar```  

確かめるとき
```& docker images```
### **2.docker runする**  
```$ source run.sh```  
このとき、run.shの```リポジトリ名:タグ名 またはコミットID``` が合っているか確認する.  
*** 






