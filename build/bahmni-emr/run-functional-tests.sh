#!/bin/sh
yum localinstall -y /packages/*.rpm
cd emr-functional-tests
sh scripts/run.sh
