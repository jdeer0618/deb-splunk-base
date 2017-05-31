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

# install the bits we need to get going.
RUN apt-get update && apt-get install -y locales libgssapi-krb5-2 wget sudo git vim \

# make the "en_US.UTF-8" locale so splunk will be utf-8 enabled by default, pdfgen dependency
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \

# Get image ready for next phase
    && wget -qO /tmp/${SPLUNK_FILENAME} https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME} \
    && wget -qO /tmp/${SPLUNK_FILENAME}.md5 https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME}.md5 \
    && (cd /tmp && md5sum -c ${SPLUNK_FILENAME}.md5) \
    && apt-get purge -y --auto-remove wget \
    && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.utf8
