# Debian 12
FROM debian:bookworm-20240904

ARG user_name=developer
ARG user_id
ARG group_id
ARG dotfiles_repository="https://github.com/uraitakahito/dotfiles.git"
ARG features_repository="https://github.com/uraitakahito/features.git"
ARG extra_utils_repository="https://github.com/uraitakahito/extra-utils.git"
ARG python_version=3.12.5

#
# Git
#
RUN apt-get update -qq && \
  apt-get install -y -qq --no-install-recommends \
    ca-certificates \
    git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

#
# clone features
#
RUN cd /usr/src && \
  git clone --depth 1 ${features_repository}

#
# Add user and install common utils.
#
RUN USERNAME=${user_name} \
    USERUID=${user_id} \
    USERGID=${group_id} \
    CONFIGUREZSHASDEFAULTSHELL=true \
    UPGRADEPACKAGES=false \
      /usr/src/features/src/common-utils/install.sh

#
# Install Python
#   https://github.com/uraitakahito/features/blob/mymain/src/python/install.sh
#
# see also:
#   https://github.com/uraitakahito/features/blob/426e14ecbc3df89ea63f7b3b0a3721f2960f119a/src/python/install.sh#L667-L670
ENV PATH=$PATH:/usr/local/python/current/bin

RUN USERNAME=${user_name} \
    VERSION=${python_version} \
      /usr/src/features/src/python/install.sh

#
# Install extra utils.
#
RUN cd /usr/src && \
  git clone --depth 1 ${extra_utils_repository} && \
  ADDEZA=true \
  UPGRADEPACKAGES=false \
    /usr/src/extra-utils/install.sh

COPY docker-entrypoint.sh /usr/local/bin/

USER ${user_name}

#
# poetry
#
RUN pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir poetry

#
# dotfiles
#
RUN cd /home/${user_name} && \
  git clone --depth 1 ${dotfiles_repository} && \
  dotfiles/install.sh

WORKDIR /app
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["tail", "-F", "/dev/null"]
