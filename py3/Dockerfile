# Full version: Google Colab 2026.04-ish GPU runtime
# Colab 2026.04: Ubuntu 22.04.5, Python 3.12.13, numpy 2.0.2,
# PyTorch 2.10.0, JAX 0.7.2, TensorFlow 2.19.0.
# The PyTorch image keeps CUDA/cuDNN/PyTorch consistent and avoids rebuilding torch from pip.
FROM pytorch/pytorch:2.10.0-cuda12.8-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo \
    PIP_NO_CACHE_DIR=1 \
    TF_CPP_MIN_LOG_LEVEL=2

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    git \
    wget \
    curl \
    ca-certificates \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    libgl1 \
    libsndfile1 \
    ffmpeg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY requirements-colab-full.txt /install/requirements-colab-full.txt

RUN python -m pip install --upgrade pip==24.1.2 setuptools==75.2.0 wheel==0.46.3 \
 && python -m pip install --upgrade-strategy only-if-needed -r /install/requirements-colab-full.txt \
 && python -m ipykernel install --name python3 --display-name "Python 3 (Colab-like full)"

EXPOSE 8888
CMD ["jupyter-lab", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--notebook-dir=/workspace"]
