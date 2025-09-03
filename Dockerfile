FROM devkitpro/devkita64:latest

# Metadata indicating an image maintainer.
LABEL maintainer="d3fau4@not-d3fau4.com"

# Environment variables
ENV DEVKITPRO=/opt/devkitpro \
    DEVKITARM=/opt/devkitpro/devkitARM \
    DEVKITPPC=/opt/devkitpro/devkitPPC \
    CMAKE_VERSION="4.1.1" \
    WORKDIR="/build"

ENV PATH="${PATH}:${DEVKITARM}/bin/:${DEVKITPPC}/bin/:${DEVKITPRO}/bin/"

WORKDIR "${WORKDIR}"

# Install CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
        -q -O /tmp/cmake-install.sh && \
    chmod u+x /tmp/cmake-install.sh && \
    mkdir /opt/cmake-${CMAKE_VERSION} && \
    /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-${CMAKE_VERSION} && \
    ln -s /opt/cmake-${CMAKE_VERSION}/bin/* /usr/local/bin && \
    rm /tmp/cmake-install.sh

# Instala Node 20 LTS
RUN apt-get update && apt-get install -y curl ca-certificates gnupg \
    && install -d -m 0755 /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y nodejs \
    && node -v && npm -v \
    && rm -rf /var/lib/apt/lists/*

# Install Libnx
RUN git clone --depth=1 https://github.com/switchbrew/libnx.git /tmp/libnx && \
    cd /tmp/libnx && \
    make && \
    make install && \
    rm -rf /tmp/libnx

# Install libnxtc
RUN git clone --depth=1 https://github.com/DarkMatterCore/libnxtc.git /tmp/libnxtc && \
    cd /tmp/libnxtc && \
    make && \
    make install && \
    rm -rf /tmp/libnxtc