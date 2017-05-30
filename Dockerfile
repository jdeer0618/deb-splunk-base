FROM debian:jessie

ENV SPLUNK_PRODUCT splunk
ENV SPLUNK_VERSION 6.6.1
ENV SPLUNK_BUILD aeae3fe0c5af
ENV SPLUNK_FILENAME splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-Linux-x86_64.tgz

ENV SPLUNK_HOME /opt/splunk
ENV SPLUNK_GROUP splunk
ENV SPLUNK_USER splunk
ENV SPLUNK_BACKUP_DEFAULT_ETC /var/opt/splunk
ARG DEBIAN_FRONTEND=noninteractive

# add splunk:splunk user
RUN groupadd -r ${SPLUNK_GROUP} \
    && useradd -r -m -g ${SPLUNK_GROUP} ${SPLUNK_USER}

# make the "en_US.UTF-8" locale so splunk will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# pdfgen dependency
RUN apt-get install -y libgssapi-krb5-2

# Get image ready for next phase
RUN apt-get install -y wget sudo git vim \
    && mkdir -p ${SPLUNK_HOME} \
    && wget -qO /tmp/${SPLUNK_FILENAME} https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME} \
    && wget -qO /tmp/${SPLUNK_FILENAME}.md5 https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME}.md5 \
    && (cd /tmp && md5sum -c ${SPLUNK_FILENAME}.md5) \
    && tar xzf /tmp/${SPLUNK_FILENAME} --strip 1 -C ${SPLUNK_HOME} \
    && rm /tmp/${SPLUNK_FILENAME} \
    && rm /tmp/${SPLUNK_FILENAME}.md5 \
    && chown -R ${SPLUNK_USER}:${SPLUNK_GROUP} ${SPLUNK_HOME} \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/splunk
