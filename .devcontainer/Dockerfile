FROM mcr.microsoft.com/devcontainers/ruby:1-3.3-bullseye

WORKDIR /workspaces/${LOCAL_WORKSPACE_FOLDER_BASENAME}

# Update/Upgrade to latest software, add keys and sources, install software
RUN wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/postgres.list

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt -y upgrade
RUN apt -y install --no-install-recommends postgresql-client-16 pspg libpq-dev

# Install NodeJS & npm & yarn
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs

# Environment
ENV PS1="\[\]\w\$ \[\]"
ENV PAGER=pspg

# Go is not installed by default, but if using the optional `bin/dev` dev setup, then it becomes necessary.
ENV GOBIN=/usr/local/bin
ENV GO111MODULE=on
