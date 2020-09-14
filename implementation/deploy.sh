#!/bin/bash
oadm policy add-cluster-role-to-user cluster-admin admin
echo "User and password use as : admin/admin"
oc login localhost:8443
#wget https://raw.githubusercontent.com/ramarao05/awsservicebroker/master/implementation/deploy.sh

#wget https://raw.githubusercontent.com/ramarao05/awsservicebroker/master/implementation/aws-servicebroker.yaml

#wget https://raw.githubusercontent.com/ramarao05/awsservicebroker/master/implementation/parameters.env

chmod 755 *.sh


echo " Enter ACCESSKEYID:"
read AWSID
echo " Enter SECRETKEY:"
read AWSSECID
echo " Enter AccountID:"
read ACCID
echo " Enter VPC ID:"
read vpcname
sed -i "s/DUMMYACC/${ACCID}/g" ./parameters.env
sed -i "s/DUMMYVPC/${vpcname}/g" ./parameters.env

ACCESSKEYID=$(echo -n ${AWSID} | base64)
SECRETKEY=$(echo -n ${AWSSECID} | base64)

# On OpenShift 4.2 the project name has changed to "openshift-service-catalog-apiserver-operator"
oc projects -q | grep -q "^kube-service-catalog$" && proj=kube-service-catalog
oc projects -q | grep -q "^openshift-service-catalog-apiserver-operator$" && proj=openshift-service-catalog-apiserver-operator
[ ! "$proj" ] && echo "Error: Cannot find project" && exit 1

# Fetch the cert 
CA=`oc get secret -n $proj -o go-template='{{ range .items }}{{ if eq .type "kubernetes.io/service-account-token" }}{{ index .data "service-ca.crt" }}{{end}}{{"\n"}}{{end}}' | grep -v '^$' | tail -n 1`

# Create the project and the AWS Service Broker
oc new-project aws-sb 
oc process -f aws-servicebroker.yaml --param-file=parameters.env \
	--param BROKER_CA_CERT=$CA \
	--param ACCESSKEYID=${ACCESSKEYID} \
	--param SECRETKEY=${SECRETKEY} | oc apply -f - -n aws-sb

