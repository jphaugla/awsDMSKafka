aws dms create-replication-task --replication-task-identifier 'jph-create-s3' --source-endpoint-arn <source endpoint arn> --target-endpoint-arn <target endpoint arn> --replication-instance-arn <replication instance arn> --migration-type cdc --table-mappings file://table-mapping.json
