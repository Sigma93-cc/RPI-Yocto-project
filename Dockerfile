FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Зависимости Yocto (scarthgap / Poky 5.x)
RUN apt-get update && apt-get install -y \
    gawk \
    wget \
    git \
    diffstat \
    unzip \
    texinfo \
    gcc \
    build-essential \
    chrpath \
    socat \
    cpio \
    python3 \
    python3-pip \
    python3-pexpect \
    python3-jinja2 \
    python3-git \
    python3-subunit \
    xz-utils \
    debianutils \
    iputils-ping \
    libssl-dev \
    libelf-dev \
    lz4 \
    zstd \
    liblz4-tool \
    file \
    locales \
    sudo \
    tmux \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN groupadd -g 1000 ubuntu && \
useradd -u 1000 -g ubuntu -m ubuntu && \
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ubuntu

USER ubuntu:ubuntu
WORKDIR /home/ubuntu/work

CMD ["/bin/bash"]
