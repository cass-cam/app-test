cp sg.tf sg.bk
id=`aws ec2 describe-vpcs | grep test-app-vpc -B 22 | grep VpcId | sed 's/^[ \t]*"VpcId": "//' | sed 's/",//'`
sed -i -e s/vpc-id/$id/g sg.tf
