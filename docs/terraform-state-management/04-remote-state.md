# Remote State

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what remote state is
* Understand why teams use remote state
* Configure remote backends
* Understand S3 backend
* Understand Azure Storage backend
* Understand Google Cloud Storage backend
* Understand state sharing between engineers
* Understand backend best practices

---

# Introduction

In previous chapters, we learned:

```text
terraform.tfstate
```

stores Terraform's memory.

By default, Terraform stores state locally:

```text
project/

├── main.tf

└── terraform.tfstate
```

This works for learning.

But production teams need something better.

The solution:

```text
Remote State
```

---

# What is Remote State?

Remote state means storing Terraform state outside your local machine.

Instead of:

```text
Developer Laptop

terraform.tfstate
```

You store:

```text
Cloud Backend

terraform.tfstate
```

Example:

```text
AWS S3

Azure Storage

Google Cloud Storage
```

---

# Why Remote State?

Imagine a team:

Developer A:

```text
Creates VPC
```

Developer B:

```text
Creates EC2
```

Both need the same infrastructure state.

Local state creates problems:

```text
Different state files

Conflicts

Lost updates

No collaboration
```

Remote state solves this.

---

# Local State Problem

Developer A:

```text
terraform apply
```

State:

```text
VPC exists
```

Developer B:

```text
old terraform.tfstate
```

State:

```text
No VPC
```

Now Terraform has inconsistent information.

---

# Remote State Solution

Everyone connects to:

```text
Shared Backend
```

Example:

```text
AWS S3 Bucket

terraform.tfstate
```

Everyone sees the same state.

---

# Terraform Backend

A backend defines where state is stored.

Example:

```hcl
terraform {
  backend "s3" {

    bucket = "terraform-state"

    key = "prod/app.tfstate"

    region = "eu-west-1"

  }
}
```

---

# Backend Characteristics

A good backend provides:

```text
Storage

Security

Availability

Locking

Collaboration
```

---

# AWS S3 Backend

The most common Terraform backend.

Architecture:

```text
Terraform

     |

     v

AWS S3 Bucket

     |

terraform.tfstate
```

---

# S3 Backend Example

```hcl
terraform {

 backend "s3" {

   bucket = "company-terraform-state"

   key    = "network/prod.tfstate"

   region = "eu-west-1"

 }

}
```

---

# Explanation

## bucket

Where state lives:

```text
company-terraform-state
```

---

## key

State file location:

```text
network/prod.tfstate
```

Allows multiple environments:

```text
dev.tfstate

staging.tfstate

prod.tfstate
```

---

## region

AWS region:

```text
eu-west-1
```

---

# S3 Backend Folder Pattern

Common:

```text
S3 Bucket

terraform-state/

├── dev/

│   └── terraform.tfstate

├── staging/

│   └── terraform.tfstate

└── prod/

    └── terraform.tfstate
```

---

# Azure Storage Backend

Azure uses:

```text
Azure Blob Storage
```

Example:

```hcl
terraform {

 backend "azurerm" {

   resource_group_name  = "terraform"

   storage_account_name = "tfstate"

   container_name       = "state"

   key                  = "prod.tfstate"

 }

}
```

---

# Azure Architecture

```text
Terraform

     |

     v

Azure Storage Account

     |

Blob Container

     |

terraform.tfstate
```

---

# Google Cloud Storage Backend

GCP uses:

```text
Google Cloud Storage Bucket
```

Example:

```hcl
terraform {

 backend "gcs" {

   bucket = "terraform-state"

   prefix = "prod"

 }

}
```

---

# Backend Initialization

After adding backend configuration:

Run:

```bash
terraform init
```

Terraform asks:

```text
Migrate existing state?
```

If yes:

```text
Local State
      |
      v
Remote Backend
```

---

# Remote State Migration

Before:

```text
Laptop

terraform.tfstate
```

After:

```text
S3 Bucket

terraform.tfstate
```

Terraform moves state safely.

---

# Remote State Data Source

Sometimes one Terraform project needs another project's outputs.

Example:

Network project creates:

```text
VPC ID
```

Application project needs:

```text
VPC ID
```

Use:

```hcl
data "terraform_remote_state" "network" {

 backend = "s3"

 config = {

   bucket = "terraform-state"

   key    = "network.tfstate"

   region = "eu-west-1"

 }

}
```

---

# Accessing Remote Outputs

Example:

```hcl
data.terraform_remote_state.network.outputs.vpc_id
```

---

# Real Production Pattern

Separate infrastructure:

```text
Network Terraform

        |

        v

Application Terraform

        |

        v

Database Terraform
```

Each has its own state.

---

# Backend Security

State contains sensitive information.

Protect it with:

```text
Encryption

IAM permissions

Access control

Private storage
```

---

# S3 Security Example

Enable:

```text
S3 Encryption

Bucket Versioning

Restricted IAM

Private Bucket
```

---

# Backend Best Practices

* Never store production state locally
* Use remote backends
* Enable encryption
* Enable versioning
* Restrict access
* Separate environments
* Use locking

---

# Common Mistakes

## One State File For Everything

Bad:

```text
company.tfstate
```

Better:

```text
dev.tfstate

prod.tfstate
```

---

## Sharing State Through Git

Never:

```text
git add terraform.tfstate
```

---

## No Access Control

Everyone should not modify production state.

---

# Key Takeaways

* Remote state enables collaboration
* Backends store Terraform state externally
* S3 is the most common backend
* Azure uses Blob Storage
* GCP uses Cloud Storage
* Remote state is essential for teams

---

# Next Chapter

Next:

```text
05-state-locking.md
```

You will learn:

* Why locking exists
* Preventing simultaneous changes
* DynamoDB locking
* Cloud-native locking solutions
* Handling concurrent Terraform runs
