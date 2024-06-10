FROM ruby:3.2

WORKDIR /workspaces/${LOCAL_WORKSPACE_FOLDER_BASENAME}

# Update/Upgrade to latest software, add keys and sources, install software
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt -y upgrade
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive
RUN apt -y install --no-install-recommends postgresql-client pspg libpq-dev
RUN apt -y install --no-install-recommends tmux

# RUN <<EOF cat >> ~/.bashrc

# # Shorter prompt (fitting narrow VSCode windows without wrapping)
# export PS1="\[\]\w\$ \[\]"

# # Default PostgreSQL Connection
# # Will automatically connect to the devcontainer's attached PostgreSQL
# # database (see "docker-compose.yml") by typing "psql".
# export PGHOST=127.0.0.1 PGPORT=30002 PGUSER=postgres
# export PAGER=pspg
# EOF

# Install NodeJS & npm & yarn
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && apt-get install -y nodejs && npm install -g yarn

# Install Go dependencies
RUN apt -y install --no-install-recommends golang
ENV GOBIN=/usr/local/bin
RUN go install github.com/DarthSim/overmind/v2@latest

# Environment
ENV PS1="\[\]\w\$ \[\]"
ENV PGHOST=127.0.0.1
ENV PGPORT=30002
ENV PGUSER=postgres
ENV PAGER=pspg
