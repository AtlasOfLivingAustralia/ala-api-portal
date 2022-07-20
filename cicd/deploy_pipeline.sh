#!/bin/bash
set -ueo pipefail

###
# deploy the codepipeline for API documentation

# get the environment
branch=$(git branch --show-current)
echo branch: $branch

environment=$(./branch_2_env.py --branch $branch)
echo environment: $environment

# generate environment vars
./gen_env_vars.py --env $environment > env.txt
source env.txt
rm env.txt

# deploy/update the template
echo "Deploying the output template"
aws cloudformation deploy \
    --template-file pipeline.yaml \
    --stack-name $PIPELINE_STACK_NAME \
    --tags $PIPELINE_AWS_TAGS environment=$environment branch=$branch \
    --region $REGION \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        pEnvironment=$environment \
        pCloudFormationServiceRole=$CLOUDFORMATION_SERVICE_ROLE \
        pAppStackName=$APP_STACK_NAME \
        pCodeBuildServiceRole=$CODEBUILD_SERVICE_ROLE \
        pCodePipelineServiceRole=$CODEPIPELINE_SERVICE_ROLE \
        pArtifactsBucket=$ARTIFACTS_BUCKET \
        pGitHubRepositoryName=$GITHUB_REPO_NAME \
        pGitHubOwner=$GITHUB_OWNER \
        pGitHubBranch=$branch \
        pCodestarConnection=$CODESTAR_CONNECTION

