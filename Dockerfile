# Debian 12
FROM python:3.12.4-bookworm

ARG user_id=501
ARG group_id=20
ARG user_name=developer
# The WORKDIR instruction can resolve environment variables previously set using ENV.
# You can only use environment variables explicitly set in the Dockerfile.
# https://docs.docker.com/engine/reference/builder/#/workdir
ARG home=/home/${user_name}

RUN apt-get update -qq && \
  apt-get upgrade -y -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    ca-certificates \
    git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

#
# Add user.
#
#   Someone uses devcontainer, but the others don't.
#   That is why dockerfile calls `features` MANUALLY here without devcontainer.json.
#
RUN cd /usr/src && \
  git clone --depth 1 https://github.com/devcontainers/features.git && \
  USERNAME=${user_name} \
  UID=${user_id} \
  GID=${group_id} \
  CONFIGUREZSHASDEFAULTSHELL=true \
    /usr/src/features/src/common-utils/install.sh

#
# Install packages
#
RUN apt-get update -qq && \
  apt-get upgrade -y -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    # Basic
    iputils-ping \
    # Editor
    vim emacs \
    # Utility
    tmux \
    # fzf needs PAGER(less or something)
    fzf \
    exa \
    trash-cli && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/

COPY zshrc-entrypoint-init.d /etc/zshrc-entrypoint-init.d

USER ${user_name}
WORKDIR /home/${user_name}

RUN pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir pipenv

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["tail", "-F", "/dev/null"]
