FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG ROOT

RUN apt update -qq && apt install --no-install-recommends -y \
    git curl make emacs wget libgtk2.0-dev openssh-server \
    python3 python3-dev python3-pip &&\
    rm -rf /var/cache/apt/*

# ssh
RUN mkdir /var/run/sshd && \
    mkdir /root/.ssh && \
    sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#Port 22/Port 22/' /etc/ssh/sshd_config && \
    sed -i 's/^#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config && \
    sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22

# git
WORKDIR /root
RUN curl -o .git-completion.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && \
    curl -o .git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# python
RUN pip3 install --upgrade pip

# update bashrc
COPY bashrc_additions /tmp/bashrc_additions
RUN cat /tmp/bashrc_additions >> /root/.bashrc && rm /tmp/bashrc_additions

WORKDIR $ROOT
RUN git config --global --add safe.directory $ROOT