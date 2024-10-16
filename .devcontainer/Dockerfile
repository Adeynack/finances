FROM ruby:3.3.4

WORKDIR /workspaces/${LOCAL_WORKSPACE_FOLDER_BASENAME}

# Update/Upgrade to latest software, add keys and sources, install software
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt -y upgrade
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive
RUN apt -y install --no-install-recommends postgresql-client pspg libpq-dev
RUN apt -y install --no-install-recommends tmux

# Install/Update Ruby Dependencies
RUN gem update --system

# Install NodeJS & npm & yarn
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs && npm install -g yarn

# Environment
ENV PS1="\[\]\w\$ \[\]"
ENV PAGER=pspg
