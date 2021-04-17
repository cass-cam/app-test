sgeks1=`aws ec2 describe-security-groups --region us-east-1 | grep eks-cluster-sg-test-app -A 20 | grep GroupId | sed 's/^[ \t]*"GroupId": "//' | sed 's/",//' |  sed '$d'`
sgeks2=`aws ec2 describe-security-groups --region us-east-1 | grep test-app-eks_cluster_sg -A 25 | grep GroupId | sed 's/^[ \t]*"GroupId": "//' | sed 's/",//'`
sgasg=`aws ec2 describe-security-groups --region us-east-1 | grep SG_app -A 20 | grep GroupId | sed 's/^[ \t]*"GroupId": "//' | sed 's/",//'`
aws ec2 authorize-security-group-ingress --group-id $sgeks1 --protocol all --port -1 --source-group $sgasg
