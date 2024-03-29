#!/bin/bash
if [[ -z "$BROKERID" ]]; then
    export BROKERID=-1
fi

if [[ -z "$KAFKA_PORT" ]]; then
    export KAFKA_PORT=9092
fi

if [[ -z "$ZKHOST" ]]; then
    export ZKHOST=zookeeper:2181
fi

if [[ -z "$ADVERTISED_HOST" ]]; then
    export ADVERTISED_HOST=kafka
fi

if [[ -z "$ADVERTISED_PORT" ]]; then
    export ADVERTISED_PORT=9092
fi

sed -i s/localhost:2181/$ZKHOST/g $KAFKA_HOME/config/server.properties
sed -i s/broker.id=0/broker.id=$BROKERID/g $KAFKA_HOME/config/server.properties
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
