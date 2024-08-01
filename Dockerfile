# Base Image: We'll leverage the official Jenkins inbound agent image.
FROM jenkins/inbound-agent:latest

# Essential Metadata: Define maintainer information.
LABEL maintainer="Yossi Yosefi <yyosefi@gmail.com>"

# User Configuration: Set up a user for running commands within the container.
USER root

# install unzip and wget
RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        unzip \
        wget

# Maven Installation: Download, extract, and configure Maven.
RUN apt-get update && \
    apt-get install -y wget && \
    mkdir -p /opt/maven && \
    wget -qO- https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz | tar xvz -C /opt/maven --strip-components=1 && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn && \
    apt-get clean

# Chrome Installation
RUN set -o errexit -o nounset \
    && echo "Downloading Chrome" \
    && apt update \
    && wget http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_127.0.6533.88-1_amd64.deb \
    && chmod 777 google-chrome-stable_127.0.6533.88-1_amd64.deb \
    && apt-get install -y ./google-chrome-stable_127.0.6533.88-1_amd64.deb \
    && rm -rf google-chrome-stable_127.0.6533.88-1_amd64.deb

# ChromeDriver Installation
RUN echo "Downloading ChromeDriver" \
    && wget https://storage.googleapis.com/chrome-for-testing-public/127.0.6533.88/linux64/chromedriver-linux64.zip \
    && unzip chromedriver-linux64.zip  \
    && chmod +x ./chromedriver-linux64/chromedriver  \
    && mv ./chromedriver-linux64/chromedriver /usr/bin \
    && rm -rf chromedriver-linux64.zip

# User Switch: Change back to the jenkins user for security.
USER jenkins
