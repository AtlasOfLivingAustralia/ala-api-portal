# Welcome to the ALA API gateway documentation portal
This is the documentation for our API Gateway. The repo contains the API documentation code as well as the infrastructure required to deploy and run it

## Environments
There are multiple environments. The environment of the code and infrastructure is determined by the branch it's running on

|git branch|environment |
|--|--|
|main|production|
|release* (e.g. release/2.03)|staging|
|testing|testing|
|feature* (e.g. feature/issue-121-new-logo) |development|

## Configuration
All configuration is handled in the `cicd/config.ini` file. The File format is of a standard ini file with different sections corresponding to the different environments. There is a [DEFAULT] section that includes values common to all environments such as the code repo details. Default values can be overridden in an environment section

 
### Development
There can be any number of development environments each with its own separate application and infrastructure settings and domain name. A separate development environment can be deployed for each task or feature. They can be quickly stood up and torn down as needed. Any work done on feature branches is automatically assigned to a development environment in the comparison AWS account
### Testing
The testing environment is where features and tasks can be integrated and tested. When work on a feature branch is finished it gets merged into the `testing` branch for integration testing. The `testing` branch is automatically assigned to the testing environment in the comparison AWS account 
### Staging
When features or changes have been finalised for a release a tagged release branch is created. Release branches are automatically assigned to the staging environment which sits in the production AWS account. Staging should always be the same as production so we only deploy here immediately before a production release. 
### Production
The production environment. Code can only make it here after passing through all the previous environments. This way the exact same code and infrastructure has already been deployed and tested multiple times before it's pushed to production

## Git branching
The branching model for this project is very similar to [gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) 
Direct commits are only made to feature branches. PRs are created to move through all the other branches up to main which corresponds to production

## Development workflow
A typical workflow would be that there's a task to make a change to the existing application or setup. 

#### 1. Create a feature branch
Create a feature branch to make your changes. This would usually be based off the `main` branch which is production but could be from `testing` or `release` if the updates are being made against an unreleased change. On your new feature branch update the settings in `cicd/config.ini` in the development section to correspond to the changes you're making.

#### 2. Deploy the CodePipeline
Run your AWS CLI authentication then then run the script `cicd/deploy_pipeline.sh` This will update the code pipeline so that it now points to your newly created feature branch. It also insures that all other CodePipeline settings match any changes you made in the `cicd/config.ini` file

#### 3. Code away!
Make your changes. Update the documentation code, infrastructure code and config as required

#### 4. Deploy to development
When you're ready to deploy commit and push your changes. Then in the AWS console navigate to CodePipeline and find the `api-docs-portal-development` pipeline and click "Release change" This will kick off a deployment. Follow the progress in the AWS console and look out for any errors. When the deploy is finished your changes will be ready to review at the domain specified in the config.ini file

#### 5. Cleanup ( optional )
When you're finished there is a manually approved cleanup stage in the pipeline that will remove all the infrastructure associated with your development branch. To run this Click the "Review" button in the Teardown stage of the pipeline and then "Approve"

### Deploy to testing
When development is finished update the `cicd/config.ini` so that any changes that need to be done in testing, staging or production environments have been made. Submit a PR to merge your feature branch into the testing branch. After review do the merge.

#### 1. Update the CodePipeline
Make sure you are on the testing branch. Run `cicd/deploy_pipeline.sh` to pick up any config changes and tag the pipeline with the current commit id.

#### 2. Deploy
In the AWS console navigate to CodePipeline and find the `api-docs-portal-testing` pipeline and click "Release change". Follow the progress in the AWS console and look out for any errors. When the deploy is finished your changes will be ready to review at the domain specified in the config.ini file against the testing environment.

### Deploy to staging
Create a tagged release branch from the testing branch. Push this back up to the origin.

#### 1. Update the CodePipeline
Make sure you are on the new release branch locally. Run `cicd/deploy_pipeline.sh` to pick up any config changes and tag the pipeline with the current commit id.

#### 2. Deploy
In the AWS console navigate to CodePipeline and find the `api-docs-portal-staging` pipeline and click "Release change". Follow the progress in the AWS console and look out for any errors. When the deploy is finished your changes will be ready to review at the domain specified in the config.ini file against the staging environment.

### Deploy to production
Submit a PR to merge the release branch into the main branch. After review do the merge.

#### 1. Update the CodePipeline
Make sure you are on the main branch. Run `cicd/deploy_pipeline.sh` to pick up any config changes and tag the pipeline with the current commit id.

#### 2. Deploy
In the AWS console navigate to CodePipeline and find the `api-docs-portal-production` pipeline and click "Release change". Follow the progress in the AWS console and look out for any errors. When the deploy is finished your changes will be ready to review at the domain specified in the config.ini file against the production environment.

## Rollback
To rollback to any previous revision go to CodePipeline and after slecting "Release Change" choose the commit to release. [Detailed instructions here](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-trigger-source-overrides.html#pipelines-trigger-source-overrides-console)
