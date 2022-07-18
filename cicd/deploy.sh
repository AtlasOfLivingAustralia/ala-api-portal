#!/bin/bash
set -ux

# 1) CONFIG
# read the configuration file to load variables into this shell script
source config

# 2) Creating the package with artifacts uploaded to the s3 bucket
echo "Creating the package"
aws cloudformation package --template-file template.yaml \
        --s3-bucket $ARTIFACTS_BUCKET \
        --output-template-file infra-packaged.template

# 3) Validate the template
echo "Validating the output template"
aws cloudformation validate-template \
  --template-body file://infra-packaged.template

# 3) Deploying the template
echo "Deploying the output template"
aws cloudformation deploy \
    --template-file infra-packaged.template \
    --stack-name $STACK_NAME \
    --region $REGION \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        pArtifactsBucket=$ARTIFACTS_BUCKET \
        pDomainName=$API_DOMAIN_NAME \
        pCreateWAFAcl=$CREATE_WEB_ACL \
        pRequireAPIKey=$REQUIRE_API_KEY \
        pUpdateTime=$(date +%s) \
         
echo "Updated/Created stack $STACK_NAME successfully"

# 4) Creating userdetails dashboard
echo "Checking if the dashboard stack exists ..."

if ! aws cloudformation describe-stacks --stack-name $DASHBOARD_STACK_NAME ; then

        # 2) Creating userdetails dashboard
        aws cloudformation create-stack \
                --stack-name $DASHBOARD_STACK_NAME \
                --region $REGION \
                --template-body file://dashboard.yaml \
                --capabilities CAPABILITY_IAM \

else
        echo -e "\nStack exists, attempting update ..."
        #Update stack
        aws cloudformation update-stack \
                --stack-name $DASHBOARD_STACK_NAME \
                --region $REGION \
                --template-body file://dashboard.yaml \
                --capabilities CAPABILITY_IAM \

fi