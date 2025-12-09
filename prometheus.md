STEP 1 — Install Prometheus & Grafana using Helm (recommended)

STEP 2 #Add Prometheus Community Helm Repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
STEP 3 #Install Kube-Prometheus-Stack (Prometheus + Grafana + Alerts)
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
STEP 4 — Get Grafana Login Credentials
kubectl get secret -n monitoring monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
STEP 5 — Expose Grafana (LoadBalancer Service)
kubectl edit svc monitoring-grafana -n monitoring
type: LoadBalancer
kubectl get svc -n monitoring
