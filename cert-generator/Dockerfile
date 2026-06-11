FROM ibmcom/mq

USER root
RUN microdnf install --nodocs java-1.8.0-openjdk-headless openssl make \
  && microdnf clean all

ENTRYPOINT []