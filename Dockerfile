FROM jupyter/datascience-notebook:bada6c21e945


WORKDIR home/jovyan/work

EXPOSE 8888

ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser" , "--allow-root", "--NotebookApp.token=''"]

#CMD ["--notebook-dir=/home/jovyan/work"]

