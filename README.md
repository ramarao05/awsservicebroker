### AWS Service Broker implementation in Openshift

### In AWS:: 

Create / Gather Following information

Create awssbuser user with admin priviliges along with programatic access

Go to Services->IAM->add user-> provide user name "awssbuser" , select programatic and console access boxes" and give your pwd for console access
Click Next
in Set Permissions select "AdministratorAccess" and Next-Next-> Review and Finish

login to AWS with above created user and capture the below details.

Your accountID, VPC,  Access Key and Secret Key

### Pre-req steps using cloud formation templates

use cloud formation to create stacks for Broker Database and Roles

1. upload "prerequisites.yaml" to create stack

   Provide stack name (aws-service-broker-prereq) and Follow Default settings and click next until finish
   
2. upload "aws-service-broker-worker.json" to create a stack

   Provide stack name (aws-service-broker-worker) and in ServiceBrokerAccountId provide your accountID (which you have capture in earlier step)
   

Ensure both stacks are successfull.


### In openshift::

use https://learn.openshift.com

use Openshift Playgrounds

choose v3.11

### In Playground

git clone https://github.com/ramarao05/awsservicebroker.git

cd awsservicebroker/implementation/

chmod 755 *

./deploy.sh


### check that the broker is running:

oc get pods | grep aws-servicebroker

### check servicebroker logs

oc logs $(oc get pods --no-headers -o name | grep aws-servicebroker)

####Verification####

oc login -u admin
and refer in Others section and you should see AWS resources



### Application Use case Testing 

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


### To Destroy and rework
### in AWS::

Remove the the Cloud Formation Stacks

Goto Cloud Formation -> stacks 

Select previouly given cloud formation stack i.e aws-service-broker-prereqand click delete 

Repeat same for aws-service-broker-role


### in Openshift w.r.t this scenario

Just close the existing playground and launch new openshift playground

