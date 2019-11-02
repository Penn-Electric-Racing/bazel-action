FROM openjdk:11

ARG BAZEL_VERSION=1.1.0

RUN apt-get-update \
    && apt-get install software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y \
        g++-9 \
        gcc-9 \
        zlib1g-dev \
        bash-completion \
        patch \
        python3 \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    curl \
        --fail \
        --silent \
        --show-error \
        --location \
        --output bazel.deb.sha256 \
        "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel_${BAZEL_VERSION}-linux-x86_64.deb.sha256"

RUN set -ex; \
    curl \
        --fail \
        --silent \
        --show-error \
        --location \
        --remote-name \
        "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel_${BAZEL_VERSION}-linux-x86_64.deb" \
    && cat bazel.deb.sha256 | sha256sum -c - \
    && dpkg -i "bazel_${BAZEL_VERSION}-linux-x86_64.deb" \
    && rm "bazel_${BAZEL_VERSION}-linux-x86_64.deb"

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
