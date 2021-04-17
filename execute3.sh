sgeks1=`aws ec2 describe-security-groups --region us-east-1 | grep eks-cluster-sg-test-app -A 20 | grep GroupId | sed 's/^[ \t]*"GroupId": "//' | sed 's/",//' |  sed '$d'`
sgasg=`aws ec2 describe-security-groups --region us-east-1 | grep SG_app -A 20 | grep GroupId | sed 's/^[ \t]*"GroupId": "//' | sed 's/",//'`
aws ec2 authorize-security-group-ingress --group-id $sgeks1 --protocol all --port -1 --source-group $sgasg
