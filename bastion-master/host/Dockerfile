FROM 904556211056.dkr.ecr.us-west-2.amazonaws.com/python-3.7.3:master-79229438

RUN apk add --update --no-cache \
    acl \
    groff \
    jq \
    less \
    mysql-client \
    openssh \
    supervisor \
    util-linux \
    && pip3 install awscli==1.16.198 --upgrade \
    && ssh-keygen -A \
    && mkfifo "/tmp/stdout" \
    && chmod 777 "/tmp/stdout"

COPY bootstrap.sh /home/tripit
COPY motd_generator.sh /etc/periodic/15min/motd
COPY profile /etc/profile
COPY shell /usr/bin/bastion/
COPY sshd_config /etc/ssh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY users.txt /etc/users.txt

WORKDIR /home/tripit
EXPOSE 22

CMD ["./bootstrap.sh"]
