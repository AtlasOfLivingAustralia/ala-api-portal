#!/usr/bin/env python

###
# convert the current branch to an environment, used to load the appropriate environment vars

import argparse
import re

parser = argparse.ArgumentParser()

parser.add_argument("--branch", "-b", help="The code branch that triggered this build", required=True)

args = parser.parse_args()

# associate the branch with an environmant 
if re.match('^production$', args.branch):
  #print(f"Branch {args.branch} matched production")
  print('production')
elif re.match('^staging$', args.branch):
  #print(f"Branch {args.branch} matched staging")
  print('staging')
elif re.match('^testing$', args.branch):
  #print(f"Branch {args.branch} matched testing")
  print('development')
else:
  #print(f"Branch {args.branch} didnt match")
  print('development')
   
