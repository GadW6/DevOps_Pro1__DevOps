# alpine/ansible:latest

FROM alpine:latest

RUN apk update
RUN apk add python3 py3-pip
RUN apk add ansible ansible-lint openssh-client
RUN python3 -m pip install --upgrade --user ansible
