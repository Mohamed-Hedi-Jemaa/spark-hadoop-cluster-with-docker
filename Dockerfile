FROM ubuntu:16.04

MAINTAINER Mohamed Hedi Jemaa <jemaa117@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget vim

# Install Hadoop 2.7.2
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz && \
    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz

# install spark
RUN wget https://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz && \
    tar -xvf spark-2.2.0-bin-hadoop2.7.tgz && \
    mv spark-2.2.0-bin-hadoop2.7 /usr/local/spark && \
    rm spark-2.2.0-bin-hadoop2.7.tgz

# install kafka
RUN wget https://archive.apache.org/dist/kafka/1.0.2/kafka_2.11-1.0.2.tgz && \
    tar -xzvf kafka_2.11-1.0.2.tgz && \
    mv kafka_2.11-1.0.2 /usr/local/kafka && \
    rm kafka_2.11-1.0.2.tgz

# install hbase
RUN wget https://archive.apache.org/dist/hbase/1.4.9/hbase-1.4.9-bin.tar.gz  && \ 
    tar -zxvf hbase-1.4.9-bin.tar.gz && \
    mv hbase-1.4.9 /usr/local/hbase && \
    rm hbase-1.4.9-bin.tar.gz

RUN wget -O test-file-1.txt "https://drive.google.com/file/d/1yUugIIBkT609BzDbfVkl7riazaeNJMSR/view?usp=sharing" && \
    wget -O test-file-2.txt "https://drive.google.com/file/d/1boHydk834Ey2lSqwVyRESJfJeQZr4TAu/view?usp=sharing"

# set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV SPARK_HOME=/usr/local/spark
ENV KAFKA_HOME=/usr/local/kafka
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native:$LD_LIBRARY_PATH
ENV HBASE_HOME=/usr/local/hbase
ENV CLASSPATH=$CLASSPATH:/usr/local/hbase/lib/*
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/spark/bin:/usr/local/kafka/bin:/usr/local/hbase/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Create Hadoop directories
RUN mkdir -p /root/hdfs/namenode && \
    mkdir -p /root/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/ssh_config /root/.ssh/config
COPY config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY config/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY config/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY config/slaves $HADOOP_HOME/etc/hadoop/slaves
COPY config/start-kafka-zookeeper.sh /root/start-kafka-zookeeper.sh
COPY config/start-hadoop.sh /root/start-hadoop.sh
COPY config/run-wordcount.sh /root/run-wordcount.sh
COPY config/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
COPY config/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh
COPY config/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

# RUN chmod +x /root/start-kafka-zookeeper.sh \
#     && chmod +x /root/run-wordcount.sh \
#     && if [ -d "$HADOOP_HOME/sbin" ]; then chmod +x $HADOOP_HOME/sbin/*; fi \
#     && if [ -f /root/start-hadoop.sh ]; then chmod +x /root/start-hadoop.sh; fi \
#     && chown -R $USER:$USER /root/.ssh
RUN chmod +x /root/start-hadoop.sh \
    && chmod +x /root/start-kafka-zookeeper.sh \
    && chmod +x /root/run-wordcount.sh \
    && chown -R root:root /usr/local/hadoop

# Format namenode
RUN $HADOOP_HOME/bin/hadoop namenode -format

CMD ["sh", "-c", "service ssh start; bash"]
