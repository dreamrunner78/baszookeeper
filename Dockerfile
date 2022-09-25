ARG java_image_tag=8-jre-slim
ARG spark_uid=1000

FROM openjdk:${java_image_tag}

LABEL maintener="bassim"
LABEL image="image to create zookeeper cluster"

USER root

# Prepare the image
RUN set -ex && \
    sed -i 's/http:\/\/deb.\(.*\)/https:\/\/deb.\1/g' /etc/apt/sources.list && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y bash tini libc6 libpam-modules krb5-user libnss3 netcat && \
    mkdir -p /opt/scripts && \
    echo 'zookeeper:x:1000:0:Zookeeper:/opt/zookeeper:/bin/false' >> /etc/passwd && \
    rm -rf /var/cache/apt/*

# Install java
COPY jdk-8u202-linux-x64.tar.gz /opt
RUN tar -xzf /opt/jdk-8u202-linux-x64.tar.gz -C /opt && \
    mv /opt/jdk1.8.0_202 /opt/java && \
    rm -rf /opt/jdk-8u202-linux-x64.tar.gz

# Install zookeeper
COPY apache-zookeeper-3.8.0-bin.tar /opt
RUN tar -xf /opt/apache-zookeeper-3.8.0-bin.tar -C /opt && \
    mv /opt/apache-zookeeper-3.8.0-bin /opt/zookeeper && \
    rm -rf /opt/apache-zookeeper-3.8.0-bin.tar && \
    mkdir -p /opt/zookeeper/logs && \
    mkdir -p /opt/zookeeper/data && \
    mkdir -p /opt/zookeeper/tmp && \
    mkdir -p /opt/zk/conf


# Install scripts
COPY entrypoint.sh /opt/scripts

# ACLs
RUN chown 1000:0 /opt/scripts/entrypoint.sh && \
    chmod +X /opt/scripts/entrypoint.sh && \
    chown 1000:0 /opt/zookeeper && \
    chown -R 1000:0 /opt/zookeeper && \
    chown 1000:0 /opt/java && \
    chown -R 1000:0 /opt/java && \
    chmod 777 /opt/zookeeper && \
    chmod -R 777 /opt/zookeeper && \
    chmod 777 /opt/java && \
    chmod -R 777 /opt/java && \
    chmod 777 /opt/scripts && \
    chmod -R 777 /opt/scripts

ENV JAVA_HOME=/opt/java
#ENV ZOOCFG=/opt/zookeeper/conf

USER 1000
ENTRYPOINT [ "/opt/scripts/entrypoint.sh" ]