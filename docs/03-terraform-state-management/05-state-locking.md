# Terraform State Locking

## Learning Objectives

By the end of this chapter, you should be able to:

- Understand why Terraform state locking exists
- Understand concurrent Terraform operations
- Understand how locking protects state
- Understand AWS DynamoDB state locking
- Understand cloud-native locking approaches
- Troubleshoot state lock issues
- Apply locking best practices in production

---

# Introduction

Terraform state is shared infrastructure information.

We learned:

```
Terraform State = Terraform's memory
```

Because state is important, Terraform must prevent multiple operations from modifying it at the same time.

This is where:

```
State Locking
```

comes in.

---

# What Is State Locking?

State locking prevents multiple Terraform processes from changing the same state simultaneously.

Example:

Developer A:

```bash
terraform apply
```

Developer B:

```bash
terraform apply
```

at the same time.

Without locking:

```
Both read state

Both make changes

Both write state
```

This can corrupt state.

---

# Why State Locking Is Needed

Imagine:

Current state:

```
VPC
EC2
Database
```

Engineer A changes:

```
EC2
```

Engineer B changes:

```
Database
```

Both start at the same time.

Without locking:

```
Engineer A state
+
Engineer B state

=
Conflict
```

---

# Without Locking

Example timeline:

```
10:00

Engineer A reads state


10:01

Engineer B reads state


10:02

Engineer A writes changes


10:03

Engineer B overwrites state
```

Result:

```
Lost changes
Incorrect state
Infrastructure drift
```

---

# With Locking

With locking:

```
Engineer A

     |
     v

Acquire Lock

     |
     v

Apply Changes

     |
     v

Update State

     |
     v

Release Lock
```

Engineer B waits.

---

# Terraform Lock Workflow

When running:

```bash
terraform apply
```

Terraform does:

```
Request State Lock

        ↓

Check Lock Availability

        ↓

Perform Changes

        ↓

Update State

        ↓

Release Lock
```

---

# Local State Locking

Local state:

```
terraform.tfstate
```

is not designed for teams.

Problems:

- Only exists on one machine
- No shared locking
- No collaboration
- Easy to lose

Suitable for:

```
Learning
Testing
Small personal projects
```

---

# Remote State Locking

Production Terraform uses:

```
Remote Backend

+

Locking Mechanism
```

Examples:

AWS:

```
S3

+

DynamoDB
```

Azure:

```
Azure Blob Lease
```

Terraform Cloud:

```
Built-in locking
```

---

# AWS S3 + DynamoDB Locking

Traditional AWS Terraform architecture:

```
Terraform

    |

    v

S3 Bucket
(State Storage)

    +

DynamoDB Table
(State Lock)
```

---

# S3 Backend With DynamoDB Lock

Example:

```hcl
terraform {

  backend "s3" {

    bucket = "terraform-state"

    key = "prod/terraform.tfstate"

    region = "eu-west-1"

    dynamodb_table = "terraform-locks"

    encrypt = true

  }

}
```

---

# How DynamoDB Lock Works

When Terraform starts:

```
Create Lock Record
```

Example:

```
LockID:

prod/terraform.tfstate
```

Other Terraform processes see:

```
State Locked
```

and wait.

---

# Lock Information

A lock contains information such as:

```
Who created the lock

Operation type

Time created

State being modified
```

This helps troubleshooting.

---

# Lock Error Example

You may see:

```
Error acquiring the state lock
```

Meaning:

Another Terraform process is using the state.

---

# What To Do When Locked

First check:

```
Is another Terraform process running?
```

Examples:

- Another developer applying
- CI/CD pipeline running
- Previous command still active

---

# Waiting For Lock

You can configure timeout:

```bash
terraform apply -lock-timeout=10m
```

Meaning:

Wait up to:

```
10 minutes
```

for the lock.

---

# Force Unlock

Sometimes a process crashes.

Example:

```
terraform apply
```

is interrupted.

The lock remains.

Command:

```bash
terraform force-unlock LOCK_ID
```

Example:

```bash
terraform force-unlock abc123
```

---

# Important Warning

Do not force unlock blindly.

Before unlocking confirm:

```
No Terraform process is running
```

Otherwise:

```
Two applies
at the same time
```

can damage state.

---

# Locking In CI/CD

Modern teams run Terraform through:

```
GitHub Actions

GitLab CI

Jenkins

Azure DevOps
```

Multiple jobs can start.

Example:

Pipeline A:

```
terraform apply
```

Pipeline B:

```
terraform apply
```

Locking prevents both from changing infrastructure.

---

# Cloud-Native Locking

## AWS

Common setup:

```
S3 Backend

+

DynamoDB Lock Table
```

---

## Azure

Azure Blob Storage provides:

```
Blob Lease Locking
```

---

## Terraform Cloud

Provides:

```
Remote State

Remote Execution

Lock Management
```

---

# Common Lock Problems

## Problem 1

Error:

```
Error acquiring state lock
```

Cause:

Another process is running.

Solution:

Wait.

---

## Problem 2

Old lock remains.

Cause:

Crash or interrupted process.

Solution:

Check and use:

```bash
terraform force-unlock
```

---

## Problem 3

No locking enabled.

Result:

```
Concurrent changes
State corruption risk
```

Solution:

Use remote backend.

---

# State Locking Best Practices

Always:

- Use remote state
- Enable locking
- Use CI/CD controls
- Investigate locks before removing
- Separate environments
- Protect backend access

---

# Production Architecture

Typical setup:

```
Developer

     |

Git Repository

     |

CI/CD Pipeline

     |

Terraform

     |

Remote Backend

     |

Cloud Infrastructure
```

---

# Key Takeaways

- State locking prevents simultaneous changes
- Remote backends enable safe collaboration
- DynamoDB provides AWS locking
- Force unlock must be used carefully
- Locking is required for production Terraform

---

# Next Chapter

Next:

```
06-state-security.md
```

You will learn:

- Protecting Terraform state
- Encryption
- IAM permissions
- Secrets handling
- Secure state practices