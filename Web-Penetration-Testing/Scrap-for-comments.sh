#!/bin/bash
curl -s $1 | grep -o '<!--.*-->'