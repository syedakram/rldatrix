Setup NGINX Ingress Controller in multi-node Kubernetes cluster

 Go to master node or control plane node and execute following kubectl command


1. kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml

2. Run following kubectl command to verify the status of nginx-ingress controller pods

3. Test Ingress Controller
To test Ingress controller, we will create two applications based on httpd and nginx container and 
will expose these applications via their respective services and then will create ingress resource 
which will allow external users to access these applications using their respective urls.

##############################################################################################
Deploy httpd based deployment and its service with NodePort type listening on the port 80, 
Create the following yaml file which includes deployment and service section.
##############################################################################################

[root@k8s-master ~]# vi httpd-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      run: httpd-deployment
  template:
    metadata:
      labels:
        run: httpd-deployment
    spec:
      containers:
      - image: httpd
        name: httpd-webserver

---
apiVersion: v1
kind: Service
metadata:
  name: httpd-service
spec:
  type: NodePort
  selector:
    run: httpd-deployment
  ports:
    - port: 80
Save and close the file.

Run kubectl command to deploy above httpd based deployment and its service,

[root@linuxtechi ~]# kubectl create -f httpd-deployment.yaml
deployment.apps/httpd-deployment created
service/httpd-service created
[root@linuxtechi ~]#


#########################################################################################
Now run following kubectl command to deploy above nginx based deployment and its service,
#############################################################################################


1. root@k8s-master ~]# vi nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      run: nginx-deployment
  template:
    metadata:
      labels:
        run: nginx-deployment
    spec:
      containers:
      - image: nginx
        name: nginx-webserver

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    run: nginx-deployment
  ports:
    - port: 80
Save and exit the file

Now run following kubectl command to deploy above nginx based deployment and its service.

2. root@k8s-master ~# kubectl create -f nginx-deployment.yaml
deployment.apps/nginx-deployment created
service/nginx-service created


Run below command to verify the status of both deployments and their services

3. root@k8s-master ~# kubectl get deployments.apps httpd-deployment

##################################################################
Create and Deploy Ingress Resource
#######################################################################

1. root@k8s-master ~# vim myweb-ingress.yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: name-based-virtualhost-ingress
spec:
  rules:
  - host: httpd.example.com
    http:
      paths:
      - backend:
          serviceName: httpd-service
          servicePort: 80

  - host: nginx.example.com
    http:
      paths:
      - backend:
          serviceName: nginx-service
          servicePort: 80
save and close the file.


2. root@k8s-master ~# kubectl create -f myweb-ingress.yaml

3. Run following to verify the status of above created ingress resource

kubectl get ingress name-based-virtualhost-ingress
kubectl describe ingress name-based-virtualhost-ingress


Before accessing these urls from outside of the cluster 
please make sure to add the following entries in hosts file of your system from where you intended to access these.
192.168.1.190                httpd.example.com
192.168.1.190                nginx.example.com

Now try to access these URLs from web browser, type

http://httpd.example.com
http://nginx.example.com
