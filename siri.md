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

4. What is a Terraform Resource?

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
10. What are Terraform Outputs?

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

14. Difference between count and for_each

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
16. What is Terraform Import?

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

17. What happens if someone manually changes infrastructure?

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
18. What is the Terraform lifecycle block?

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
19. How do you manage multiple environments?

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

20. Explain the Terraform workflow

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


Two developers run terraform apply at the same time. What happens?

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

2. Someone manually deletes an EC2 instance managed by Terraform. What happens?

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

3. Your Terraform state file is deleted. What will you do?

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

4. How would you manage separate Dev, QA, UAT and Production environments?

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
5. How would you securely store Terraform state?

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

6. How would you use Terraform in a Jenkins pipeline?

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

⭐ Quick interview revision
Scenario	Best answer
Two apply at same time	State locking prevents concurrent state modification
EC2 manually deleted	Terraform detects drift and plans to recreate it
State deleted	Restore remote state backup/version; otherwise import resources
Dev/QA/UAT/Prod	Reusable modules + separate environment configurations/state
Secure state	Remote backend + encryption + versioning + IAM + locking
Jenkins + Terraform	init → validate → plan → approval → apply
