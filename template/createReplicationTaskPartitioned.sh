aws dms create-replication-task --replication-task-identifier 'partitioned-task' --source-endpoint-arn arn:aws:dms:us-east-1:569119288395:endpoint:WGUEUFLRDFSIFTF7EIOH6A3P5DCFQRJKWC7XY2A --target-endpoint-arn arn:aws:dms:us-east-1:569119288395:endpoint:S4APXVIZEQ6FSLFFERELOY2W7O4QZ37253ZERLY --replication-instance-arn arn:aws:dms:us-east-1:569119288395:rep:3IRETHZGHMVFFSQ7BFB4X575O6WDDHROJG7TNVY --migration-type full-load-and-cdc --table-mappings file://table-mapping-partitioned.json
