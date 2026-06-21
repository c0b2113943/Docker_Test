# Colab-like Docker Environment

このフォルダには、Google Colab に近い Docker 実行環境を用意しています。

環境は以下の2種類です。

- フル版：Google Colab 2026.04 GPU環境に近いライブラリ構成
- 軽量版：PyTorchを使うための最小構成

---

## 1. フル版

フル版は、Google Colab 2026.04 GPU環境の主要ライブラリにできるだけバージョンを合わせた環境です。

主な構成は以下です。

- PyTorch 2.10.0 + CUDA 12.8 + cuDNN 9
- TensorFlow 2.19.0
- JAX 0.7.2
- numpy 2.0.2
- JupyterLab
- OpenCV
- scikit-learn
- pandas
- matplotlib
- 画像分類・機械学習でよく使うライブラリ

フル版は、Colab環境に近い状態で実験したい場合に使用します。

### 起動

実行権限の付与
```bash
chmod +x start.sh stop.sh attach.sh
```

```bash
./start.sh full
```

`full` は省略可能です。

```bash
./start.sh
```

### コンテナに入る

```bash
./attach.sh full
```

または、

```bash
./attach.sh
```

### 停止

```bash
./stop.sh full
```

または、

```bash
./stop.sh
```

### ブラウザでアクセス

```text
http://<ホスト名またはIP>:3141
```

例：

```text
http://10.0.0.3:3141
```

---

## 2. 軽量版

軽量版は、PyTorchで画像分類などを行うための最小構成です。

TensorFlow、JAX、Colab系の大きなライブラリは入れていません。

そのため、フル版よりも以下の利点があります。

- ビルドが速い
- イメージサイズが小さい
- 依存関係のトラブルが少ない

PyTorchだけを使う実験では、基本的に軽量版で十分です。

### 起動

```bash
./start.sh light
```

### コンテナに入る

```bash
./attach.sh light
```

### 停止

```bash
./stop.sh light
```

### ブラウザでアクセス

```text
http://<ホスト名またはIP>:3142
```

例：

```text
http://10.0.0.3:3142
```

---

## 3. shファイルについて

この環境では、Docker Composeコマンドを直接打たなくても操作できるように、以下の3つのシェルスクリプトを用意しています。

```text
start.sh
stop.sh
attach.sh
```

それぞれの役割は以下です。

| ファイル | 役割 |
|---|---|
| `start.sh` | Docker環境をビルドして起動する |
| `stop.sh` | Docker環境を停止する |
| `attach.sh` | 起動中のコンテナに入る |

最初に実行権限を付けてください。

```bash
chmod +x start.sh stop.sh attach.sh
```

---

## 4. GPU確認

コンテナ内に入ったあと、以下を実行してGPUが使えるか確認します。

```python
import torch

print(torch.__version__)
print(torch.cuda.is_available())
print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else "CPU only")
```

以下のように表示されればGPUを使用できます。

```text
True
```

GPU名が表示されれば正常です。

例：

```text
NVIDIA GeForce RTX 4070 Ti SUPER
```

`False` または `CPU only` と表示される場合は、GPUが認識されていません。

---

## 5. CUDAとNVIDIAドライバについて

この環境では CUDA 12.8 系のコンテナを使用します。

そのため、ホスト側の NVIDIA ドライバが古い場合、GPUを認識できないことがあります。

GPUが認識されない場合は、まずホスト側で以下を確認してください。

```bash
nvidia-smi
```

DockerからGPUが見えるか確認する場合は、以下を実行します。

```bash
docker run --rm --gpus all nvidia/cuda:12.8.0-base-ubuntu22.04 nvidia-smi
```

もし CUDA 12.8 が使えない場合は、`Dockerfile` と `Dockerfile.light` の `FROM` を CUDA 12.6 系などに変更してください。

例：

```dockerfile
FROM pytorch/pytorch:2.10.0-cuda12.6-cudnn9-runtime
```

---

## 6. Colab環境とのバージョン合わせ

フル版では、主要ライブラリのバージョンを Google Colab 2026.04 GPU ランタイムにできるだけ合わせています。

実際にDockerでインストールするファイルは以下です。

```text
py3/requirements-colab-full.txt
```

軽量版で使用するファイルは以下です。

```text
py3/requirements-light.txt
```

また、Colab本体の `pip freeze` を参考として以下に保存しています。

```text
py3/requirements-colab-2026.04-gpu-freeze-reference.txt
```

このファイルは参考用です。直接 `pip install -r` するためのファイルではありません。

理由は、Colab専用のローカルパッケージや、通常のDocker環境では入らない特殊なパッケージが含まれるためです。

例：

```text
google-colab @ file:///...
```

---

## 7. PyTorchについて

PyTorch本体は `requirements.txt` からインストールするのではなく、Dockerのベースイメージに含まれています。

使用しているPyTorch構成は以下です。

```text
torch==2.10.0+cu128
torchvision==0.25.0+cu128
torchaudio==2.10.0+cu128
```

`cu128` は CUDA 12.8 対応版という意味です。

---

## 8. 使い分け

通常のPyTorch実験では、軽量版を使います。

```bash
./start.sh light
```

Colabと近い環境で再現したい場合や、TensorFlow・JAXも使いたい場合は、フル版を使います。

```bash
./start.sh full
```

基本的には、普段の画像分類実験は軽量版、Colab環境との再現性を重視する場合はフル版を使用します。
