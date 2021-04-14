FROM debian

MAINTAINER Lior Goikhburg <goikhburg@gmail.com>

RUN apt-get -y update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
    gnupg \
    ca-certificates \
    apt-transport-https \
    wget \
    bash \
    bash-completion \
  && wget -qO - https://baltocdn.com/helm/signing.asc | apt-key add - \
  && echo "deb [ arch=amd64 ] https://baltocdn.com/helm/stable/debian/ all main" > /etc/apt/sources.list.d/helm.list \
  && wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && echo "deb [ arch=amd64 ] https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list \
  && apt-get -y update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
    helm \
    kubectl \
  && apt-get clean all \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
  && echo '' >> /etc/bash.bashrc \
  && echo '. /etc/bash_completion' >> /etc/bash.bashrc \
  && echo 'source <(/usr/bin/kubectl completion bash)' >> /etc/bash.bashrc \
  && echo 'source <(/usr/sbin/helm completion bash)' >> /etc/bash.bashrc
