FROM ubuntu:24.04

RUN sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' /etc/dpkg/dpkg.cfg.d/excludes

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install --no-install-recommends -y \
        ca-certificates && \
    update-ca-certificates && \
    apt-get install --no-install-recommends -y \
        arping \
        curl \
        dnsutils \
        iperf3 \
        jq \
        less \
        man \
        manpages-posix \
        mtr \
        net-tools \
        netcat-traditional \
        openssl \
        openssh-client \
        psmisc \
        socat \
        tcpdump \
        telnet \
        tmux \
        traceroute \
        tcptraceroute \
        tree \
        vim \
        wget && \
    # Install Docker
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        docker-ce-cli \
        docker-buildx-plugin \
        docker-compose-plugin -y && \
    rm -rf /var/lib/apt/lists/* && \
    # Install kubectl
    curl -sLf "https://storage.googleapis.com/kubernetes-release/release/v1.30.1/bin/linux/$(dpkg --print-architecture)/kubectl" > /usr/local/bin/kubectl-1.30 && \
    curl -sLf "https://storage.googleapis.com/kubernetes-release/release/v1.29.5/bin/linux/$(dpkg --print-architecture)/kubectl" > /usr/local/bin/kubectl-1.29 && \
    curl -sLf "https://storage.googleapis.com/kubernetes-release/release/v1.28.10/bin/linux/$(dpkg --print-architecture)/kubectl" > /usr/local/bin/kubectl-1.28 && \
    chmod +x /usr/local/bin/kubectl* && \
    ln -s /usr/local/bin/kubectl-1.30 /usr/local/bin/kubectl && \
    mkdir -p /root/.kube && \
    # Install yq
    wget "https://github.com/mikefarah/yq/releases/download/v4.44.1/yq_linux_$(dpkg --print-architecture)" -O /usr/bin/yq && \
    chmod +x /usr/bin/yq
