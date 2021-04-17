cp sg.tf sg.bk
id=`aws ec2 describe-vpcs | grep test-app-vpc -B 22 | grep VpcId | sed 's/^[ \t]*"VpcId": "//' | sed 's/",//'`
sed -i -e s/vpc-id/$id/g sg.tf
cp alb.tf alb.bk
subpub1=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" | grep test-app-vpc-public-us-east-1a -B 20 | grep SubnetId | sed 's/^[ \t]*"SubnetId": "//g' | sed 's/",//g'`
subpub2=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" | grep test-app-vpc-public-us-east-1b -B 20 | grep SubnetId | sed 's/^[ \t]*"SubnetId": "//g' | sed 's/",//g'`
sed -i -e s/subpub1/$subpub1/g alb.tf
sed -i -e s/subpub2/$subpub2/g alb.tf
sed -i -e s/vpc-id/$id/g alb.tf
