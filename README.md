 #Nginx https service

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

$ kubectl create configmap nginxconfigmap --from-file=default.conf
configmap "nginxconfigmap" created
```
