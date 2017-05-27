FROM centos
MAINTAINER Abrar Hussain "abrarhussainturi@gmail.com"

USER root

RUN yum update -y
RUN yum install -y java-1.8.0-openjdk-headless.x86_64
RUN yum clean all
RUN curl -o kafka_2.11-0.10.2.1.tgz http://apache.mirrors.spacedump.net/kafka/0.10.2.1/kafka_2.11-0.10.2.1.tgz
RUN tar -xzf kafka_2.11-0.10.2.1.tgz
RUN rm kafka_2.11-0.10.2.1.tgz
EXPOSE 9092
ENV KAFKA_HOME /kafka_2.11-0.10.2.1
ENV PATH $PATH:$KAFKA_HOME/bin
WORKDIR /

ENV TERM xterm
COPY init-conf.sh /root/
CMD ["/root/init-conf.sh"]
