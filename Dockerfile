FROM openjdk:8-alpine

LABEL Maintainer="andres@codehunters.io"
LABEL Description="Docker image for AWS Beanstalk deployment with Gradle and AWS S3" Vendor="Codehunters IO" Version="1.0"

ARG GRADLE_VERSION=6.2.2
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
ARG GRADLE_SHA=0f6ba231b986276d8221d7a870b4d98e0df76e6daf1f42e7c0baec5032fb7d17
ARG AWS_VERSION=1.18.26

RUN apk add --no-cache curl tar bash procps coreutils
RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
  && echo "Downlaoding gradle hash" \
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

ENV GRADLE_VERSION 6.0.1
ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

#CMD ["java", "gradle", "aws"]