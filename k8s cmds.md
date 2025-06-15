## How to know pod deployed on node
```sh
kubectl get pod  <podname> -n api -o jsonpath='{.spec.nodeName}'
```
```sh
kubectl get pod <podname> -n api -o wide
```
