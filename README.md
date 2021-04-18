# **CI/CD EKS Jenkins Terraform**

En este deploy se va a realizar la creacion de una VPC (test-vpc) con sus respectivas subnets para la ejecucion de un cluster kubernetes bajo EKS de AWS, con despliegue a cargo de jenkins en el cual se creara un job el cual validara el repositorio cada minuto en busca de cambios en el codigo; en caso de encontrarlos se realizara un despliegue por pipeline al cluster EKS creado.

## **Prerequisitos para la ejecucion de los siguientes archivos**

Tener una cuenta de AWS y el usuario debe tener permisos para crear servicios de AWS. Para el despliegue de todo el terraform se asume que las llaves de acceso a la cuenta se encuentran configuradas en la ruta ~/.aws/credentials de la siguiente manera:

```
[default]
aws_access_key_id = XXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXX
```
### **NOTA: No modificar los archivos Jenkinsfile-original, kubernetes/eks.tf-original, jenkins-ec2/alb.tf-original, jenkins-ec2/ec2-ASG.tf-original, jenkins-ec2/sg.tf-original**

## **Creacion de VPC y EKS por terraform**

Con el siguiente codigo se creara una VPC con con 3 subnet privadas y 3 subnets publicas las cuales se usaran para el uso del cluster de kubernetes.

Para la ejecucion del archivo de terraform se deben realizar los siguientes pasos:

1. Clonar el repositorio https://github.com/cass-cam/app-test.git y ejecutar el script ./first.sh
2. ir a la carpeta terraform "cd terraform"
3. ejecutar terraform init
4. ejecutar terraform apply
5. todo se debe crear desde que el usuario tenga los permisos de administracion.

## **Creacion cluster EKS**

Con el siguiente codigo se creara el cluster EKS en AWS

ir a la raiz del repositorio y ejecutar los siguientes comandos:

1. ir a la carpeta kubernetes "cd kubernetes"
2. ejecutar el script execute.sh, tener en cuenta que este script lo que va a realizar es recolectar valores de la cuenta de AWS como el account id de AWS y va a
modificar el archivo eks.tf. Para poder realizar bien el llamado de las variables validar que si se tenga el profile de default seteado correctamente de la cuenta de AWS.
3. ejecutar terraform init
4. ejecutar terraform apply
5. ejecutar el comando "mv eks.bk eks.tf"

## **Despliegue de ASG para instancias con jenkins**

con el siguiente codigo se creara un ASG para la ejecucion del jenkins

ir a la raiz del repositorio y ejecutar los siguientes comandos:

1. ir a la carpeta jenkins-ec2 "cd jenkins-ec2"
2. ejecutar el script execute.sh
3. ejecutar terraform init
4. ejecutar terraform apply


## **Configuracion del jenkins**

Para la configuracion del job de jenkins realizar los siguientes pasos:

1. ir a la cuenta de AWS y al servicio de ec2
2. Esperar a que la instancia del ASG llamada ASG-app se encuentre en estado "Running"
3. seleccionar la instancia y dar clic en el boton "Connect"
4. seleccionar la pestaña "Session Manager" y darle clic al boton "Connect"
5. Esperar a que se realice la instalacion de los paquetes necesarios para el jenkins, para esto validar con el siguiente comando:
6. sudo service jenkins status
7. Esperar a que el servicio se encuentre en estado "Running"
8. ejecutar el comando sudo cat /var/lib/jenkins/secrets/initialAdminPassword y copiar el resultado (este es el password para acceder a Jenkins)
9. Ir a la cuenta de AWS y en el servicio de EC2 y a "Load Balancers"
10. seleccionar el balanceador con nombre "alb-app" y copiar el "DNS name" de este.
11. ir a un navegar y copiar el "DNS name" asi http://"DNS name":8080/login
12. Jenkins va a solicitar la contraseña que se tomo en el punto 8
13. seleccionar la instalacion de paquetes predefinidos el que se encuentra a la izquierda de la pantalla
14. esperar a que se termine la instalacion de paquetes; darle skip a la creacion de nuevo usuario y darle ok al uso del nombre del DNS entregado, darle ok y "Start using Jenkins" 
15. regresar a la terminal del SSM a la instancia donde se tiene configurado el jenkins
16. ejecutar el comando "sudo su -"
17. ejecutar el comando "vi /etc/passwd"
18. modificar la linea del usuario jenkins al final por /bin/bash
19. ejecutar el comando su - jenkins
20. crear la carpeta en la raiz del usuario .aws
21. crear el archivo credentials con la misma configuracion establecida en los prerequisitos de la instalacion.
22. volver a la interfaz de jenkins y crear un job con las siguientes especificaciones:
23. seleccionar "new item" ingresar un nombre al job que se va a crear y seleccionar el modo "pipeline" y dar clic en "ok"
24. en los "Build Triggers" seleccionar "Poll SCM" y agregar * * * * * o agregar el modo en que se quiera leer el repo para realizar el despliegue
25. en la seccion "Pipeline" en el "definition" seleccionar "Pipeline script from SCM"
26. en la seccion "SCM" seleccionar "Git"
27. agregar el repo https://github.com/cass-cam/app-test.git en el "Repository URL"
28. en el campo "Branch Specifier (blank for 'any')" poner */main
29. en el "Script Path" poner "Jenkinsfile" y darle ok a la creacion
30. ir nuevamente a donde se descargo el repo en la terminal y en la raiz de este ejecutar el comando "./execute2.sh" este paso solo se debe ejecutar una vez
31. ejecutarl el comando "./execute3.sh" este paso solo se debe ejecutar una vez
32. realizar un git commit -am "comentarios" y un git push para que el repo tome por primera vez la configuracion del jenkins.
31. ejecutar el job
