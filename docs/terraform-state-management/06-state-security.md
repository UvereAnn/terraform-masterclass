# Terraform State Security

## Learning Objectives

By the end of this chapter, you should be able to:

- Understand why Terraform state must be protected
- Identify sensitive information stored in state
- Secure local state files
- Secure remote state backends
- Understand encryption
- Understand IAM permissions
- Apply production state security practices

---

# Introduction

Terraform state is extremely important.

We already learned:

```
Terraform State = Terraform's memory
```

But state is also:

```
Terraform State = Infrastructure Data
```

This means it must be protected.

---

# Why State Security Matters

Terraform state can contain:

- Resource IDs
- Network information
- IP addresses
- Database endpoints
- Configuration values
- Provider metadata

Some resources may store:

- Passwords
- Tokens
- Secrets
- Credentials

Example:

```text
terraform.tfstate

        |
        |
        v

Infrastructure details
Sensitive values
```

---

# Never Commit State To Git

Bad practice:

```
git add terraform.tfstate
```

Never store:

```
terraform.tfstate
terraform.tfstate.backup
```

inside repositories.

---

# Add State To .gitignore

Create:

```
.gitignore
```

Add:

```gitignore
*.tfstate
*.tfstate.*
.terraform/
```

---

# Why Git Is Dangerous For State

Git history is permanent.

If someone commits:

```
password = "secret123"
```

and later removes it:

The old commit may still contain it.

---

# Local State Security

Local state:

```
project/

├── main.tf
├── variables.tf
└── terraform.tfstate
```

Problems:

- Laptop failure
- Accidental deletion
- Unauthorized access
- No collaboration

Local state is acceptable for:

- Learning
- Experiments
- Personal projects

Not production.

---

# Remote State Security

Production uses:

```
Remote Backend
```

Examples:

AWS:

```
S3
```

Azure:

```
Azure Blob Storage
```

Google Cloud:

```
Cloud Storage
```

---

# Encryption At Rest

State should be encrypted.

Example AWS:

```hcl
terraform {

 backend "s3" {

   bucket = "terraform-state"

   key = "prod.tfstate"

   region = "eu-west-1"

   encrypt = true

 }

}
```

---

# Encryption In Transit

Communication between:

```
Terraform

    |

Backend
```

should use:

```
HTTPS/TLS
```

Modern cloud backends provide this by default.

---

# AWS S3 State Security

Recommended:

```
S3 Bucket

+
Encryption

+
Versioning

+
IAM Controls
```

---

# S3 Versioning

Enable versioning:

Why?

If state is accidentally damaged:

You can restore:

```
Previous State Version
```

Example:

```
terraform.tfstate

version 1

version 2

version 3
```

---

# IAM Permissions

Not everyone should access state.

Example:

Developers:

```
Read state
```

Administrators:

```
Modify state
```

---

# Principle of Least Privilege

Give users only what they need.

Avoid:

```
AdministratorAccess
```

for everyone.

---

# Example Access Model

Team:

```
Developer

   |
   |
Terraform Apply

   |
   v

Backend
```

Permissions:

```
Read State

Write State

Lock State
```

---

# Sensitive Variables

Never hardcode secrets:

Bad:

```hcl
password = "mypassword"
```

Better:

```hcl
variable "db_password" {

 type = string

 sensitive = true

}
```

---

# Sensitive Outputs

Example:

```hcl
output "database_password" {

 value = var.password

 sensitive = true

}
```

Terraform hides the value.

---

# Important Note

Sensitive does NOT encrypt data.

It only hides display output.

The value still exists in state.

---

# Secret Management

Use dedicated secret systems.

Examples:

AWS:

```
Secrets Manager
```

Azure:

```
Key Vault
```

GCP:

```
Secret Manager
```

HashiCorp:

```
Vault
```

---

# State Access Logging

Production systems should track:

- Who accessed state
- When it happened
- What changed

Examples:

AWS:

```
CloudTrail
```

Azure:

```
Activity Logs
```

GCP:

```
Audit Logs
```

---

# State Backup Strategy

Good practice:

```
Remote State

+

Versioning

+

Backup
```

Example:

```
S3 Versioning

Daily backups

Recovery plan
```

---

# State File Permissions

Local state:

Recommended:

```
chmod 600 terraform.tfstate
```

Meaning:

Only owner can read/write.

---

# Common Security Mistakes

## Mistake 1

Committing state.

Fix:

```
.gitignore
```

---

## Mistake 2

Sharing state files.

Fix:

Use remote backend.

---

## Mistake 3

Everyone has admin access.

Fix:

Use IAM roles.

---

## Mistake 4

Putting secrets in code.

Fix:

Use secret managers.

---

# Production Security Checklist

Before production:

```
Remote backend enabled

Encryption enabled

Locking enabled

IAM restricted

Versioning enabled

Secrets externalized

Audit logging enabled
```

---

# Key Takeaways

- Terraform state contains important data
- Protect state like production data
- Never commit state to Git
- Use remote backends
- Encrypt state
- Control access
- Use secret management tools

---

# Next Chapter

Next:

```
07-state-best-practices.md
```

We will cover:

- Production state workflows
- Team collaboration
- Disaster recovery
- State migration
- Enterprise recommendations