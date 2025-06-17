FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Instala dependências
RUN apt-get update && apt-get install -y \
    software-properties-common wget unzip git \
    xvfb x11vnc fluxbox curl net-tools \
    libglib2.0-0 libsm6 libxrender1 libxext6 libgtk-3-dev \
    fontconfig fonts-dejavu-core fonts-freefont-ttf fonts-liberation ttf-mscorefonts-installer \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update && apt-get install -y python3.7 python3.7-dev python3.7-distutils \
    && rm -rf /var/lib/apt/lists/* \
    && fc-cache -fv  # Atualiza cache de fontes

# Instala pip e dependências Python
RUN wget https://bootstrap.pypa.io/pip/3.7/get-pip.py \
    && python3.7 get-pip.py \
    && rm get-pip.py \
    && python3.7 -m pip install pygame==2.1.3 carla==0.9.13

# Clona repositórios
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify.git /opt/novnc/utils/websockify \
    && git clone https://github.com/Tassio-Lima-dos-Santos/carla-no-gpu.git /workspace

WORKDIR /workspace

EXPOSE 6080 5900

CMD bash -c "\
    rm -f /tmp/.X1-lock && \
    Xvfb :1 -screen 0 1280x720x16 & \
    sleep 2 && \
    x11vnc -display :1 -nopw -forever -shared -bg && \
    /opt/novnc/utils/websockify/run --web /opt/novnc 6080 localhost:5900 & \
    python3.7 client/run.py --res 1280x720"
