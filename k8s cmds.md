##How to know pod deployed on node
```sh
kubectl get pod  <podname> -n api -o jsonpath='{.spec.nodeName}'
```
```sh
kubectl get pod <podname> -n api -o wide
```
##To describe node
```sh
kubectl describe node <NODE_NAME>
```
##To enter into pod
```sh
kubectl exec -it  orchestrator-6dffd6f64b-8d89f -n api -- /bin/sh
```
To check nodeport servcie is access or not
To enter into shell
```sh
 kubectl run tmp-shell --rm -i -t --image=busybox --restart=Never -- sh
```

 inside shell check this 
 ```sh
wget -qO- http://10.122.6.25:80/curo/ping
```
<nodeport ip>
