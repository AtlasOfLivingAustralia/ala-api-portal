#!/usr/bin/env python

###
# Genarate the environment vars file for the current environment.
# Usage: gen_env_vars.py --env [development|testing|staging|production] --conf [/path/to/conf.ini]

import argparse
import configparser

parser = argparse.ArgumentParser()

parser.add_argument("--env", "-e", help="The environment we are running in", required=True)
parser.add_argument("--conf", "-c", help="Path to the config file. Default: config.ini", required=False, default="config.ini")

args = parser.parse_args()

# read the config file
config = configparser.ConfigParser(interpolation=configparser.ExtendedInterpolation())
config.read(args.conf)

# get values for the relevant environment
env_config = config[args.env]

# print key/vals
for key in env_config:
  print(f"{key.upper()}={env_config[key]}")

