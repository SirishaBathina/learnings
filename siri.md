```sh
What is Terraform?
```
Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp. It allows us to define and manage infrastructure using configuration files.

For example, instead of manually creating an EC2 instance from the AWS console, we can define it in Terraform:

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}

Terraform then communicates with AWS through the AWS provider.

```sh
2. What is Infrastructure as Code?
```
IaC means managing infrastructure through code instead of manually using cloud consoles.

For example, we can define:

VPC
Subnets
EC2
Load Balancer
RDS
Security Groups

Main benefits:

Version control
Repeatability
Automation
Consistency
Easy disaster recovery
Code review through Git

Interview answer:

"Infrastructure as Code means defining infrastructure in configuration files so that it can be created and managed automatically and consistently."
```sh
3. What is a Terraform Provider?
```
A provider is a plugin that allows Terraform to communicate with an external platform or API.

Examples:

AWS provider → AWS
Azure provider → Azure
Google provider → GCP
Kubernetes provider → Kubernetes
GitHub provider → GitHub

Example:

provider "aws" {
  region = "ap-south-1"
}

Flow:

Terraform → Provider → Cloud/API
```sh
4. What is a Terraform Resource?
```
A resource represents an infrastructure object managed by Terraform.

Examples:

EC2 instance
S3 bucket
VPC
Security group
RDS database

Example:

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}

Here:

aws_instance = resource type
web = resource name

```sh
5. What is Terraform State?
```
Terraform state keeps track of the resources Terraform manages and their current known attributes.

By default, Terraform stores state in:

terraform.tfstate

Terraform uses state to compare:

Terraform configuration
        ↓
      State
        ↓
Actual infrastructure

State can contain sensitive information, so in production we normally use a remote backend with access control and encryption.

```sh
6. Difference between terraform plan and terraform apply
```
terraform plan

Shows what Terraform would change.

terraform plan

Example:

+ create
~ update
- destroy

terraform apply

Actually performs the changes.

terraform apply

Interview answer:

"terraform plan is a preview, while terraform apply executes the proposed infrastructure changes."

``` sh
7. What does terraform init do?
```
terraform init initializes the Terraform working directory.

It can:

Download providers
Initialize the backend
Download modules
Prepare the .terraform directory

Example:

terraform init

Usually, this is the first Terraform command we run after cloning a project.

```sh
8. What does terraform destroy do?
```
It removes infrastructure managed by Terraform.

terraform destroy

Terraform creates a destruction plan and normally asks for confirmation.

Production caution: Never blindly run terraform destroy against production.


```sh 
9. What are Terraform Variables?
```
Variables make Terraform configurations reusable and configurable.

Instead of hardcoding:

instance_type = "t3.micro"

we can use:

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

Then:

instance_type = var.instance_type

This allows different environments to use different values.

For example:

dev  → t3.micro
qa   → t3.medium
prod → m5.large

```sh
10. What are Terraform Outputs?
```

Outputs expose useful information after Terraform creates resources.

Example:

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

After terraform apply:

instance_public_ip = "13.x.x.x"

Common outputs:

EC2 public IP
Load Balancer DNS
VPC ID
Subnet ID
Database endpoint


```sh
11. What is a Terraform Module?
```
A module is a reusable collection of Terraform configuration files.

Example:

modules/
└── ec2/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf

Then we can call it:

module "web_server" {
  source = "./modules/ec2"
}

Why modules?

Instead of writing the same EC2/VPC configuration repeatedly, we create it once and reuse it.


```sh
12. What is a Terraform Backend?
```
A backend determines where Terraform stores its state.

Local:

terraform.tfstate

Remote example:

terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
  }
}

For team environments, remote state is preferred because multiple engineers and CI/CD pipelines need to work with the same state.


```sh 
13. What is State Locking?
```
State locking prevents multiple Terraform operations from modifying the same state simultaneously.

For example:

Engineer A → terraform apply → State LOCKED
Engineer B → terraform apply → WAIT

This prevents concurrent modifications and helps avoid state corruption.

 ```sh
14. Difference between count and for_each
```

Both can create multiple resources.

count

Good when resources are almost identical.

resource "aws_instance" "web" {
  count = 3


  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}

Resources are indexed:

aws_instance.web[0]
aws_instance.web[1]
aws_instance.web[2]
for_each

Better when resources have meaningful unique keys.

resource "aws_s3_bucket" "buckets" {
  for_each = toset(["dev", "test", "prod"])


  bucket = "my-app-${each.key}"
}

You can access:

each.key
each.value

Easy interview line:

"count is index-based, while for_each is key-based."
``` sh 
15. What are Terraform Data Sources?
```
A data source allows Terraform to read existing information without creating that resource.

Example:

data "aws_vpc" "existing" {
  default = true
}

Terraform can then use information about that existing VPC.

Easy difference:

resource → create/manage
data     → read existing


```sh
16. What is Terraform Import?
```
terraform import brings an existing infrastructure resource into Terraform state.

For example, suppose an EC2 instance was manually created in AWS:

AWS Console
     ↓
Existing EC2

We can import it:

terraform import aws_instance.web i-0123456789abcdef0

Important interview point:

Import adds the resource to Terraform state; it does not automatically generate the complete Terraform configuration for that resource.

After import, we should create/update the Terraform configuration so it matches the actual resource.
```sh
17. What happens if someone manually changes infrastructure?
```
This is called configuration drift.

Suppose Terraform configuration says:

instance_type = t3.micro

But someone manually changes AWS to:

instance_type = t3.large

Running:

terraform plan

can detect the difference and propose changing it back to the desired configuration.

Desired: t3.micro
Actual:  t3.large
              ↓
terraform plan
              ↓
Change back to t3.micro

```sh
18. What is the Terraform lifecycle block?
```
The lifecycle block controls how Terraform handles resource changes.

Important options:

prevent_destroy

Protects a resource from accidental deletion.

lifecycle {
  prevent_destroy = true
}
create_before_destroy

Creates the replacement before destroying the old resource.

lifecycle {
  create_before_destroy = true
}
ignore_changes

Tells Terraform to ignore changes to selected attributes.

lifecycle {
  ignore_changes = [
    tags
  ]
}

```sh 
19. How do you manage multiple environments?
```

Common environments:

dev
qa
uat
prod

A common approach is:

terraform/
├── modules/
│   ├── vpc/
│   └── ec2/
│
└── environments/
    ├── dev/
    ├── qa/
    └── prod/

Each environment can have:

Different variables
Different state
Different infrastructure sizes
Different configurations

For example:

dev  → t3.micro
qa   → t3.medium
prod → larger instance

The important point is to keep production state isolated from non-production state.

```sh 
20. Explain the Terraform workflow
```

A typical workflow is:

Write Terraform code
        ↓
terraform fmt
        ↓
terraform init
        ↓
terraform validate
        ↓
terraform plan
        ↓
Review
        ↓
terraform apply

In a real DevOps environment:

Developer
   ↓
Git push
   ↓
Pull Request
   ↓
CI Pipeline
   ↓
terraform fmt / validate
   ↓
terraform plan
   ↓
Code Review / Approval
   ↓
terraform apply
   ↓
Cloud Infrastructure

```sh
###Two developers run terraform apply at the same time. What happens?
```
If both developers are using the same remote Terraform state and the backend supports state locking, Terraform locks the state when the first apply starts.

For example:

Developer A
    |
terraform apply
    |
State LOCKED
    |
Infrastructure changes
    |
State UNLOCKED


Developer B
    |
terraform apply
    |
Waits / receives lock error

Developer B cannot modify the same state simultaneously.

Interview answer

"If two developers run Terraform apply at the same time against the same remote state, state locking prevents concurrent modifications. The first operation acquires the lock, and the second operation waits or fails depending on the backend and lock configuration. This prevents state corruption and conflicting changes."

Important point

State locking is especially important when Terraform is used by a team or CI/CD pipeline.
```sh
##2. Someone manually deletes an EC2 instance managed by Terraform. What happens?
```
Suppose Terraform manages:

aws_instance.web

But someone manually deletes the EC2 instance from AWS.

Now Terraform state may still contain information about that instance, while the actual infrastructure no longer exists.

The next:

terraform plan

refreshes/checks the infrastructure and detects that the resource is missing.

Terraform will normally show something like:

-/+ or + create

More simply:

Terraform state → EC2 exists
AWS actual      → EC2 does NOT exist
                         ↓
                  terraform plan
                         ↓
                  EC2 needs creation

Then:

terraform apply

will recreate the EC2 instance according to the Terraform configuration.

Interview answer

"If someone manually deletes an EC2 instance managed by Terraform, Terraform detects the difference between the state/configuration and the actual infrastructure during refresh and plan. The plan will normally show that the EC2 needs to be created again. When we run apply, Terraform recreates it according to the configuration."

Extra point

This is an example of configuration drift.
```sh
##3. Your Terraform state file is deleted. What will you do?
```
This is a very important interview question.

First, don't immediately run terraform apply.

If the state is deleted, Terraform may no longer know which existing resources it manages.

For example:

Terraform code
     |
     X
Terraform state deleted
     |
Existing AWS resources

Terraform could potentially think the resources don't exist in its state and propose creating them again.

If using remote backend

If you're using something like an S3 remote backend with versioning/backups, restore the previous state from the backend.

For example:

S3
 |
terraform.tfstate
 |
Version history
 |
Restore previous version

Then run:

terraform init
terraform plan

and carefully verify the plan.

If state is permanently lost

We can recover the relationship between Terraform and existing infrastructure by importing the resources:

terraform import aws_instance.web i-0123456789abcdef0

But for a large infrastructure, manually importing everything can be time-consuming.

Interview answer

"First, I would stop any Terraform apply operations. If we're using a remote backend such as S3 with versioning, I would restore the previous state version. Then I would run terraform plan and verify that Terraform correctly recognizes the existing infrastructure. If the state cannot be recovered, I would recreate the state by importing the existing resources into Terraform."

Best practice

Use:

Remote state
State locking
Encryption
Versioning
Access control
Backups

This makes state recovery much easier.

```sh 
4. How would you manage separate Dev, QA, UAT and Production environments?
```
I would use reusable modules and keep each environment's configuration and state isolated.

For example:

terraform/
│
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── rds/
│   └── eks/
│
└── environments/
    ├── dev/
    ├── qa/
    ├── uat/
    └── prod/

Each environment can have its own:

variables
state
backend
resource configuration

For example:

Dev  → smaller instances
QA   → medium instances
UAT  → production-like setup
Prod → high availability + larger resources
Example

Dev:

instance_type = "t3.micro"

Production:

instance_type = "m5.large"

But both can use the same EC2 module.

Interview answer

"I would create reusable Terraform modules and separate environment configurations for Dev, QA, UAT and Production. Each environment should have its own state and backend configuration so that a change in Dev cannot accidentally affect Production. Environment-specific values such as instance size, replicas and networking would be passed through variables."

Important

For production, I would also have:

Git PR
  ↓
Terraform plan
  ↓
Approval
  ↓
Terraform apply

```sh
##5. How would you securely store Terraform state?
```
Terraform state can contain sensitive information, so I would avoid storing it locally or committing it to Git.

For AWS, a common approach is:

Terraform
    |
    v
S3 Remote Backend
    |
    +-- Encryption
    +-- Versioning
    +-- Access Control

I would configure:

S3 bucket for remote state
Encryption at rest
Versioning
Restricted IAM permissions
State locking using the supported locking mechanism for the Terraform/backend setup
Separate state paths for environments

For example:

S3 bucket
│
├── dev/terraform.tfstate
├── qa/terraform.tfstate
├── uat/terraform.tfstate
└── prod/terraform.tfstate
Interview answer

"I would store Terraform state in a secure remote backend rather than locally. In AWS, I can use S3 with encryption, versioning and restricted IAM access, along with state locking. I would also keep separate state files or state locations for Dev, QA, UAT and Production."

Very important

Never commit:

terraform.tfstate

to Git.

Add it to .gitignore.

```sh
##6. How would you use Terraform in a Jenkins pipeline?
```
This is especially important for a DevOps interview.

A typical Jenkins pipeline would be:

Developer
    |
    v
Git Push
    |
    v
Jenkins
    |
    +--> terraform fmt
    |
    +--> terraform init
    |
    +--> terraform validate
    |
    +--> terraform plan
    |
    v
Approval
    |
    v
terraform apply
    |
    v
AWS / Azure / GCP
Example Jenkins stages
pipeline {
    stages {


        stage('Checkout') {
            steps {
                git 'https://github.com/example/terraform.git'
            }
        }


        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }


        stage('Validate') {
            steps {
                sh 'terraform validate'
            }
        }


        stage('Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }


        stage('Approval') {
            steps {
                input message: 'Apply Terraform changes?'
            }
        }


        stage('Apply') {
            steps {
                sh 'terraform apply tfplan'
            }
        }
    }
}
In a real company

I would not hardcode AWS credentials in the Jenkinsfile.

Instead, Jenkins should use secure credentials or preferably an appropriate cloud identity mechanism.

For example:

Jenkins
   |
   | secure authentication
   v
AWS

And Terraform state would be stored remotely:

Jenkins
   |
   +--------> S3 Terraform State
   |
   +--------> AWS Infrastructure
Interview answer

"I would integrate Terraform into Jenkins using stages such as checkout, init, validate, plan and apply. The plan would be generated first and reviewed or approved before apply. AWS credentials would be stored securely in Jenkins or provided through an appropriate IAM-based authentication mechanism, and Terraform state would be stored in a remote backend with locking."

⭐### Quick interview revision

* Two apply at same time	=> State locking prevents concurrent state modification
* EC2 manually deleted	=>Terraform detects drift and plans to recreate it
 * State deleted	=> Restore remote state backup/version; otherwise import resources
* Dev/QA/UAT/Prod	=> Reusable modules + separate environment configurations/state
 * Secure state => 	Remote backend + encryption + versioning + IAM + locking
* Jenkins + Terraform	init → validate → plan → approval → apply


What really happens when you run   kubectl apply -f deployment.yaml ? 
Most of us use this command every day 👉 
          kubectl apply -f deployment.yaml
But what happens behind the scenes?

Here’s the simplified flow 👇

1. kubectl reads the YAML 
kubectl reads the Kubernetes manifest and converts it into an API request.

2.Request goes to the API Server
The request reaches the Kubernetes API Server, which handles:
        → Authentication
        → Authorization
        → Validation
        → Admission checks

3. Desired state is stored in etcd
Once accepted, Kubernetes stores the desired configuration in etcd, the cluster's key-value store.

4.Deployment Controller takes action

The Deployment Controller watches the desired state and creates/updates a ReplicaSet.

#The ReplicaSet then ensures the required number of Pods exist.

5.Scheduler selects a node

For newly created Pods, the Scheduler finds a suitable worker node based on resources, affinity rules, taints/tolerations, and other scheduling constraints.

6.Kubelet starts the Pod

The kubelet on the selected node notices that a Pod is assigned to it.

It communicates with the container runtime through the CRI to pull the image and create the containers.

7.Kubernetes keeps watching

This is the most important part.
Kubernetes continuously compares:

Desired State ↔ Current State
If you requested:
replicas: 3
but only 2 Pods are running, Kubernetes controllers work to bring the cluster back to 3.

This is the simplified flow:
kubectl → API Server → etcd → Deployment Controller → ReplicaSet → Scheduler → Kubelet → Container Runtime → Running Pod
         
This is one of the core ideas behind Kubernetes:

******
### Whenever we apply the kubectl command, so basically kubectl reads the YAML manifest, then it sends a request to the kube API server and then API server validate the request, some sort of authentication and authorization, and then it store the data into the etcd. Then the scheduler assign the pod to a suitable worker node, then the kubelet on that specific node receives the instructions and ask the container runtime to create the container. Finally the pods start running, and the controller continuously ensure that the desired state is maintain like whatever the replica that we are mentioning inside the deployment file. So usually this is how the flow works.

****
```sh
*1. kubectl talks to the API Server
```
Your YAML file is sent to the Kubernetes API Server.

Think of the API Server as the main entry point of the Kubernetes cluster.
```sh
*2. API Server checks your request
```
Kubernetes checks things like:

→ Are you allowed to create this Pod?
→ Is the YAML valid?
→ Are there any admission rules to follow?

If everything looks good, Kubernetes accepts it.

```sh 
*3. Kubernetes remembers what you asked for
```
The desired state of the Pod is stored in etcd.

Basically, Kubernetes now knows:

«"The user wants this Pod to exist."»
```sh
*4. Scheduler finds a suitable Node
```
The Pod doesn't know where it should run yet.

The Scheduler looks at the available nodes and decides:

«"This Node looks suitable for this Pod."»

*5. kubelet on that Node gets to work

Once the Node is selected, the kubelet on that machine notices:

«"There is a new Pod assigned to me."»

It starts working to create it.
```sh
*6. Container runtime creates the container
```
kubelet talks to the container runtime, such as containerd.

The image is pulled and the container is created.
```sh
* 7. Networking is configured
```
The CNI plugin gives the Pod its network connectivity.

And finally...
Your Pod is running.

#### So the simple picture is:

"kubectl"
↓
"API Server"
↓
"etcd" → remembers desired state
↓
"Scheduler" → chooses the Node
↓
"kubelet" → manages the Pod
↓
"containerd" → creates the container
↓
"CNI" → handles networking
↓
Pod Running
###


Kubernetes Advanced Interview Notes
1. Core Workloads
Advanced Questions & Short Answers
1 Deployment vs StatefulSet -
2
Deployment for stateless apps; StatefulSet for stateful apps
with stable pod identity, ordered rollout, and persistent storage.
DaemonSet -
runs one pod on all or selected nodes; used for
logging, monitoring, networking.
3 ReplicaSet vs Deployment -

Stateless Stateful
Deployment StatefulSet
One pod per node
Deployment
ا
ReplicaSet maintains replica count; Deployment manages
ReplicaSets and supports rolling updates and rollback. ReplicaSet ReplicaSet
(4) What happens when a node fails?-
control plane marks node unavailable; workloads are recreated
on healthy nodes depending on controller and timing.
介
Rescheduled on healthy nodes
(5)
etcd
etcddistributed key-value store holding cluster state and config.
6Why etcd is critical
• without it, cluster desired state cannot be reliably recovered.
Reconciliation loop -
controllers compare desired vs current state and act to
make them match.
kube-scheduler -
4. Update
Desired State
(Spec)
Reconciliation
Loop
Cluster State
(Actual)
Cluster State
Config
Metadata
No etcd,
No Cluster
Recovery!
1. Observe
Controller
K2. Compare
chooses the best node for unscheduled pods.
kube-controller-manager -
runs controllers such as node, replica, endpoints, job. kubelet
←
(10 kubelet -
node agent that ensures pod containers run as expected. Node
JyothiMulkuntla
Ensures Pods
Running as Expected
Page 2/8 Kubernetes Advanced Interview Notes
2. Scheduling
Advanced Questions & Short Answers

affinity zone=us-east
ssd=true
zone=us-east
ssd=true
zone=us-west
ssd=false (11 Node Affinity -
• schedules pods to nodes based on labels.
Nodes
(12) Pod Affinityplaces pods near other matching pods.
affinity
(13 Pod Anti-Affinity
• keeps matching pods apart for
high availability.
-
anti-affinity ♡ 0
(14) Taint on Node Taints & Tolerations- No matching
toleration
Matching
toleration
exists
(15
(16)
• taints repel pods unless matching
tolerations exist.
Node Selector vs Node Affinity -
• node Selector is simple exact match;
affinity is more flexible with rules
such as In, NotIn, Exists, preferred.
topology Spread Constraints-
• spreads pods across nodes/zones/regions
for better availability.
3. Networking
(17) CNI -
(18)
Container Network Interface;
provides pod networking.
Examples: Calico, Cilium, Flannel.
Pod-to-pod communication —
every pod gets an IP; pods can
communicate without NAT between pods.
(19) kube-proxy -
implements Service networking on nodes.
(20) Cluster IP vs NodePort vs LoadBalancer -
ClusterIP internal; NodePort exposes a port on nodes;
LoadBalancer requests external load balancer.
key = dedicated
value = gpи
effect =NoSchedule
node Selector
disktype: ssd
env: prod
(exact match)
Node Affinity
matchExpressions:
- key: disktyре
operator: In
values: [ssd, nvme]
(flexible rules)
Spread across zones
zone-a zone-b zone-c
Direct communication
CNI
Node Node Node
10.244.1.2 10.244.2.7
소
(no NAT)
kube-proxy iptables/
ipvs
Node
iptables/
ipvs
Node
iptables/
ipvs
Node
Cluster IP NodePort LoadBalancer
Service
10.0.0.15
Service
Node IP: 30080
Service
Cloud LB
(21) Headless Service-
(22)
23
clusterIP: None; used for direct pod
discovery, common with StatefulSets.
NetworkPolicy -
controls allowed traffic between pods
and sometimes external endpoints.
Is Network Policy enforced automatically? -
No, the CNI plugin must support
policy enforcement.
(internal only)
Service
cluster IP: None
Allow
frontend →backend
Kubernetes API
(accessible via NodeIP:Port) (external access)
Pods discover
each other
directly via DNS
→Alloved
Denied
Deny
frontend -X db
CNI Plugin
(Enforces)
NetworkPolicy
JyothiMulkuntla
4. Storage
Kubernetes Advanced Interview Notes
Advanced Questions & Short Answers
Page 3/8

(24) PV vs PVC -
PV Bound To PVC
>
PV is storage resource; PVC is
a workload's storage request. (Storage Resource) (Storage Request)
(25) StorageClass
defines how dynamic storage
should be provisioned.
StorageClass
(e.g.,gp2, fast-ssd)
Dynamic
Provisioner
PV Created
(26) Dynamic volume provisioning
• Kubernetes automatically creates storage
when a PVC uses a suitable StorageClass.
PVC StorageClass Provisioner
PV
Created
27 StatefulSet volumeClaimTemplates -
creates a separate PVC for each pod.
e.g., mysql-0→ pvc-0, mysql-1→ pvc-1, mysąl-2→ pvc-2.
5. Health Checks
(28) Liveness vs Readiness -
liveness decides restart;
readiness decides whether
pod gets traffic.
StatefulSet (mysąl)
Pod
mysql-0
Pod
mysql-1
Pod
mysąl-2
↓
PVC
pvc-0
PVC
pvc-1
PVC
pvc-2
Liveness (Restart) Readiness (Traffic)
Container
Restarted
Pod Gets
Traffic
(29) Startup Probe -
for slow-starting apps; prevents
liveness/readiness from interfering
during startup.
Startup Probe
(during startup)
(30) What if readiness probe fails? -
container keeps running, but pod
becomes NotReady and is removed
from Service endpoints.
Readiness
Probe Fails
Liveness/Readiness
(after startup)
NotReady
Healthy
Removed from
Service Endpoints
(31 What if liveness probe fails? -
kubelet restarts the container.
Liveness
Probe Fails
Container
Restarted
Healthy

☆ Kubernetes Advanced Interview Notes Page 4/8
Advanced Questions & Short Answers
6. Resources & Scaling
(32) Request vs Limit -
• request is used for scheduling;
limit is the maximum allowed
resource usage where enforceable.
(33) Exceed memory limitmay be terminated as OOMKilled.
(34 Exceed CPU limit -
(35)
• usually throttled, not killed.
HPAHorizontal Pod Autoscaler changes
replica count based on metrics.
CPU F
ד
request = 250m limit = 500m
Pod
OOMKilled
Throttled
(not killed)
HPA
CPU
CPU/Memory
Metrics

request → for scheduling
limit → max allowed
(enforceable)
Increase replica count
based on metrics
(36) VPA- VPA
Vertical Pod Autoscaler recommends
or adjusts CPU/memory requests.
Recommends
or Adjusts Pod
cpu: 250m
mem: 256Mi cpu: 500m
mem: 512Mi
Adjusts
requests
up or down
(37 Cluster Autoscaler - Scale Up
adds or removes worker nodes based
on scheduling demand and safe
scale-down.
Cluster
Autoscaler
node node node node
Scale Down
node node node node
☆ Requests = guaranteed baseline, Limits = upper cap ☆
HPA vs VPA vs Cluster Autoscaler What it scales What it changes Decision based on
HPA Pods (replicas) Number of Pods CPU/ Memory /
Custom Metrics
VPA T
Cluster Autoscaler
Pod resources CPU/ Memory
requests & limits Usage patterns
Nodes (workers) Number of Nodes Scheduling demand
& safe scale-down
JyothiMulkuntla
☆ Kubernetes Advanced Interview Notes Page 5/8 ☆
7. Security
Advanced Questions & Short Answers
(38) RBAC - Role-Based Access Control
defines who can do what. User Permissions RBAC
Role (Namespace Scoped)

create pods
get secrets
delete pods
Allowed Actions
ClusterRole (Cluster-Wide)
All Namespaces
39) Role vs ClusterRole -
Role is namespace-scoped; Namespace: dev
ClusterRole is cluster-wide or
reusable across namespaces. 8-
(40) RoleBinding vs ClusterRoleBinding Role Binding
Namespace: dev
ClusterRole
(41)
RoleBinding grants permissions
in a namespace;
Cluster Role Binding grants
cluster-wide permissions.
Service Account -
identity for workloads inside Kubernetes.
(42 SecurityContext -
security settings like
- runAsNonRoot: true
- readOnlyRootFilesystem: true
- allow PrivilegeEscalation: false
8 8 8
dev prod
Pod
serviceAccount
ClusterRole Binding
Cluster-Wide
Used by
Pod to call
Kubernetes API
(✓ runAsNon Root: true
43 Pod Security Admission -
built-in enforcement of Pod Security
Standards: Privileged, Baseline, Restricted.
A
readOnlyRootFilesystem: true
allowPrivilegeEscalation: false
A
Privileged
Unrestricted
Baseline
Minimally
Restrictive
Restricted
Strongly
Restricted
8. Configuration ConfigMap Secret
(44 ConfigMap vs Secret -
ConfigMap for non-sensitive config;
Secret for sensitive data.
key: value
key: value
ConfigMap→ non-sensitive
Secret → sensitive
(45) Are Secrets encrypted by default? -
•No; base64 is encoding, not encryption ;
encryption at rest should be configured.
(46 How apps consume ConfigMaps/Secretsvia environment variables, command
arguments, or mounted volumes.
Secret YAML Decoded base64
data: ≠
cGFzc3dvcmQ=
8
(encoding) password
Enable encryption
at rest in
Kubernetes
Encrypted
000
Environment
Variables
Command
Arguments
Mounted
Volumes
JyothiMulkuntla
☆ Kubernetes Advanced Interview Notes Page 6/8
☆
Advanced Questions & Short Answers
9. Deployment Strategies
(47 Rolling Update
(48)
gradually replaces old pods with new ones
while keeping availability.
JyothiMulkuntla
Old Pods (v1) New Pods (v2)
A A
Rolling Update in Progress
Desired Replicas = 3 maxSurge = 1
extra pods allowed above desired replicas
during update.
maxSurgeUp to 4 pods during update
(49) max Unavailable -
Desired Replicas = 3 maxUnavailable = 1
how many pods may be unavailable
during update.
X
At most 1 pod unavailable
50 Rollback a Deployment v2 (Current) Rollback v1 (Previous)
kubectl rollout undo deployment/myapp C
history: kubectl rollout history deployment/myapp
10. Troubleshooting
Crash Restart
(51 CrashLoopBackOff -
container keeps crashing and restarting with backoff.
(52 Image PullBackOff - </<
image pull failed; causes include bad image name/tag,
auth issue, registry or network issue.
image:
myapp:1.01
53 Why a pod stays Pending -
insufficient resources, affinity mismatch, untolerated taints,
PVC issues, scheduling constraints. Pending
Backoff
(Increasing)
Bad image name/tag
Auth issue
Registry or
Network issue
Insufficient resources
Affinity mismatch
Untolerated taints
PVC issues
Scheduling constraints
(54) OOMKilled -
container was killed due to memory
pressure/limit exceedance.
(55) How to troubleshoot a Service
RIP
OOMKilled
-
check svc, endpoints/endpointslices, pod labels, targetPort, readiness, Network Policy.
Service Endpoints/
EndpointSlices
Pods
Useful kubectl logs <pod>
Commands kubectl logs <pod> --previous
kubectl describe pod <pod> kubectl get svc
kubectl get endpoints kubectl get endpointslices
Also check:
Correct
Selector?
Targets Ready?
Labels match?
Listening?
targetPort
Readiness
NetworkPolicy
000 JyothiMulkuntla 어
Page 7/8
☆ Kubernetes Advanced Interview Notes
11. Architecture
Advanced Questions & Short Answers

(56) What happens after kubectl apply?-
(57)
(58)
API Server validates request, stores state in etcd,
controllers reconcile, scheduler assigns pods,
kubelet starts containers via runtimе.
CRI -
Container Runtime Interface; lets Kubernetes
talk to runtimes like containerd and CRI-O.
CSI -
JyothiMulkuntla
API kubectl etcd Controllers Scheduler Kubelet Runtime Server
containerd
Kubernetes CRI
CRI-O
P
Kubernetes → CSI Container Storage Interface; integrates
storage systems with Kubernetes. EBS NFS Ceph
(59) CRD -
N
Custom Resources
</> Custom Resource Definition extends the
Kubernetes API with custom resources.
Define
CRD
Kubernetes
API MyApp MyDB
(60) Operator -
Create CR Manage Custom
Resource →
uses custom resources and controllers
to automate app-specific operations.
Operator
(Controller)
Application Resources
User
12. Advanced Concepts Part 1 Pod
(61 Init Container - Init
Container
Runs
runs and completes before app containers start. First Container App
Pod
(62) Sidecar Container -
Logging
• helper container for logging, proxying,
config sync, etc.
Container App Sidecar
Container
Proxying
Config Sync
(63) PodDisruptionBudget -
limits unavailable replicas during voluntary disruptions.
PDB
min Available: 2
maxUnavailable: 1
Pod
1
Pod
2
Pod Pod
4
At least 2 must remain available
(64) Finalizer -
delays deletion until cleanup is complete.
Resource
(With Finalizer)
finalizers: [...]
Delete Requested Cleanup
Tasks...
Cleanup
Done Resource
Deleted
☑
(65) OwnerReference -
Owner
(Deployment)
defines ownership between resources and
supports garbage collection.
Owned by
If owner is deleted,
dependents are
garbage collected. ReplicaSet Pod Service

Page 8/8 ☆ Kubernetes Advanced Interview Notes
Advanced Questions & Short Answers
12. Advanced Concepts Part 2
66 Garbage Collection -

Owner Owner
deleted
cleans up dependent resources based on ownership and deletion policy. Garbage Collected
(67) PriorityClass -
High
(100000)
Medium
(1000)
Low
(0)
assigns pod priority.
Higher value
= higher
priority
68 Pod Preemption -
Low Priority Evicted High Priority Pods Pod
scheduler may evict lower-priority pods for a higher-priority pod. 000
(69) Admission Controllers -
API
Admission
Controller ☑ Allow
Request
validate or mutate API requests before persistence. Reject
(70 Mutating vs Validating Admission - Mutating Validating
mutating can modify objects; validating allows or rejects. Can modify
objects
Allows
or rejects
13. Scenario Questions Readiness
Troubleshoot
71 Pod is Running but app is unreachable -
check readiness, Service selector, Service port/targetPort, EndpointSlice,
Ingress/Gateway/LoadBalancer, NetworkPolicy, app logs.
☑
Checklist
Service
Endpoint Slice
Ingress/LB
NetworkPolicy
72 Pod works by IP but not by Service name -
check Service config; selector, EndpointSlices, CoreDNS,
DNS config, network plugin.
Service Name CoreDNS
Logs
IP Pods
?
(73 Pods not scheduling on a new node -
check node readiness, taints, resources, affinity,
node selectors, events.
74 How to design high availability -
use multiple replicas, multiple nodes, zone spread,
pod anti-affinity or topology spread, readiness probes,
Pod Disruption Budget, autoscaling.
(75) Investigate high CPU usagecheck kubectl top pods, kubectl top nodes, describe pod,
logs, CPU requests/limits, app behavior, HPA, monitoring metrics.
Top 10 Must-Know Advanced Questions☆
?
1 How does Kubernetes schedule a pod?
2 What happens when you run kubectl apply?
249999 3 Difference between liveness, readiness, startup probes?
4 What are requests vs limits and how do they work?
Difference between taints/tolerations and affinity?
6 How does Service networking work in Kubernetes?
How would you troubleshoot a Pending pod?
Difference between Deployment, StatefulSet, DaemonSet?
How does Kubernetes handle node failure?
10 How would you design a high availability application?

New Node
Not Ready
Zone A Zone B Zone C
Ω HA
☑
Spread across zones
☑
CPU Usage kubectl top pods
100% ☑ kubectl top nodes
50% ✓describe pod logs 0% ☑ requests/limits ✓HPA & Metrics
Taints
Resources
Affinity/Node Selectors
Events
