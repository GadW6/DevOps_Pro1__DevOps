# alpine/ansible:latest
# alpine/ansible-semaphore:latest

# FROM alpine:latest
FROM semaphoreui/semaphore:latest

USER root

RUN apk update
RUN apk add python3 py3-pip git
RUN apk add ansible ansible-lint openssh-client
RUN python3 -m pip install --upgrade --user ansible
