aws dms create-endpoint --endpoint-identifier 'partition-end' --endpoint-type 'target' --engine-name 'kafka'  --kafka-settings file://kafka-partitioned-settings.json
