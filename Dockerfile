FROM ubuntu:focal 

RUN apt update && apt install -y curl file git unzip zsh

# Create a group and user
RUN useradd -rm -d /home/david -s /bin/zsh -g root -G sudo -u 1001 david

USER david

WORKDIR /home/david

COPY .zshrc .
COPY .p10k.zsh .

ENV TERM=xterm-256color
RUN zsh -i /home/david/.zshrc

ENTRYPOINT /bin/zsh
