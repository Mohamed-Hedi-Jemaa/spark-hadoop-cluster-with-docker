## Présentation

These containers were initially developed from https://github.com/kiwenlau/hadoop-cluster-docker

A cluster of three containers is created, with platforms installed:

  * [Apache Hadoop](http://hadoop.apache.org/) Version: 2.7.2
  * [Apache Spark](https://spark.apache.org/) Version: 2.2.1
  * [Apache Kafka](https://kafka.apache.org/) Version 2.11-1.0.2 
  * [Apache HBase](https://hbase.apache.org/) Version 1.4.8

# hadoop-cluster-with-docker

### 3 Nodes Hadoop Cluster

##### 1. pull docker image

```
sudo docker pull kiwenlau/hadoop:1.0
```

##### 2. clone github repository

```
git clone https://github.com/Mohamed-Hedi-Jemaa/hadoop-cluster-with-docker
```

##### 3. create hadoop network

```
sudo docker network create --driver=bridge hadoop
```

##### 4. start container

```
cd hadoop-cluster-docker
sudo ./start-container.sh
```

**output:**

```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```
- start 3 containers with 1 master and 2 slaves
- you will get into the /root directory of hadoop-master container

##### 5. start hadoop

```
./start-hadoop.sh
```

##### 6. run wordcount

```
./run-wordcount.sh
```

**output**

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```

### Arbitrary size Hadoop cluster

##### 1. pull docker images and clone github repository

do 1~3 like section A

##### 2. rebuild docker image

```
sudo ./resize-cluster.sh 5
```
- specify parameter > 1: 2, 3..
- this script just rebuild hadoop image with different **slaves** file, which pecifies the name of all slave nodes


##### 3. start container

```
sudo ./start-container.sh 5
```
- use the same parameter as the step 2

##### 4. run hadoop cluster 

do 5~6 like section A

