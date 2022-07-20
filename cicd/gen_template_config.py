#!/usr/bin/env python

###
# genarate the template configuration

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

# get the values
template_vals = {
    "environment"     : os.environ['ENVIRONMENT'],
    "bucket_name"     : os.environ['DOCUMENTATION_BUCKET'],
    "bucket_path"     : os.environ['BUCKET_PATH'],
    "hosted_zone"     : os.environ['HOSTED_ZONE'],
    "sub_domain"      : os.environ['SUB_DOMAIN'],
    "ssl_certificate" : os.environ['SSL_CERTIFICATE'],
    "branch"          : os.environ['SRC_BRANCH']
}
# do the substitution
output_text = template.render(template_vals)

print(output_text)