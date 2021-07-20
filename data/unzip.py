#!/usr/bin/env python3

import zipfile
import argparse

parser = argparse.ArgumentParser("unzip")
parser.add_argument("infile", help="Zip file to be unzip.")
parser.add_argument("-t", "--target-dir", help="Target directory.", default='.')
args = parser.parse_args()

print('Extracting...')
with zipfile.ZipFile(args.infile, "r") as zip_ref:
    zip_ref.extractall(args.target_dir)
