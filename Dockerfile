FROM ubuntu:20.04
RUN apt update && apt upgrade -y
RUN apt install -y gcc wget gnupg curl \
    build-essential zlib1g-dev libgdbm-dev\
    libnss3-dev libreadline-dev libffi-dev \
    libssl-dev libsqlite3-dev libbz2-dev
    # libncurses5-dev libncursesw5-dev libreadline-gplv2-dev libc6-dev tk-dev
    # libncurses5-dev
# build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
RUN cd /root \
    && wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz \
    && tar -xf Python-3.8.10.tgz \
    && cd Python-3.8.10 \
    && ./configure --enable-optimizations \
    && make install \
    && cd ..
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
    && curl -O https://cdn.azul.com/zulu/bin/zulu-repo_1.0.0-3_all.deb \
    && apt install ./zulu-repo_1.0.0-3_all.deb \
    && apt update \
    && apt install -y zulu8-ca-jre
RUN echo "export JAVA_HOME=/usr/lib/jvm/zulu8-ca-arm64/jre/" >> ~/.profile \
    && echo "export SPARK_HOME=/opt/spark" >> ~/.profile \
    && echo "export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin" >> ~/.profile \
    && echo "export PYSPARK_PYTHON=/usr/bin/python3" >> ~/.profile \
    && . ~/.profile
RUN apt install -y scala
RUN wget https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz \
    && tar xvf spark-3.2.1-bin-hadoop3.2.tgz \
    && mv ./spark-3.2.1-bin-hadoop3.2 /opt/spark
EXPOSE 8080