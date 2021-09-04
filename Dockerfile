FROM adoptopenjdk/openjdk11:jdk-11.0.12_7-alpine

LABEL Maintainer="andres@codehunters.io"
LABEL Description="Docker image for AWS Beanstalk deployment with Gradle" Vendor="Codehunters IO" Version="1.0"

ARG GRADLE_VERSION=7.2
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
ARG GRADLE_SHA=f581709a9c35e9cb92e16f585d2c4bc99b2b1a5f85d2badbd3dc6bff59e1e6dd
ARG AWS_VERSION=1.20.26

RUN apk add --update --no-cache curl tar bash procps coreutils build-base python3 py3-pip zip
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

# RUN curl -O https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py
RUN pip install --upgrade awscli==$AWS_VERSION
# RUN apk -v --purge del py-pip && rm /var/cache/apk/*

COPY awseb-entrypoint.sh /awseb-entrypoint.sh

RUN ln -fs /awseb-entrypoint.sh /usr/local/bin/awseb
RUN chmod +x /usr/local/bin/awseb

ENV GRADLE_VERSION ${GRADLE_VERSION}
ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

#CMD ["java", "gradle", "aws"]