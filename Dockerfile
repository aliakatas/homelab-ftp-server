# Use Alpine Linux for a smaller, more efficient base image
FROM alpine:latest

# Install required packages
RUN apk add --no-cache \
    vsftpd \
    shadow \
    bash \
    iproute2 \
    openssl \
    lftp \
    && rm -rf /var/cache/apk/*

ARG USER=odduser
ARG GROUP=${USER}
ARG PASS=oddpassword

ARG USER_ID=1000
ARG GROUP_ID=1000

# Create and configure the FTP user
RUN addgroup -g ${GROUP_ID} ${GROUP} && \
    adduser -D -u ${USER_ID} -G ${GROUP} ${USER} && \
    echo "${USER}:${PASS}" | chpasswd 
    
RUN mkdir -p /mnt/ftp && chmod 777 /mnt/ftp

# Define mount points for persistent storage
VOLUME /mnt/ftp
VOLUME /var/log/vsftpd

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd.chroot_list /etc/vsftpd/
COPY vsftpd.user_list /etc/vsftpd/
COPY run-vsftpd.sh /usr/sbin/
RUN chmod +x /usr/sbin/run-vsftpd.sh

# Expose FTP ports
EXPOSE 20 21 21000-21010

# Set default command to run the FTP server
CMD ["/usr/sbin/run-vsftpd.sh"]
