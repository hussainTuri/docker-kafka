# kafka-python

## 1. Using Docker Compose:
- Install docker-compose:
```bash
pip install docker-compose
```
### 2. Build the Container

```bash
git clone git://github.com/hussainTuri/docker-kafka
cd docker-kafka
docker build . -t turi/kafka_211
```
### 3. Build Zookeeper
If you haven't build zookeeper image already, please follow the following steps, 
```bash
git clone git://github.com/hussainTuri/docker-zookeeper
cd docker-zookeeper
docker build . -t turi/zookeeper
```
### 4. Build mysql
Build mysql image from mysql official

    git clone https://github.com/mysql/mysql-docker.git
    cd mysql-docker/5.7

Edit Dockerfile and add these lines:

    RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    RUN python get-pip.py
    RUN rm get-pip.py
    RUN pip install mysql-connector-python-rf
    RUN pip install kafka-python
    RUN yum install -y git
    # pull python code for running producer and consumer
    RUN git clone https://github.com/hussainTuri/kafka-python.git

build image

    docker build . -t turi/mysql

### 5. Build kafka
```bash
git clone https://github.com/hussainTuri/docker-kafka.git
cd docker-kafka
docker build . -t turi/kafka
```

### 6. Start containers
```bash
cd docker-kafka
docker-compose up -d
```
This will start a single instance of zookeeper, mysql server and kafka.

### 7. Allow access to mysql container from any host
Enter the mysql container. This container will serve as mysql server and producer

    docker exec -it <mysql_container> /bin/bash
      
Login to mysql
    
    mysql -uroot -proot
 
To run things smooth, let's create a new user and allow access from any host.
    
    CREATE USER 'test'@'%' IDENTIFIED BY 'test';
    GRANT ALL PRIVILEGES ON *.* TO  'test'@'%'  WITH GRANT OPTION;
    FLUSH PRIVILEGES;
    exit;

### 8. Start more kafka containers

    docker-compose scale kafka=3


### 9. Create Topic
```bash
    docker exec <kafka_container> /kafka_2.11-0.10.2.1/bin/kafka-topics.sh --create --zookeeper <zookeeper_ip>:2181 --replication-factor 1 --partitions 1 --topic customers
```

### 10. Consume messages
Start consuming messages from another client in another terminal

    docker exec <kafka_container> /kafka_2.11-0.10.2.1/bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic customers --from-beginning


### 11. Publish messages
[Python code](https://github.com/hussainTuri/kafka-python)
###### From standard input
    docker exec -it <mysql_container> /bin/bash
    cd /kafka-python/producer
     
    # Script will send each line you type as message to topic 'customers'. type exit after last line. 
    python producer.py -c 
    
###### From file
    #  
    python producer.py -f /kafka-python/resources/customers

###### From database (Mysql)
    # assuming you have created database, table and have some data in there. check out sql file in resources
    # This will write all the customer names to kafka 'customers' topic. 
    python producer.py -d
    
## Consumer
[Python code](https://github.com/hussainTuri/kafka-python)

###### To standard input
    docker exec -it <mysql_container> /bin/bash
    cd /kafka-python/consumer
     
    # Read new messages from Kafka and print them on screen
    python producer.py -c 
    
###### To file
    # Read new messages from Kafka and append that to file.
    python producer.py -f

###### To database (Mysql)
    # Read new messages from Kafka and dump them to db
    python producer.py -d       