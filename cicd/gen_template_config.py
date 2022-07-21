#!/usr/bin/env python

###
# genarate the template configuration, used to pass in the the parameters to the
# CloudFormation template and add aws resource tags

import argparse
import os
import jinja2

parser = argparse.ArgumentParser()

parser.add_argument("--template", "-t", help="The j2 template", required=True)

args = parser.parse_args()

# load the j2 template
template_loader = jinja2.FileSystemLoader(searchpath="./")
template_env = jinja2.Environment(loader=template_loader)
template = template_env.get_template(args.template)

# get the values from the environment
template_vals = {
    "environment"     : os.environ['ENVIRONMENT'],
    "bucket_name"     : os.environ['DOCUMENTATION_BUCKET'],
    "bucket_path"     : os.environ['BUCKET_PATH'],
    "hosted_zone"     : os.environ['HOSTED_ZONE'],
    "sub_domain"      : os.environ['SUB_DOMAIN'],
    "ssl_certificate" : os.environ['SSL_CERTIFICATE'],
    "branch"          : os.environ['SRC_BRANCH'],
    "commit_id"       : os.environ['COMMIT_ID'],
    "build"           : os.environ['CODEBUILD_BUILD_NUMBER']
}

# do the substitution
output_text = template.render(template_vals)

print(output_text)