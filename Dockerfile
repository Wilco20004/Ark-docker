FROM centos:7

LABEL org.label-schema.maintainer="Willem Coetzee <r15ch13+git@gmail.com>" \
      org.label-schema.description="ARK Survival Evolved Server with cluster" \
      org.label-schema.url="https://github.com/Wilco20004/Ark-docker" \
      org.label-schema.vcs-url="https://github.com/Wilco20004/Ark-docker" \
      org.label-schema.schema-version="1.0.0"

# Expose environment variables
ENV CRON_AUTO_UPDATE="0 */3 * * *" \
    CRON_AUTO_BACKUP="0 */1 * * *" \
    UPDATEONSTART=1 \
    BACKUPONSTART=1 \
    BACKUPONSTOP=1 \
    WARNONSTOP=1 \
    USER_ID=1000 \
    GROUP_ID=1000 \
    TZ=UTC \
    MAX_BACKUP_SIZE=500 \
    SERVERMAP="TheIsland" \
    SESSION_NAME="ARK Docker" \
    MAX_PLAYERS=15 \
    RCON_ENABLE="True" \
    RCON_PORT=32330 \
    GAME_PORT=7778 \
    QUERY_PORT=27015 \
    RAW_SOCKETS="False" \
    SERVER_PASSWORD="" \
    ADMIN_PASSWORD="" \
    SPECTATOR_PASSWORD="" \
    MODS="" \
    CLUSTER_ID="keepmesecret" \
    KILL_PROCESS_TIMEOUT=300 \
    KILL_ALL_PROCESSES_TIMEOUT=300

    # Install dependencies and clean up
    RUN apt-get update \
        && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
        && apt-get install -y --no-install-recommends \
            bzip2 \
            curl \
            git \
            lib32gcc1 \
            libc6-i386 \
            lsof \
            perl-modules \
            tzdata \
            davfs2 \
            fuse \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

    # Create required directories
    RUN mkdir -p /ark \
        mkdir -p /ark/log \
        mkdir -p /ark/backup \
        mkdir -p /ark/staging \
        mkdir -p /ark/default \
        mkdir -p /cluster

    # Expose environment variables
    ENV USER_ID=1000 \
        GROUP_ID=1000 \
        KILL_PROCESS_TIMEOUT=300 \
        KILL_ALL_PROCESSES_TIMEOUT=300

    # Add steam user
    RUN addgroup --gid $GROUP_ID steam \
        && adduser --system --uid $USER_ID --gid $GROUP_ID --shell /bin/bash steam \
        && usermod -a -G docker_env steam

    # Install ark-server-tools
    RUN git clone --single-branch --depth 1 https://github.com/FezVrasta/ark-server-tools.git /home/steam/ark-server-tools \
        && cd /home/steam/ark-server-tools/tools/ \
        && ./install.sh steam --bindir=/usr/bin

    # Install steamdcmd
    RUN mkdir -p /home/steam/steamcmd \
        && cd /home/steam/steamcmd \
        && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

RUN mkdir -p /etc/service/arkcluster
COPY run.sh /etc/service/arkcluster/run
RUN chmod +x /etc/service/arkcluster/run

COPY crontab /home/steam/crontab

COPY arkmanager.cfg /etc/arkmanager/arkmanager.cfg
COPY arkmanager-user.cfg /home/steam/arkmanager-user.cfg

VOLUME /ark /cluster
WORKDIR /ark
