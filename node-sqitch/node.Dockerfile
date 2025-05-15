FROM scottw/alpine-perl:5.32.0

ENV TZ=UTC

# ENV TZ UTC
# RUN apk add --no-cache postgresql-dev
# RUN cpanm App::Sqitch DBD::Pg -n

# Base tools and development libraries
RUN apk add --no-cache \
  bash \
  curl \
  git \
  make \
  gcc \
  musl-dev \
  perl-dev \
  postgresql-dev \
  zlib-dev \
  tzdata 

# Install Sqitch with Postgres support
RUN cpanm --quiet --notest App::Sqitch DBD::Pg

# Verify installation
RUN sqitch --version 


ENV NODE_VERSION=20.12.0

# Download, build, and install Node.js from source
RUN curl -fsSL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz | tar -xz && \
    cd node-v$NODE_VERSION && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf node-v$NODE_VERSION


# # Install specific Node.js version using n (Node version manager)
# RUN apk add --no-cache nodejs npm yarn && \
#     npm install -g n && \
#     n 20.12.0 && \
#     apk del nodejs npm 

# # Symlink binaries from n into standard path
# RUN ln -sf /usr/local/n/versions/node/20.12.0/bin/node /usr/local/bin/node && \
#     ln -sf /usr/local/n/versions/node/20.12.0/bin/npm /usr/local/bin/npm && \
#     ln -sf /usr/local/n/versions/node/20.12.0/bin/npx /usr/local/bin/npx

# Confirm it's working
# RUN node -v && npm -v

# Add configuration files
ADD mount/etc /etc
ADD mount/dotfiles /root

WORKDIR /app
