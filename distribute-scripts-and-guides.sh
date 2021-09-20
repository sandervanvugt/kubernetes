#!/bin/bash
# script for internal use by SvV to distribute changes from master kubernetes
# git repo to all git repos that need the same stuff
# to be executed from the "kubernetes" directory

FILES="SetupGuide.pdf SetupGuideAiO.pdf minikube-docker-setup.sh setup-container.sh setup-kubetools-ubuntu.sh"
REPOS="cka ckad devopsinfourweeks kub4h microservices"
REMOVEME=

for i in $REPOS
do
	for j in $FILES
	do
		ln $j ../$i/
	done
done

for k in $REPOS
do
	cd ../$k
	git add *
	git commit -m "automated update  of scripts and docs"
	git push
done

