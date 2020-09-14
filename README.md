<h1> awsservicebroker Implementation with Openshift v311 </h1>

In AWS::  Perform/Gather Following information
Create user with admin priviliges along with programatic access
login to AWS Console with above created user
Gather the below information for future steps in this Demo.
<h1> Your accountID, VPC,  Access Key and Secret Key </h1>
#Pre-req steps using cloud formation templates
Use cloud formation tempaltes to create stacks for Broker Database to maintain the AWS SB actions and Roles to allow you to create resources by any User

1. upload "prerequisites.yaml" to create stack
   Provide stack name and Follow Default settings and click next until finish
2. upload "aws-service-broker-worker.json" to create a stack
   Provide stack name and in ServiceBrokerAccountId provide your accountID (which you have capture in earlier step)

Ensure both stacks are successfull.

# Implementation in openshift
use https://learn.openshift.com
use Openshift Playgrounds
choose v3.11

# In The PlayGround Execute / follow below commands
oadm policy add-cluster-role-to-user cluster-admin admin
oc login localhost:8443
use these to login admin/admin
and refer if there are any AWS resources in AWS Console (Click on Dashboard).. <shoud be none>

mkdir awssb
cd awssb

### Fetch installation artifacts
wget https://raw.githubusercontent.com/ramarao05/awsservicebroker/master/implementation/deploy.sh

wget https://raw.githubusercontent.com/ramarao05/awsservicebroker/master/implementation/aws-servicebroker.yaml

wget https://raw.githubusercontent.com/ramarao05/awsservicebroker/master/implementation/parameters.env

chmod +x deploy.sh

### Edit parameters.env and update parameters as needed
vi parameters.env
update the below parameters and leave rest of them as it is:
TARGETACCOUNTID=
VPCID=

### If you are running on ec2 and have an IAM role setup with the required broker do not pass ACCESS_KEY_ID and SECRET_KEY
./deploy.sh <ACCESSKEY> <SECRETKEY>

### check that the broker is running:
oc get pods | grep aws-servicebroker

### check servicebroker logs
oc logs $(oc get pods --no-headers -o name | grep aws-servicebroker)

####Verification####

oc login -u admin
and refer in Others section and you should see AWS resources



++++++Application Use case Testing ++++++++++++++++++++++
As an Developer (developer/developer) User. 

login to Service Catalog

Select Amazon S3

Click Next

Choose Plan as Custom

Choose to create a New Project (you can maintain all your AWS resources)

Project Name "myawsresources"  --> anything you like

Give Project Display and Description details

Bucket Access level "PublicRead"  --> I wanted to read the content as part of test

Bucket Name should be uniq name , i choosed as "ramaraoawssbtesting"

I left all other default and click next

I will bind this resource later.

Click Next and you should see that S3 Bucket will be being created 

Goto Applications and Provisioned Services

At this point the Provision in Pending , wait for few min and see the status of events 

Amazon S3 Bucket is Ready to use.


