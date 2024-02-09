# docker build --no-cache --progress=plain -f .gitpod.Dockerfile .
FROM gitpod/workspace-postgres

USER root
RUN bash -c "install-packages postgresql-client"
RUN bash -c "apt-get update"

USER gitpod
RUN bash -c "brew install hurl"
ARG JAVA_SDK="21.0.2-graalce"
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh \
    && sdk install java $JAVA_SDK \
    && sdk default java $JAVA_SDK \
    && sdk install maven \
    && sdk install quarkus"
