ARG K_COMMIT
FROM runtimeverificationinc/kframework-k:ubuntu-bionic-${K_COMMIT}

RUN    apt-get update           \
    && apt-get upgrade --yes    \
    && apt-get install --yes    \
            cmake               \
            curl                \
            jq                  \
            libboost-test-dev   \
            libcrypto++-dev     \
            libgflags-dev       \
            libprocps-dev       \
            libsecp256k1-dev    \
            libssl-dev          \
            netcat-openbsd      \
            pkg-config          \
            python3             \
            python-pygments     \
            python-recommonmark \
            python-sphinx       \
            rapidjson-dev

RUN    git clone 'https://github.com/z3prover/z3' --branch=z3-4.8.7 \
    && cd z3                                                        \
    && python scripts/mk_make.py                                    \
    && cd build                                                     \
    && make -j8                                                     \
    && make install                                                 \
    && cd ../..                                                     \
    && rm -rf z3

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN    apt-get update               \
    && apt-get upgrade --yes        \
    && apt-get install --yes nodejs

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g $GROUP_ID user && useradd -m -u $USER_ID -s /bin/sh -g user user

USER user:user
WORKDIR /home/user

RUN    git config --global user.email 'admin@runtimeverification.com' \
    && git config --global user.name  'RV Jenkins'                    \
    && mkdir -p ~/.ssh                                                \
    && echo 'host github.com'                       > ~/.ssh/config   \
    && echo '    hostname github.com'              >> ~/.ssh/config   \
    && echo '    user git'                         >> ~/.ssh/config   \
    && echo '    identityagent SSH_AUTH_SOCK'      >> ~/.ssh/config   \
    && echo '    stricthostkeychecking accept-new' >> ~/.ssh/config   \
    && chmod go-rwx -R ~/.ssh
