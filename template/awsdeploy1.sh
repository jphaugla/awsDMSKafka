aws cloudformation deploy --template-file ./awsDMSKafka.yaml --stack-name ${PROJECT_NAME} --capabilities CAPABILITY_NAMED_IAM --parameter-overrides ProjectName=$PROJECT_NAME Key_Name=$KEY_NAME IPCidrToAllowTraffic=$CIDR
aws cloudformation describe-stacks --stack-name ${PROJECT_NAME} > stack.out
