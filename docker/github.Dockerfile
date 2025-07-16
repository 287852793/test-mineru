# Use the official sglang image
FROM docker.1ms.run/lmsysorg/sglang:v0.4.8.post1-cu126

# Install libgl for opencv support
RUN apt-get update && apt-get install -y libgl1 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple 

# install mineru latest
RUN python3 -m pip install -U 'mineru[all]' --break-system-packages

# Download models and update the configuration file
RUN /bin/bash -c "mineru-models-download -s modelscope -m all"

# # alias
# RUN echo "alias ll='ls $LS_OPTIONS -l'" >> /root/.bashrc

# install gradio
RUN pip install gradio --break-system-packages
RUN pip install gradio-pdf --break-system-packages
RUN pip install magic-pdf[full] --break-system-packages

RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6


# RUN export FLASH_ATTENTION_FORCE_BUILD=0
# RUN pip install flash-attn==2.5.6 --index-url https://pypi.nvidia.com --break-system-packages

# # timezone
# RUN echo 'export LANG="C.UTF-8"'>>/root/.bashrc; \
#     ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
#     echo "Asia/Shanghai" > /etc/timezone

RUN pip install flash-attn --no-build-isolation --break-system-packages

COPY app.py /opt/app.py
# COPY header.html /opt/header.html
# COPY frpc_linux_amd64 /root/.cache/huggingface/gradio/frpc/frpc_linux_amd64_v0.3
RUN mkdir /opt/examples

COPY entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["sh", "/opt/entrypoint.sh"]

# Set the entry point to activate the virtual environment and run the command line tool
# ENTRYPOINT ["/bin/bash", "-c", "export MINERU_MODEL_SOURCE=local && exec \"$@\"", "--"]