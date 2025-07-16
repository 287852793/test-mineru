# Use the official sglang image
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-c"]

### change the system source for installing libs
ARG USE_SRC_INSIDE=true
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list ; \
    sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list ; \
    echo "Use aliyun source for installing libs" ;

RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends  vim wget curl dmidecode tzdata poppler-utils python3 python3-pip python-is-python3 

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple 

WORKDIR /tmp
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# setup jupyter
RUN pip install jupyterlab
RUN pip install jupyter-core
RUN pip install --upgrade jupyter
RUN pip install --upgrade ipykernel
RUN pip install ipywidgets

# RUN http_proxy="http://172.21.21.35:7890/" https_proxy="http://172.21.21.35:7890/" && wget https://gcore.jsdelivr.net/gh/opendatalab/MinerU@master/magic-pdf.template.json -O  /root/magic-pdf.json 
# RUN http_proxy="http://172.21.21.35:7890/" https_proxy="http://172.21.21.35:7890/" && wget https://gcore.jsdelivr.net/gh/opendatalab/MinerU@master/scripts/download_models.py -O  /root/download_models.py 
# # Copy the configuration file template and install magic-pdf latest
# RUN http_proxy="" https_proxy="" &&pip install  magic-pdf[full]
# RUN pip install modelscope
# # Download models and update the configuration file
# RUN /bin/bash -c "python /root/download_models.py && \
#     sed -i 's|cpu|cuda|g' /root/magic-pdf.json"

RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends libgl1-mesa-glx 
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*
RUN pip install -U setuptools wheel cython
RUN pip install --only-binary=PyYAML PyYAML
RUN pip install pydantic pydantic-settings
# RUN pip install --extra-index-url https://pypi.org/simple -U 'mineru[all]'
RUN pip install -U "mineru[all]" -i https://mirrors.aliyun.com/pypi/simple \
    --use-deprecated=legacy-resolver

# install gradio
RUN pip install gradio
RUN pip install gradio-pdf
RUN pip install magic-pdf[full] 

# install mineru latest
# Download models and update the configuration file
RUN /bin/bash -c "mineru-models-download -s modelscope -m all"

RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libgl1-mesa-glx \
    libglib2.0-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install packaging setuptools wheel
RUN pip install -i https://pypi.org/simple/ flashinfer_python==0.2.7
RUN pip install sglang[all]==0.4.8

# # alias
# RUN echo "alias ll='ls $LS_OPTIONS -l'" >> /root/.bashrc


# RUN export FLASH_ATTENTION_FORCE_BUILD=0
# RUN pip install flash-attn==2.5.6 --index-url https://pypi.nvidia.com --break-system-packages

# # timezone
# RUN echo 'export LANG="C.UTF-8"'>>/root/.bashrc; \
#     ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
#     echo "Asia/Shanghai" > /etc/timezone

COPY jupyter_lab_config.py /root/.jupyter/jupyter_lab_config.py

COPY app.py /opt/app.py
COPY header.html /opt/header.html
# COPY frpc_linux_amd64 /root/.cache/huggingface/gradio/frpc/frpc_linux_amd64_v0.3
RUN mkdir /opt/examples

COPY entrypoint.sh /opt/entrypoint.sh

RUN echo 'export LANG="C.UTF-8"'>>/root/.bashrc; \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo "Asia/Shanghai" > /etc/timezone

WORKDIR /opt
ENTRYPOINT ["sh", "/opt/entrypoint.sh"]

# Set the entry point to activate the virtual environment and run the command line tool
# ENTRYPOINT ["/bin/bash", "-c", "export MINERU_MODEL_SOURCE=local && exec \"$@\"", "--"]