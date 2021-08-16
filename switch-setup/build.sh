#!/bin/bash

CWD=`pwd`

xcc -target=XCORE-200-EXPLORER -g $CWD/main.c
