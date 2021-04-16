id=`aws ec2 describe-vpcs | grep test-vpc -B 22 | grep VpcId | sed 's/^[ \t]*"VpcId": "//' | sed 's/",//'`
#aws ec2 create-security-group --region us-east-1 --group-name SG-jenkins-pv --description "Amazon EFS for EKS, SG for mount target" --vpc-id $id
sg=`aws ec2 describe-security-groups | grep SG-jenkins-pv -A 20 | grep GroupId | sed 's/^[ \t]*"GroupId": "//' | sed 's/",//'`
sga=`aws ec2 describe-security-groups | grep all_worker_management -A 25 | grep GroupId | sed 's/^[ \t]*"GroupId": "//g' | sed 's/",//g'`
sg1=`aws ec2 describe-security-groups | grep worker_group_mgmt_one -A 25 | grep GroupId | sed 's/^[ \t]*"GroupId": "//g' | sed 's/",//g'`
sg2=`aws ec2 describe-security-groups | grep worker_group_mgmt_two -A 25 | grep GroupId | sed 's/^[ \t]*"GroupId": "//g' | sed 's/",//g'`
a=`aws sts get-caller-identity --query Account --output text`
subpriv1=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" | grep test-vpc-private-us-east-1a -B 20 | grep SubnetId | sed 's/^[ \t]*"SubnetId": "//g' | sed 's/",//g'`
subpriv2=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" | grep test-vpc-private-us-east-1b -B 20 | grep SubnetId | sed 's/^[ \t]*"SubnetId": "//g' | sed 's/",//g'`
subpriv3=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" | grep test-vpc-private-us-east-1c -B 20 | grep SubnetId | sed 's/^[ \t]*"SubnetId": "//g' | sed 's/",//g'`
subpub1=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" | grep test-vpc-public-us-east-1a -B 20 | grep SubnetId | sed 's/^[ \t]*"SubnetId": "//g' | sed 's/",//g'`
subpub2=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" | grep test-vpc-public-us-east-1b -B 20 | grep SubnetId | sed 's/^[ \t]*"SubnetId": "//g' | sed 's/",//g'`
subpub3=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" | grep test-vpc-public-us-east-1c -B 20 | grep SubnetId | sed 's/^[ \t]*"SubnetId": "//g' | sed 's/",//g'`
cp eks.tf eks.bk
sed -i -e s/26457691095/$a/g eks.tf
sed -i -e s/vpc-08c89938b596b1fa1/$id/g eks.tf
sed -i -e s/sg-0bfa4b8e8b945a86/$sga/g eks.tf
sed -i -e s/sg-02224b17a5f84a6d/$sg1/g eks.tf
sed -i -e s/sg-0d081b77e564cf25/$sg2/g eks.tf
sed -i -e s/subnet-08a920fcbc2b575f/$subpriv1/g eks.tf
sed -i -e s/subnet-07ab4601e1df3df1/$subpub1/g eks.tf
sed -i -e s/subnet-0da4210f25b3a392/$subpriv2/g eks.tf
sed -i -e s/subnet-03ae36b967c40e42/$subpub2/g eks.tf
sed -i -e s/subnet-0a94224dfb7f1191/$subpriv3/g eks.tf
sed -i -e s/subnet-0c8455ee1ec35eac/$subpub3/g eks.tf
