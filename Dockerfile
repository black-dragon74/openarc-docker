# CentOS Stream 8 base
FROM quay.io/centos/centos:stream8

# Install build dependencies
RUN dnf -y install epel-release
RUN dnf -y install openarc

# Set CWD
WORKDIR /app

# Expose OpenARC default port
EXPOSE 8894

# Copy launch script
COPY entrypoint.sh /app/docker-entrypoint.sh

# Start
ENTRYPOINT ["./docker-entrypoint.sh"]
