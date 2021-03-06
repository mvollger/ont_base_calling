#!/usr/bin/env bash

#
# snakemake paramenters
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
snakefile=$DIR/snake.py
jobNum=20
waitTime=60 # this really needs to be 60 on our cluster :(

#echo $DIR
#exit

#
# QSUB parameters, these are only the defualts, they can be changed with params.sge_opts
# Allow snakemake to make directories, I think it slows things down when I done with "waitTime"
#
logDir=logs
mkdir -p $logDir
E=$logDir'/snakejob_{rule}_{wildcards}_e'
O=$logDir'/snakejob_{rule}_{wildcards}_o'
ram=4G
defaultCores=1

#
# run snakemake
#
snakemake -p \
	-s $snakefile \
	--drmaa " -P eichlerlab \
		-q eichler-short.q \
		-l h_rt=24:00:00  \
		-l mfree=$ram \
		-V -cwd -e $E -o $O \
		{params.cluster} \
		-S /bin/bash" \
	--jobs $jobNum \
	--latency-wait $waitTime


