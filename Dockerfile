FROM jupyter/datascience-notebook:bada6c21e945

#日本語フォントを拾ってくる
USER root
RUN apt-get update && \
    apt -y install curl &&\
    apt -y install zip
RUN curl -L  "https://moji.or.jp/wp-content/ipafont/IPAexfont/ipaexg00401.zip" > font.zip
#展開
RUN unzip font.zip
#展開したファイルをcondaのfontを設定するディレクトリにコピー
RUN cp ipaexg00401/ipaexg.ttf /opt/conda/lib/python3.10/site-packages/matplotlib/mpl-data/fonts/ttf/ipaexg.ttf
#font.familyの書き換え
RUN echo "font.family : IPAexGothic" >>  /opt/conda/lib/python3.10/site-packages/matplotlib/mpl-data/matplotlibrc
#キャッシュを削除
#RUN rm -r /root/.cache/matplotlib


RUN pip install --upgrade pip &&\
    pip install pandas-profiling\
    pip install japanize-matplotlib


USER jovyan

WORKDIR home/jovyan/work

EXPOSE 8888

ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser" , "--allow-root", "--NotebookApp.token=''"]
