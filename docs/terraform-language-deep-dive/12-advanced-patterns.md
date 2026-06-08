# Advanced Terraform Patterns

## Learning Objectives

By the end of this chapter, you should be able to:

* Import existing infrastructure into Terraform
* Safely rename and refactor resources
* Use moved blocks for zero-downtime refactoring
* Work with provider aliases
* Understand real production Terraform evolution patterns
* Avoid resource recreation during refactoring
* Build enterprise-grade Terraform workflows

---

# Introduction

At this point, you understand:

```text id="p12a"
Variables
Modules
State
Meta-arguments
Complex types
```

Now we move into:

```text id="p12b"
Real-world Terraform engineering patterns
```

These are the techniques used when:

```text id="p12c"
Migrating legacy infrastructure
Scaling large systems
Refactoring modules safely
Managing multi-account environments
```

---

# 1. Importing Existing Infrastructure

Terraform can manage resources that were created manually.

Example:

```bash id="imp1"
terraform import aws_instance.web i-1234567890abcdef
```

---

## What happens:

```text id="imp2"
Terraform attaches existing infrastructure to state
```

But NOT to configuration.

You still need:

```hcl id="imp3"
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t3.micro"
}
```

---

## Key idea:

```text id="imp4"
Import = bring into state
Not = generate config automatically
```

---

# 2. Moved Blocks (VERY IMPORTANT)

Moved blocks allow safe refactoring.

---

## Problem:

You rename a resource:

```hcl id="mv1"
resource "aws_instance" "web_old" {}
```

to:

```hcl id="mv2"
resource "aws_instance" "web_new" {}
```

Terraform thinks:

```text id="mv3"
Destroy old
Create new
```

❌ This is dangerous.

---

## Solution: moved block

```hcl id="mv4"
moved {
  from = aws_instance.web_old
  to   = aws_instance.web_new
}
```

---

## Result:

```text id="mv5"
Terraform updates state mapping only
NO resource replacement
```

---

# 3. Resource Refactoring Without Downtime

Example refactor:

Before:

```hcl id="rf1"
resource "aws_s3_bucket" "logs" {}
```

After:

```hcl id="rf2"
resource "aws_s3_bucket" "app_logs" {}
```

Add:

```hcl id="rf3"
moved {
  from = aws_s3_bucket.logs
  to   = aws_s3_bucket.app_logs
}
```

---

## Why this matters:

```text id="rf4"
Prevents accidental destruction
Preserves production data
Enables safe renaming
```

---

# 4. Multiple Provider Configurations (Aliases)

Sometimes you manage multiple regions/accounts.

---

## Example:

```hcl id="pr1"
provider "aws" {
  region = "eu-west-1"
}
```

```hcl id="pr2"
provider "aws" {
  alias  = "us"
  region = "us-east-1"
}
```

---

## Using both:

```hcl id="pr3"
resource "aws_s3_bucket" "eu_bucket" {}

resource "aws_s3_bucket" "us_bucket" {
  provider = aws.us
}
```

---

## Why this matters:

```text id="pr4"
Multi-region deployments
Disaster recovery
Global infrastructure
```

---

# 5. Data Migration Pattern

Example: moving from hardcoded to modular infrastructure

Before:

```hcl id="dm1"
resource "aws_instance" "web" {}
```

After module:

```hcl id="dm2"
module "web" {
  source = "./modules/ec2"
}
```

Fix state:

```hcl id="dm3"
moved {
  from = aws_instance.web
  to   = module.web.aws_instance.this
}
```

---

# 6. Refactoring at Scale

Large Terraform projects often require:

```text id="rs1"
Renaming resources
Splitting modules
Merging modules
Reorganizing structure
```

Without breaking infrastructure.

Moved blocks make this safe.

---

# 7. Safe Module Evolution

Old module:

```text id="me1"
modules/v1/ec2
```

New module:

```text id="me2"
modules/v2/ec2
```

Migration:

```hcl id="me3"
moved {
  from = module.ec2_v1
  to   = module.ec2_v2
}
```

---

# 8. Common Production Patterns

## Pattern 1: Import then manage

```text id="cp1"
1. Import resource
2. Define config
3. Sync state
```

---

## Pattern 2: Refactor with moved

```text id="cp2"
Rename safely without destruction
```

---

## Pattern 3: Multi-provider deployments

```text id="cp3"
Same infrastructure in multiple regions
```

---

## Pattern 4: Module migration

```text id="cp4"
Move from flat to modular architecture
```

---

# 9. Common Mistakes

## ❌ Forgetting moved blocks

```text id="cm1"
Leads to accidental resource destruction
```

---

## ❌ Re-importing instead of refactoring

```text id="cm2"
Causes state inconsistency
```

---

## ❌ Mixing providers incorrectly

```text id="cm3"
Creates resource drift and confusion
```

---

# 10. Best Practices

* Always use moved blocks during refactors
* Never rename resources without state migration
* Use provider aliases for multi-region setups
* Import existing infrastructure before managing it
* Refactor in small steps
* Validate with terraform plan before apply

---

# Key Takeaways

* Import brings existing infrastructure into state
* moved blocks prevent destructive refactoring
* provider aliases enable multi-region setups
* advanced patterns are essential for enterprise Terraform
* safe refactoring is a core Terraform skill

---

# 🎉 Terraform Language Deep Dive Complete

You now understand:

```text id="final1"
Variables & Types
Meta Arguments
Dynamic Blocks
Complex Data Types
Advanced Patterns
```

This is **production-level Terraform foundation**.

---

# Next Phase

We now move to:

```text id="next1"
State Management
```

This is the most critical part of Terraform in real companies because it controls:

```text id="next2"
Infrastructure truth
Team collaboration
Remote backends
Locking
Drift handling
```

This is where Terraform becomes **enterprise-grade tooling**.
