### Reverse proxy config
1. TCP proxy
   ```sh
   $cat tcp.stream
   upstream server_upstreams {
        server 166.9.24.8:8080;
    }
    server {
        listen 8080;
        proxy_pass server_upstreams;
    }
    ```

2. http/https proxy
TBD

 ### Nginx https service

This example creates a basic nginx https service useful in verifying proof of concept, keys, secrets, configmap, and end-to-end https service creation in kubernetes.
It uses an [nginx server block](http://wiki.nginx.org/ServerBlockExample) to serve the index page over both http and https. It will detect changes to nginx's configuration file, default.conf, mounted as a configmap volume and reload nginx automatically.

### Generate certificates

First generate a self signed rsa key and certificate that the server can use for TLS.

```sh
$ make keys KEY=/tmp/nginx.key CERT=/tmp/nginx.crt
```

### Create a https nginx application running in a kubernetes cluster

You need a [running kubernetes cluster](https://kubernetes.io/docs/setup/pick-right-solution/) for this to work.

Create a secret and a configmap.

```sh
$ kubectl create secret tls nginxsecret --key /tmp/nginx.key --cert /tmp/nginx.crt
secret "nginxsecret" created

$ kubectl create configmap nginxconfigmap1 --from-file=default.conf
configmap "nginxconfigmap1" created
$ kubectl create configmap nginxconfigmap2 --from-file=tcp.stream
configmap "nginxconfigmap2" created
```
Create a service and a deployment using the configuration in nginx-app.yaml.

```sh
$ kubectl create -f nginx-app.yaml
You have exposed your service on an external port on all nodes in your
cluster.  If you want to expose this service to the external internet, you may
need to set up firewall rules for the service port(s) (tcp:32211,tcp:30028) to serve traffic.
```
service "nginxsvc" created
deployment "nginx" created

### IKS Deploy Ingress Service
Create a Kubernetes ClusterIP service for your app so that it can be included in the Ingress application load balancing.
```
kubectl expose deploy <app_deployment_name> --name my-app-svc --port <app_port> -n <namespace>
```

Get the Ingress subdomain and secret for your cluster.
```
 ibmcloud ks cluster get -c <cluster_name_or_ID> | grep Ingress
```

Using the Ingress subdomain and secret, create an Ingress resource file. Replace <app_path> with the path that your app listens on. If your app does not listen on a specific path, define the root path as a slash (/) only.
```
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
 name: myingressresource
spec:
 tls:
 - hosts:
   - <ingress_subdomain>
   secretName: <ingress_secret>
 rules:
 - host: <ingress_subdomain>
   http:
     paths:
     - path: /<app_path>
       backend:
         serviceName: my-app-svc
         servicePort: 80
```

Create the Ingress resource.
```
kubectl apply -f myingressresource.yaml
```
In a web browser, enter the Ingress subdomain and the path for your app.
```
https://<ingress_subdomain>/<app_path>
```
