# What is Terraform State?

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what Terraform State is
* Understand why Terraform needs state
* Understand how Terraform tracks infrastructure
* Understand the relationship between configuration and reality
* Understand local state files
* Understand why state is considered Terraform's source of truth

---

# Introduction

Terraform is a declarative Infrastructure as Code (IaC) tool.

You define the desired state of your infrastructure:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t3.micro"
}
```

Terraform creates the infrastructure.

A critical question immediately appears:

**How does Terraform know what it previously created?**

The answer is:

**Terraform State**

---

# What is Terraform State?

Terraform State is a file that stores information about infrastructure managed by Terraform.

By default:

```text
terraform.tfstate
```

Terraform uses this file to map:

```text
Terraform Configuration
        ↓
Terraform State
        ↓
Real Infrastructure
```

Without state, Terraform would have no memory of existing resources.

---

# Why Terraform Needs State

Consider this resource:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t3.micro"
}
```

When Terraform creates it, AWS returns something similar to:

```text
i-0abc123456789
```

Terraform stores that information in state.

Example:

```text
aws_instance.web
      ↓
i-0abc123456789
```

The next time you run:

```bash
terraform plan
```

Terraform uses the state file to determine:

* What already exists
* What changed
* What must be updated
* What should be destroyed

---

# Terraform's Three Sources of Truth

Terraform constantly compares three things:

## Configuration

Your Terraform code:

```hcl
resource "aws_instance" "web" {}
```

## State

Terraform's memory:

```text
aws_instance.web → i-0abc123456789
```

## Reality

The actual cloud infrastructure:

```text
EC2 Instance Running
```

Terraform compares all three before generating a plan.

---

# Terraform Workflow

When you execute:

```bash
terraform plan
```

Terraform performs:

```text
Read Configuration
        ↓
Read State
        ↓
Query Provider APIs
        ↓
Compare Everything
        ↓
Generate Execution Plan
```

This comparison process is the foundation of Terraform.

---

# Local State

By default, Terraform stores state locally.

Example project:

```text
project/
├── main.tf
├── variables.tf
└── terraform.tfstate
```

The state file lives in the working directory.

---

# Viewing State

After running:

```bash
terraform apply
```

You can inspect state:

```bash
cat terraform.tfstate
```

or

```bash
code terraform.tfstate
```

You will notice the file is JSON.

---

# Important Warning

Never edit state manually unless you fully understand the consequences.

Bad:

```text
Open state file
Edit values
Save file
```

Possible result:

```text
State corruption
Broken deployments
Resource recreation
```

Always prefer Terraform state commands.

---

# What Happens If State Is Deleted?

Suppose someone runs:

```bash
rm terraform.tfstate
```

Terraform loses its memory.

Infrastructure still exists:

```text
EC2 Instance Running
```

But Terraform believes:

```text
No infrastructure exists
```

The next plan may attempt to create resources again.

---

# State Is Not Infrastructure

A common misunderstanding:

Deleting state does NOT delete resources.

Example:

```text
State Deleted
       ≠
Infrastructure Deleted
```

The resources continue running.

Terraform simply loses track of them.

---

# Sensitive Data in State

State files often contain:

```text
Resource IDs
Private IPs
Public IPs
Database Endpoints
Metadata
```

Some providers may also store:

```text
Secrets
Tokens
Passwords
```

Protect state carefully.

---

# Common Beginner Mistakes

## Committing State to Git

Never commit:

```text
terraform.tfstate
terraform.tfstate.backup
```

Use:

```gitignore
*.tfstate
*.tfstate.backup
```

---

## Editing State Directly

Use Terraform commands instead of modifying JSON manually.

---

## Sharing Local State

Never share state files through:

```text
Email
Slack
Teams
USB Drives
```

Use remote backends instead.

---

# Best Practices

* Treat state as critical infrastructure data
* Never manually edit state
* Never commit state files to Git
* Use remote backends for teams
* Protect state with proper access controls
* Always back up important state files

---

# Key Takeaways

* Terraform State is Terraform's memory.
* State maps configuration to real infrastructure.
* Terraform compares configuration, state, and reality.
* State is stored in terraform.tfstate by default.
* State contains critical infrastructure information.
* Proper state management is essential in production.

---

# Next Chapter

In the next chapter:

## State File Structure

You will learn:

* How terraform.tfstate is organized
* Resources section
* Instances section
* Outputs section
* Metadata
* Dependencies

Understanding the structure of the state file will make Terraform much easier to troubleshoot.
