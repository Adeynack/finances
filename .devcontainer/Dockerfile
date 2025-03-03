FROM ruby:3.3.6

WORKDIR /workspaces/${LOCAL_WORKSPACE_FOLDER_BASENAME}

# Update/Upgrade to latest software, add keys and sources, install software
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt -y upgrade
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive
RUN apt -y install --no-install-recommends postgresql-client pspg libpq-dev
RUN apt -y install --no-install-recommends tmux
ADD .tmux.conf /root/.tmux.conf

# Install/Update Ruby Dependencies
RUN gem update --system

# Install NodeJS & npm & yarn
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs && npm install -g yarn

# Environment
ENV PS1="\[\]\w\$ \[\]"
ENV PAGER=pspg

# Install Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit -D -t /usr/local/bin/
rm lazygit.tar.gz lazygit
