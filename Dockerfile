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
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
#VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/ssl", "/etc/nginx/conf.d", "/var/log/nginx"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
#CMD ["nginx"]
ADD auto-reload-nginx.sh /home/
RUN chmod +x /home/auto-reload-nginx.sh
# Expose ports.
#EXPOSE 80
#EXPOSE 443
