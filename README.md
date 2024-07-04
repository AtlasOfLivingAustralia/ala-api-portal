# Welcome to the ALA API gateway documentation portal
This is the documentation for our API Gateway. The repo contains the API documentation code as well as the infrastructure required to deploy and run it

## Development

### Slate

The Slate framework applies a prebuild template to markdown pages to generate clean and responsive API documentation. 
The entry point of [slate/source/localizable/index.html.md](slate/source/localizable/index.html.md)

See: [Slate documentation](slate/README.md)

#### Build

##### Natively

1. install ruby
   see: https://rvm.io & https://brew.sh
1. `cd slate`
1. `gem install bundler -v 2.4.22`
1. `bundle install`
1. `bundle exec middleman build`

##### Docker

1. `cd slate`
1. build the docker image `docker build . -t slatedocs/slate`
1. `cd ..`
1. use docker to build the site 
   ```
    docker run --rm --name slate \
        -v $(pwd)/build:/srv/build \
        -v $(pwd)/slate/source:/srv/slate/source \
        -v $(pwd)/slate/locales:/srv/slate/locales \
        -e ENVIRONMENT=${ENVIRONMENT} \
        slatedocs/slate build
   ```

The built site will be located in `./build/` directory. 

### Swagger

The swagger-ui contains modifications to the Swagger UI webapp to integrate with the Slate documentation update the styling to match.

#### Build

1. `cd swagger-ui`
1. `npm install`
1. `npm run build`

This will build the swagger UI into the `./build/openapi/`  

## CI/CD

### Environments
There are multiple environments. The environment of the code and infrastructure is determined by the branch it's running on

|git branch|environment |
|--|--|
|main|production|
|main|staging|
|testing|testing|
|feature* (e.g. feature/issue-121-new-logo) |development|

### Configuration
All configuration is handled in the `cicd/config.ini` file. The File format is of a standard ini file with different sections corresponding to the different environments. There is a [DEFAULT] section that includes values common to all environments such as the code repo details. Default values can be overridden in an environment section

 
### Development
There can be any number of development environments each with its own separate application and infrastructure settings and domain name. A separate development environment can be deployed for each feature branch. They can be quickly stood up and torn down as needed. Any work done on feature branches is automatically assigned to a development environment in the comparison AWS account
### Testing
The testing environment is where features and tasks can be integrated and tested. When work on a feature branch is finished it gets merged into the `testing` branch for integration testing. The `testing` branch is automatically assigned to the testing environment in the comparison AWS account 
### Staging
When features or changes have been finalised and approved in the testing environment they can be merged into the `main` branch. The `main` branch is automatically assigned to the staging environment in the production AWS account
### Production
The production environment. Code can only make it here after passing through all the previous environments. This way the exact same code and infrastructure has already been deployed and tested multiple times before it's pushed to production

### Git branching
The branching model for this project is very similar to [gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) 
Direct commits are only made to feature branches. PRs are created to move through all the other branches up to main which corresponds to production

### Development workflow
A typical workflow would be that there's a task to make a change to the existing application or setup. 

#### 1. Create a feature branch
Create a feature branch to make your changes. This would usually be based off the `main` branch which is production but could be from `testing` if the updates are being made against an unreleased change. On your new feature branch update the settings in `cicd/config.ini` in the development section to correspond to the changes you're making.

#### 2. Deploy the CodePipelines
Run your AWS CLI authentication then then deploy the pipelines using `pipeline/deploy_pipeline.sh` in each of he components. This will create code pipelines that point to your newly created feature branch.

#### 3. Code away!
Make your changes. Update the documentation code, infrastructure code and config as required. Changes will deploy automatically when you push your changes

#### 5. Cleanup
When you're finished work on your feature there is a manually approved cleanup stage in the pipeline that will remove all the infrastructure associated with your development branch. To run this Click the "Review" button in the Teardown stage of the pipeline and then "Approve"

### Deploy to testing
When development is finished. Submit a PR to merge your feature branch into the testing branch. After review do the merge.

#### 2. Deploy
Changes will automatically deploy to the testing environment. You can monitor the progress in the AWS console. When the deploy is finished your changes will be ready to review at the domain specified in the config.ini file against the testing environment.

### Deploy to staging
When testing is finished. Submit a PR to merge the testing branch into the main branch. After review do the merge.

#### 2. Deploy
Changes will automatically deploy to the staging environment. You can monitor the progress in the AWS console. When the deploy is finished your changes will be ready to review at the domain specified in the config.ini file against the testing environment.

### Deploy to production

##### 2. Deploy
In the AWS console navigate to CodePipeline and find the `api-docs-portal-production` pipeline and click "Release change". Follow the progress in the AWS console and look out for any errors. When the deploy is finished your changes will be ready to review at the domain specified in the config.ini file against the production environment.

## rollback
To rollback to any previous revision go to CodePipeline and after selecting "Release Change" choose the commit to release. [Detailed instructions here](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-trigger-source-overrides.html#pipelines-trigger-source-overrides-console)

If the rollback requires a pipeline change the pipeline will be automatically updated but it will not automatically run. You will need to select "Release Change" again and select the commit to release.
