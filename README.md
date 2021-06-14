# Gradle deploy to AWS Beanstalk
Docker image for AWS Beanstalk deployment with gradle

## Getting Started
These instructions will cover usage information and for the docker container

### Usage
This is a basic example for deploy jar application into AWS Elastic Beanstalk:

```bash
export AWSEB_RELEASE_VERSION="my-app-1.0.0-RELEASE.jar"
export LOCALDIR_RELEASE_VERSION="./build/libs/my-app-1.0.0-RELEASE.jar"

awseb
```

#### Environment Variables
To deploy  the artifact the following variables are needed:

```bash
 AWSEB_APP_NAME: - AWS Elastickbeastalk application name
 AWSEB_ENV_NAME: - AWS Elastickbeastalk environment name
 AWSEB_S3_BUCKET: -- AWS S3 Bucket Name
 AWSEB_S3_KEY: -- AWS S3 Bucket Key
 AWSEB_RELEASE_VERSION: Name for release version file upload to AWS S3
 LOCALDIR_RELEASE_VERSION: -- Location for release version file
```

## Find Us
https://codehunters.io

## Contributing
Please read [CONTRIBUTING.md](https://github.com/andresmontoyat/docker-gradle-aws-eb/blob/develop/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors
    * Andrés Montoya - (https://andres.codehunters.io)

## License
This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/andresmontoyat/docker-gradle-aws-eb/blob/develop/README.md) file for details