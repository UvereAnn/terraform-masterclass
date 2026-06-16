# lifecycle

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand the lifecycle Meta Argument
* Prevent Accidental Resource Deletion
* Control Resource Replacement
* Minimize Downtime
* Ignore Specific Changes
* Use create_before_destroy
* Use prevent_destroy
* Use ignore_changes
* Understand Production Lifecycle Patterns

---

# Introduction

Terraform normally manages resources according to its state.

When Terraform detects a difference:

```text
Configuration

↓

Plan

↓

Apply
```

Terraform decides whether to:

```text
Create

Update

Replace

Destroy
```

Most of the time this works well.

However, some infrastructure requires additional protection.

Examples:

```text
Production Databases

S3 Buckets

Critical Networking

Load Balancers
```

This is where lifecycle rules become important.

---

# What is lifecycle?

Lifecycle is a Meta Argument that changes Terraform's default behavior.

Example:

```hcl
resource "aws_instance" "web" {

  ami = "ami-123456"

  instance_type = "t3.micro"

  lifecycle {

  }

}
```

Lifecycle rules are defined inside:

```hcl
lifecycle {}
```

blocks.

---

# Available Lifecycle Rules

Terraform provides several lifecycle controls:

```text
create_before_destroy

prevent_destroy

ignore_changes

replace_triggered_by
```

These are the most important lifecycle settings.

---

# create_before_destroy

One of the most valuable production features.

Normally Terraform replaces resources like this:

```text
Destroy Old Resource

↓

Create New Resource
```

This can cause downtime.

---

# Example Without create_before_destroy

Suppose an EC2 instance requires replacement.

Terraform may perform:

```text
Destroy Existing Instance

↓

Create New Instance
```

Users experience downtime.

---

# Using create_before_destroy

Example:

```hcl
resource "aws_instance" "web" {

  ami = "ami-123456"

  lifecycle {

    create_before_destroy = true

  }

}
```

Terraform changes behavior.

New order:

```text
Create New Instance

↓

Destroy Old Instance
```

Downtime is minimized.

---

# Production Use Cases

Common examples:

```text
Load Balancers

EC2 Instances

Auto Scaling Infrastructure

Application Servers

DNS Infrastructure
```

Anywhere downtime matters.

---

# Visual Comparison

Default:

```text
Old Resource

↓

Destroy

↓

Create New Resource
```

create_before_destroy:

```text
Old Resource

↓

Create New Resource

↓

Destroy Old Resource
```

Much safer.

---

# prevent_destroy

One of the most important safety features.

Example:

```hcl
resource "aws_db_instance" "production" {

  lifecycle {

    prevent_destroy = true

  }

}
```

Terraform now refuses destruction.

---

# What Happens?

Suppose someone runs:

```bash
terraform destroy
```

Terraform returns an error.

Example:

```text
Resource cannot be destroyed.

prevent_destroy is enabled.
```

Infrastructure remains protected.

---

# Production Examples

Common resources protected by:

```hcl
prevent_destroy = true
```

include:

```text
Production Databases

Critical S3 Buckets

Shared Networking

Identity Infrastructure
```

Many organizations require this.

---

# When Not to Use prevent_destroy

Avoid using it everywhere.

Bad example:

```text
Temporary Development Resources
```

Terraform becomes difficult to manage.

Use it only for critical resources.

---

# ignore_changes

Another extremely important lifecycle rule.

Sometimes external systems modify resources.

Terraform sees:

```text
Configuration

≠

Actual Infrastructure
```

and wants to fix it.

Sometimes that behavior is undesirable.

---

# Example

Resource:

```hcl
resource "aws_instance" "web" {

  tags = {

    Environment = "dev"

  }

}
```

An external process adds:

```text
Owner = Platform-Team
```

Terraform detects drift.

Without lifecycle rules:

```text
Terraform Removes Tag
```

during the next apply.

---

# Using ignore_changes

Example:

```hcl
resource "aws_instance" "web" {

  lifecycle {

    ignore_changes = [

      tags

    ]

  }

}
```

Terraform ignores tag changes.

External updates remain untouched.

---

# Ignoring Specific Attributes

Example:

```hcl
resource "aws_instance" "web" {

  lifecycle {

    ignore_changes = [

      user_data

    ]

  }

}
```

Terraform ignores:

```text
user_data
```

changes.

Everything else remains managed.

---

# Ignoring Multiple Attributes

Example:

```hcl
resource "aws_instance" "web" {

  lifecycle {

    ignore_changes = [

      tags,

      user_data,

      metadata_options

    ]

  }

}
```

Terraform ignores all listed attributes.

---

# Common Production Scenarios

ignore_changes is often used for:

```text
Tags

Monitoring Metadata

Cloud-Managed Attributes

Auto-Generated Values

External Automation Updates
```

Very common in enterprise environments.

---

# replace_triggered_by

Introduced to give more control over replacement behavior.

Example:

```hcl
resource "aws_instance" "web" {

  lifecycle {

    replace_triggered_by = [

      aws_security_group.web

    ]

  }

}
```

If:

```text
aws_security_group.web
```

changes,

Terraform replaces:

```text
aws_instance.web
```

even if the instance itself did not change.

---

# Why Use replace_triggered_by?

Useful when resources are tightly coupled.

Examples:

```text
Certificates

Security Groups

Launch Templates

Custom Images
```

Changes to one resource may require replacement of another.

---

# Lifecycle and State

Lifecycle rules affect:

```text
Planning

Updates

Replacement Decisions

Destruction Decisions
```

They do not alter the state file itself.

---

# Production Example

Database:

```hcl
resource "aws_db_instance" "production" {

  lifecycle {

    prevent_destroy = true

  }

}
```

Application Server:

```hcl
resource "aws_instance" "app" {

  lifecycle {

    create_before_destroy = true

  }

}
```

Monitoring Tags:

```hcl
resource "aws_instance" "app" {

  lifecycle {

    ignore_changes = [

      tags

    ]

  }

}
```

Each rule serves a different purpose.

---

# Common Beginner Mistakes

## Using prevent_destroy Everywhere

Bad:

```text
Every Resource Protected
```

Results:

```text
Hard-to-Manage Infrastructure
```

Protect only critical resources.

---

## Ignoring Too Many Changes

Bad:

```hcl
ignore_changes = all
```

Terraform may stop managing important attributes.

Use ignore_changes carefully.

---

## Forgetting create_before_destroy

Many replacements cause downtime unnecessarily.

Always evaluate whether:

```hcl
create_before_destroy = true
```

is appropriate.

---

# Best Practices

* Protect critical resources with prevent_destroy
* Use create_before_destroy when downtime matters
* Use ignore_changes only when necessary
* Keep lifecycle rules documented
* Test replacement behavior in lower environments
* Review lifecycle settings during code reviews

---

# Real-World Enterprise Pattern

Production Database:

```hcl
lifecycle {

  prevent_destroy = true

}
```

Application Servers:

```hcl
lifecycle {

  create_before_destroy = true

}
```

Resources Managed by Multiple Systems:

```hcl
lifecycle {

  ignore_changes = [

    tags

  ]

}
```

These patterns appear frequently in enterprise Terraform repositories.

---

# Key Takeaways

* lifecycle controls Terraform resource behavior.
* create_before_destroy minimizes downtime.
* prevent_destroy protects critical infrastructure.
* ignore_changes prevents Terraform from managing specific attributes.
* replace_triggered_by forces replacement when related resources change.
* Lifecycle rules are heavily used in production environments.

---

# Meta Arguments Complete

You now understand:

```text
count

for_each

depends_on

lifecycle
```

These four features form the foundation of advanced Terraform resource management.

---

# Next Chapter

Next we begin a major new section:

```text
Terraform State Management
```

This is one of the most important topics in Terraform.

You will learn:

```text
What State Is

State File Structure

State Commands

State Locking

Remote State

Team Collaboration

Backend Configuration
```

Mastering state management is what separates hobby Terraform users from professional infrastructure engineers.
