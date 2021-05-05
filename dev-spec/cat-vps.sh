#!/bin/bash

### ----------------------------------------------------------------------------
### Environment Variables

### ----------------------------------------------------------------------------
###
echo "" >/dev/stderr
echo "Available SSH login keypairs: " >/dev/stderr
cat ~/.ssh/authorized_keys >/dev/stderr
echo "------------" >/dev/stderr
