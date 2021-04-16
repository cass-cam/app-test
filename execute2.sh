a=`aws sts get-caller-identity --query Account --output text`
cp Jenkinsfile Jenkinsfile.bk
sed -i -e s/accountid/$a/g Jenkinsfile
