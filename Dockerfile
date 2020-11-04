#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM ubuntu:16.04

# Install Nginx.
RUN \
  apt-get update && \
  apt-get install -y software-properties-common &&\
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx iperf3 net-tools iputils-ping iproute2 tcpdump netcat-traditional curl inotify-tools&& \
  rm -rf /var/lib/apt/lists/* && \
  #echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
#VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/ssl", "/etc/nginx/conf.d", "/var/log/nginx"]

# Define working directory.
WORKDIR /etc/nginx
RUN \
  cd /usr/share/nginx/html/ && \
  dd if=/dev/zero of=1GB.bin bs=1 count=0 seek=1G && \
  dd if=/dev/zero of=100MB.bin bs=1024 count=102400 && \
  dd if=/dev/zero of=10MB.bin bs=1024 count=10240 && \
  dd if=/dev/zero of=1MB.bin bs=1024 count=1024 && \
  dd if=/dev/zero of=test-1k.out bs=1024 count=1 && \
  dd if=/dev/zero of=test-2k.out bs=1024 count=2 && \
  dd if=/dev/zero of=test-4k.out bs=1024 count=4 && \
  dd if=/dev/zero of=test-8k.out bs=1024 count=8 && \
  dd if=/dev/zero of=test-16k.out bs=1024 count=16 


# Define default command.
#CMD ["nginx"]
ADD auto-reload-nginx.sh /home/
RUN chmod +x /home/auto-reload-nginx.sh
# Expose ports.
#EXPOSE 80
#EXPOSE 443
