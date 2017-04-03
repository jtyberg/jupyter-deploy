FROM jupyter/all-spark-notebook:c33a7dc0eece

MAINTAINER justin.tyberg@gmail.com

# Do the pip installs as the unprivileged notebook user
USER jovyan

RUN pip install --upgrade pip

# Notebook extensions
ARG DASHBOARDS_VER=0.6.*
RUN pip install "jupyter_dashboards==$DASHBOARDS_VER" && \
    jupyter dashboards quick-setup --sys-prefix
ARG CMS_VER=0.6.*
RUN pip install "jupyter_cms==$CMS_VER" && \
    jupyter cms quick-setup --sys-prefix

# OpenCV for image processing
RUN conda update -y conda && \
    conda install -y -c https://conda.binstar.org/menpo opencv3
# Hack to remove unnecessary "-lippicv".
# (see https://github.com/opencv/opencv/issues/5852)
# Alternative hack: http://askubuntu.com/questions/720528/opencv-compiling-error-ippicv
RUN sed -e 's/-lippicv//' -i ${CONDA_DIR}/lib/pkgconfig/opencv.pc

# XGBoost
RUN cd /tmp && mkdir -p xgboost && \
    git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && \
       make -j4 && \
       cd python-package && python setup.py install && cd - \
    cd /tmp && rm -rf xgboost

RUN pip install --no-cache-dir \
# Scientific libraries
    plotly==2.0.* \
    pymc3 \
    pystan==2.14.* \
    image==1.5.* \
    statsmodels==0.8.0 \
# Data access
    pymongo==3.4.* \
    cloudant==2.4.* \
    python-keystoneclient==3.8.0 \
    python-swiftclient==3.2.0 \
# Deep Learning frameworks
    tensorflow \
    keras
