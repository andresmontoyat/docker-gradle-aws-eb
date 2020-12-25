FROM openjdk:8-alpine

LABEL Maintainer="andres@codehunters.io"
LABEL Description="Docker image for AWS Beanstalk deployment with Gradle and AWS S3" Vendor="Codehunters IO" Version="1.0"

ARG GRADLE_VERSION=6.7.1
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
ARG GRADLE_SHA=7873ed5287f47ca03549ab8dcb6dc877ac7f0e3d7b1eb12685161d10080910ac
ARG AWS_VERSION=1.18.26

RUN apk add --no-cache curl tar bash procps coreutils
RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
  && echo "Downlaoding gradle zip" \
  && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
  \
  && echo "Checking download hash" \
  && echo "${GRADLE_SHA}  /tmp/gradle.zip" | sha256sum -c - \
  \
  && echo "Unziping gradle" \
  && unzip -d /usr/share/gradle /tmp/gradle.zip \
   \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/gradle.zip \
  && ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/bin/gradle

RUN apk -v --update add \
        python \
        py-pip 
RUN pip install --upgrade awscli==$AWS_VERSION python-magic
RUN apk -v --purge del py-pip && rm /var/cache/apk/*

COPY awseb-entrypoint.sh /awseb-entrypoint.sh

RUN ln -fs /awseb-entrypoint.sh /usr/local/bin/awseb
RUN chmod +x /usr/local/bin/awseb

ENV GRADLE_VERSION 6.6
ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

#CMD ["java", "gradle", "aws"]