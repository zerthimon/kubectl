FROM debian

MAINTAINER Lior Goikhburg <goikhburg@gmail.com>

RUN apt-get -y update \
  && echo "tzdata tzdata/Areas select Europe" | debconf-set-selections \
  && echo "tzdata tzdata/Zones/Etc select UTC" | debconf-set-selections \
  && echo "tzdata tzdata/Zones/Europe select Moscow" | debconf-set-selections \
  && echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections \
  && echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, ru_RU.UTF-8 UTF-8" | debconf-set-selections \
  && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
    locales \
    tzdata \
  && rm -rf /etc/timezone /etc/localtime \
  && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata \
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
