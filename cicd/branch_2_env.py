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
  #print(f"Branch {args.branch} matched main")
  print('production')
elif re.match('^staging$', args.branch):
  #print(f"Branch {args.branch} matched develop")
  print('staging')
elif re.match('^feature.*', args.branch):
  #print(f"Branch {args.branch} matched feature")
  print('testing')
else:
  #print(f"Branch {args.branch} didnt match")
  print('development')
   
