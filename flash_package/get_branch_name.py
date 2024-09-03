#!/usr/bin/env python

# Copyright (c) 2023 The LineageOS Project
#
# SPDX-License-Identifier: BSD-2-Clause-Patent

import os
import sys
from xml.dom.minidom import parse

try:
    top_dir = os.environ['TOP']
except Exception as e:
    try:
        top_dir = os.environ['BUILD_TOP']
    except Exception as e:
        print("unknown")
        sys.exit()

manifest_file = top_dir + '/.repo/manifests/default.xml'
xml_tree = parse(manifest_file)
collection = xml_tree.documentElement
projects = collection.getElementsByTagName("default")
ver = projects[0].getAttribute("revision").split('-')[1].split('.')
print("%s.%s" % (ver[0].zfill(2), ver[1].zfill(2)))
