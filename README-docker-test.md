# Colab-like Docker Environment

このフォルダには、2種類のDocker環境を用意しています。

## 1. フル版

Google Colab 2026.04 の主要構成に寄せた環境です。

- PyTorch 2.10.0 + CUDA 12.8 + cuDNN 9
- TensorFlow 2.19.0
- JAX 0.7.2
- numpy 2.0.2
- JupyterLab
- 画像分類・機械学習でよく使うライブラリ

起動:

```bash
docker compose up -d --build
```

ブラウザ:

```text
http://<ホスト名またはIP>:3141
```

## 2. 軽量版

PyTorchで画像分類などを行うための最低限環境です。TensorFlow、JAX、巨大なColab系ライブラリは入れていません。

起動:

```bash
docker compose -f docker-compose.light.yml up -d --build
```

ブラウザ:

```text
http://<ホスト名またはIP>:3142
```

## GPU確認

コンテナ内で以下を実行します。

```python
import torch
print(torch.__version__)
print(torch.cuda.is_available())
print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else "CPU only")
```

## 注意

CUDA 12.8系のコンテナを使うため、ホスト側NVIDIAドライバが古い場合はGPUを認識しません。その場合は、`Dockerfile` と `Dockerfile.light` の `FROM` を `pytorch/pytorch:2.10.0-cuda12.6-cudnn9-runtime` などに変更してください。


## Colab version pinning

The full requirements file now pins major libraries to Google Colab 2026.04 GPU runtime versions as much as possible.
The exact Colab reference is saved as `py3/requirements-colab-2026.04-gpu-freeze-reference.txt`.
It is not installed directly because Colab's full `pip freeze` contains Colab-only local packages such as `google-colab @ file:///...` and special NVIDIA/RAPIDS wheels that often fail outside the managed Colab image.

For PyTorch, the Docker base image provides the Colab-matching CUDA stack:

```text
torch==2.10.0+cu128
torchvision==0.25.0+cu128
torchaudio==2.10.0+cu128
```
