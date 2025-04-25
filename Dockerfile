# Usa imagem base com Python 3.7
FROM python:3.7-slim

# Atualiza o sistema e instala dependências
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    git \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    libomp-dev \
    libpng-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libx11-dev \
    libgl1-mesa-glx \
    python3-pip \
    python3-dev \
    python3-venv \
    python3-tk \
    x11vnc \
    novnc \
    && apt-get clean

# Clonar o repositório do GitHub
RUN git clone https://github.com/Tassio-Lima-dos-Santos/carla-no-gpu.git /app

# Definir o diretório de trabalho para o código clonado
WORKDIR /app

# Baixa o arquivo .egg do CARLA 0.9.13 (via link direto do GitHub)
#RUN wget https://github.com/carla-simulator/carla/releases/download/0.9.13/carla-0.9.13-py3.7-linux-x86_64.egg

# Instala o CARLA
#RUN pip install carla-0.9.13-py3.7-linux-x86_64.egg
RUN pip install carla==0.9.13

# Instala o pygame (versão compatível com Python 3.7)
RUN pip install pygame==2.0.1

# Rodar o servidor VNC e noVNC
RUN mkdir -p /root/.vnc && \
    x11vnc -storepasswd 1234 /root/.vnc/passwd

# Comando para rodar o script Python do Pygame
CMD x11vnc -forever -usepw -create && python3 /app/client/run.py
