FROM jenkinsci/slave:alpine
MAINTAINER iiwoai
USER root

## 设置国内源加速
RUN echo $'https://mirrors.aliyun.com/alpine/latest-stable/main\n\
https://mirrors.aliyun.com/alpine/latest-stable/community\n'\
> /etc/apk/repositories

COPY pip-install.py /tmp/pip-install.py
RUN apk add --update --no-cache docker curl python php7 php7-curl\
  && mkdir /root/.kube \
  && python /tmp/pip-install.py \ 
  && pip install jinja2 \
  && rm -rf /tmp/pear ~/.pearrc \ 
  && rm -rf /tmp/pip-install.py

COPY config /root/.kube/config
COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod 755 /usr/local/bin/jenkins-slave



VOLUME /var/run/docker.sock


ENTRYPOINT ["jenkins-slave"]
