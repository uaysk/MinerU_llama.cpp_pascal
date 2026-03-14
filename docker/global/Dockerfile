FROM python:3.10-slim

ARG MINERU_PYPI_VERSION=2.7.6

WORKDIR /opt/mineru

ENV DEBIAN_FRONTEND=noninteractive \
    MINERU_DEFAULT_BACKEND=vlm-http-client \
    PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1

# This image supports api/gradio with local pipeline/hybrid runtimes while
# leaving the VLM model to an external API by default.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fonts-noto-core \
        fonts-noto-cjk \
        fontconfig \
        libgl1 \
        libglib2.0-0 && \
    fc-cache -fv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml README.md /opt/mineru/
COPY mineru /opt/mineru/mineru

RUN python3 -m pip install -U pip && \
    python3 -m pip install \
    --extra-index-url https://pypi.org/simple \
    --index-url https://download.pytorch.org/whl/cu126 \
    "mineru[core]==${MINERU_PYPI_VERSION}" \
    "torch==2.7.1" \
    "torchvision==0.22.1" && \
    python3 -m pip install --no-deps --no-build-isolation . && \
    find /usr/local/lib/python3.10 -type d -name __pycache__ -prune -exec rm -rf {} + && \
    find /usr/local/lib/python3.10 -type f -name '*.pyc' -delete

RUN /bin/bash -c "MINERU_MODEL_SOURCE=huggingface mineru-models-download -s huggingface -m pipeline"

ENTRYPOINT ["/bin/bash", "-c", "exec \"$@\"", "--"]
