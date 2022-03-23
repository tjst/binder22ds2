FROM ubuntu
ENV DEBIAN_FRONTEND=noninteractive
RUN echo '* libraries/restart-without-asking boolean true' | debconf-set-selections
RUN apt-get update && apt-get install -y curl
RUN apt install -y tzdata
# RUN apt-get install -y node.js
RUN apt install -y curl python3.8 python3-pip
RUN pip install jupyterlab 
RUN pip install plotly
RUN pip install jupyter_contrib_nbextensions jupyter_nbextensions_configurator
RUN pip install ipywidgets
RUN pip install numpy
RUN pip install pandas
RUN pip install sympy
RUN pip install networkx matplotlib pydotplus
RUN apt install -y graphviz
RUN apt install -y python-dev libgraphviz-dev pkg-config
RUN apt-get install -y npm
RUN npm install -g n
RUN n stable
RUN jupyter labextension install jupyterlab-plotly
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager plotlywidget
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --minimize=False
RUN pip install torch scikit-learn 
#RUN jupyter-lab --ip=0.0.0.0 --allow-root --port=8888
ARG NB_USER=dsii
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
RUN echo "dsii:dsii" | chpasswd
RUN gpasswd -a "dsii" sudo
# RUN mkdir -p ${HOME}
# Make sure the contents of our repo are in ${HOME}
# COPY . ${HOME}
# COPY ./dsii/*  ${HOME}/dsii
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
RUN cd ${HOME}
