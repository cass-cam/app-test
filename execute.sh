kubectl get all | grep grep my-service
if [ "$?" -eq "0" ]
then echo app is running
else ./kubectl create -f app.yaml 
fi
