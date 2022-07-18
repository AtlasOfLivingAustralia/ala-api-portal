#!/usr/bin/env python

###
# genarate the environment vars file for the current environment

import argparse
import configparser

parser = argparse.ArgumentParser()

parser.add_argument("--env", "-e", help="The environment we are running in", required=True)
parser.add_argument("--conf", "-c", help="Path to the congig file. Default: config.ini", required=False, default="config.ini")

args = parser.parse_args()

config = configparser.ConfigParser(interpolation=configparser.ExtendedInterpolation())
config.read(args.conf)

env_config = config[args.env]

for key in env_config:
  print(f"{key}={env_config[key]}")

