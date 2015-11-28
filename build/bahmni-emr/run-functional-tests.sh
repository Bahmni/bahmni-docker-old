#!/bin/sh
yum localinstall /packages/*.rpm
cd emr-functional-tests
sh scripts/run.sh
