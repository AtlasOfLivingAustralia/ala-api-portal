#!/bin/bash
set -ueo pipefail

###
# Deploy the codepipeline for API documentation.
# You must have AWS CLI authentication for this to run. 

ENV="${1:-notprod}"

# get the branch
branch=$(git branch --show-current)
echo branch: $branch

# get the clean version of the branch
clean_branch=$(./clean_branch.sh $branch)
echo clean branch: $clean_branch

# get the commit_id
commit_id=$(git rev-parse HEAD)
echo commit_id: $commit_id

# get the environment based on the branch
environment=$(./branch_2_env.py --branch $branch --env $ENV)
echo environment: $environment

# load environment vars
./gen_env_vars.py --env $environment  --clean-branch $clean_branch --conf ../../congig.ini > env.txt
source env.txt
rm env.txt

# deploy/update the template
echo "Deploying the pipeline template"
aws cloudformation deploy \
    --template-file pipeline.yaml \
    --stack-name $PIPELINE_STACK_NAME \
    --tags product=$PRODUCT_NAME component=cicd environment=$environment branch=$branch version=$commit_id \
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

