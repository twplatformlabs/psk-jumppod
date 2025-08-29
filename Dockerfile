FROM ubuntu:24.04

LABEL org.opencontainers.image.created="%%CREATED%%" \
      org.opencontainers.image.authors="nic.cheneweth@thoughtworks.com" \
      org.opencontainers.image.url="https://github.com/twplatformlabs/psk-jumppod" \
      org.opencontainers.image.documentation="https://github.com/twplatformlabs/psk-jumppod" \
      org.opencontainers.image.source="https://github.com/twplatformlabs/psk-jumppod" \
      org.opencontainers.image.version="%%VERSION%%" \
      org.opencontainers.image.vendor="ThoughtWorks, Inc." \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.title="psk-jumppod" \
      org.opencontainers.image.description="Ubuntu-based image containing common Kubernetes and networking tools as kubectl exec target" \
      org.opencontainers.image.base.name="%%BASE%%"

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/home/jumppod/bin:/home/jumppod/.local/bin:$PATH \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

# Configured for automatic, monthly build using current package repository release versions.
# Pinned package versions available using YYYY.MM tag.
# hadolint ignore=DL3008,DL3004,DL3027
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90forceyes && \
    echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90forceyes && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt update && apt-get install --no-install-recommends -y \
        build-essential \
        tzdata \
        locales \
        apt-transport-https \
        lsb-release \
        gettext-base \
        gcc \
        g++ \
        cmake \
        make \
        sudo \
        curl \
        wget \
        git \
        git-lfs \
        openssh-server \
        tar \
        gzip \
        unzip \
        zip \
        bzip2 \
        jq \
        gnupg \
        gnupg-agent \
        dnsutils \
        apt-utils \
        nmap \
        traceroute \
        iputils-ping \
        ca-certificates \
        python3-dev \
        python3-pip \
        python3-venv && \
    sudo ln -f -s /usr/bin/pydoc3 /usr/bin/pydoc && \
    sudo ln -f -s /usr/bin/python3 /usr/bin/python && \
    sudo ln -f -s /usr/bin/python3-config /usr/bin/python-config && \
    sudo install -m 0755 -d /etc/apt/keyrings && \
    sudo bash -c "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg" && \
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt-get update && sudo apt-get install --no-install-recommends -y \
         gh && \
    sudo bash -c "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen && \
    useradd --uid=3434 --user-group --create-home jumppod && \
    usermod --shell /bin/bash jumppod && \
    echo 'jumppod ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    sudo -u jumppod mkdir -p /home/jumppod/bin && \
    sudo -u jumppod mkdir -p /home/jumppod/.local/bin && \
    sudo -u jumppod mkdir /home/jumppod/.gnupg && \
    sudo -u jumppod bash -c "echo 'allow-loopback-pinentry' > /home/jumppod/.gnupg/gpg-agent.conf" && \
    sudo -u jumppod bash -c "echo 'pinentry-mode loopback' > /home/jumppod/.gnupg/gpg.conf" && \
    chmod 700 /home/jumppod/.gnupg && chmod 600 /home/jumppod/.gnupg/* && \
    download_version=$(curl -s https://api.github.com/repos/etcd-io/etcd/releases/latest | grep '"tag_name":' | head -n1 | cut -d '"' -f4) && \
    download_url="https://github.com/etcd-io/etcd/releases/download/${download_version}/etcd-${download_version}-linux-amd64.tar.gz" && \
    curl -L "$download_url" -o "etcd-${download_version}-linux-amd64.tar.gz" && \
    tar xzf "etcd-${download_version}-linux-amd64.tar.gz" && \
    sudo mv "etcd-${download_version}-linux-amd64/etcdctl" /usr/local/bin/etcdctl && \
    rm -rf "etcd-${download_version}-linux-amd64" && rm "etcd-${download_version}-linux-amd64.tar.gz" && \
    current_version=$(curl -s https://api.github.com/repos/istio/istio/releases/latest | jq -r '.tag_name') && \
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION="${current_version}" sh - && \
    sudo cp "istio-${current_version}/bin/istioctl" /usr/local/bin/istioctl && \
    rm -rf "istio-${current_version}" && \
    sudo apt-get clean && rm -rf /var/lib/apt/lists/*

USER jumppod

WORKDIR /home/jumppod
