# Dynamic Blocks

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what dynamic blocks are
* Generate nested configuration blocks programmatically
* Replace repetitive Terraform code
* Use for_each inside resource blocks
* Build scalable security groups, IAM policies, and rules
* Understand advanced production patterns using dynamic blocks
* Avoid overusing dynamic blocks unnecessarily

---

# Introduction

In Terraform, most configuration is static:

```hcl
resource "aws_security_group" "web" {

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

}
```

But what if you need multiple rules?

You might do:

```hcl
ingress { ... }
ingress { ... }
ingress { ... }
```

This becomes repetitive and unscalable.

Dynamic blocks solve this problem.

---

# What is a Dynamic Block?

A dynamic block generates repeated nested blocks using expressions.

Syntax:

```hcl
dynamic "BLOCK_NAME" {
  for_each = COLLECTION

  content {
    # block content
  }
}
```

---

# Basic Example

```hcl
variable "ports" {
  type = list(number)
  default = [80, 443]
}
```

```hcl
resource "aws_security_group" "web" {

  dynamic "ingress" {

    for_each = var.ports

    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
    }

  }

}
```

---

# Understanding ingress.value

Inside dynamic blocks:

```text
each item → ingress.value
```

Example:

```text
80
443
```

Terraform generates:

```hcl
ingress {
  from_port = 80
}

ingress {
  from_port = 443
}
```

---

# Dynamic Block Structure

```text
dynamic "name"
 ├── for_each
 └── content
```

Key idea:

```text
Terraform loops over a collection
and generates nested blocks
```

---

# Using Maps in Dynamic Blocks

Example:

```hcl
variable "rules" {
  type = map(number)

  default = {
    http  = 80
    https = 443
  }
}
```

```hcl
resource "aws_security_group" "web" {

  dynamic "ingress" {

    for_each = var.rules

    content {
      description = ingress.key
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
    }

  }

}
```

---

# Understanding ingress.key and ingress.value

With maps:

```text
key   = http / https
value = 80 / 443
```

Terraform generates:

```hcl
ingress {
  description = "http"
  from_port   = 80
}

ingress {
  description = "https"
  from_port   = 443
}
```

---

# Why Dynamic Blocks Matter

Without dynamic blocks:

```hcl
ingress { ... }
ingress { ... }
ingress { ... }
ingress { ... }
```

Problems:

```text
Hard to scale
Hard to maintain
Error-prone
```

With dynamic blocks:

```text
Data-driven infrastructure
Clean configuration
Reusable logic
```

---

# Real-World Example: IAM Policy Statements

```hcl
variable "actions" {
  type = list(string)

  default = ["s3:ListBucket", "s3:GetObject"]
}
```

```hcl
resource "aws_iam_policy" "policy" {

  policy = jsonencode({

    Statement = [

      for action in var.actions : {
        Effect   = "Allow"
        Action   = action
        Resource = "*"
      }

    ]

  })

}
```

Even though this is not a nested block, it shows the same concept: dynamic generation.

---

# Nested Dynamic Blocks

You can nest dynamic blocks.

Example:

```hcl
dynamic "ingress" {

  for_each = var.rules

  content {

    from_port = ingress.value.port

    dynamic "cidr_blocks" {

      for_each = ingress.value.cidrs

      content {
        cidr_block = cidr_blocks.value
      }

    }

  }

}
```

Used in complex networking setups.

---

# When to Use Dynamic Blocks

Use when:

```text
Repeated nested blocks exist
Structure depends on input data
You are building reusable modules
```

Common use cases:

```text
Security Groups
IAM Policies
Kubernetes manifests
Load balancers
Firewall rules
```

---

# When NOT to Use Dynamic Blocks

Avoid when:

```text
Only 1–2 static blocks exist
Readability becomes worse
Simple configuration is enough
```

Bad example:

```hcl
dynamic "ingress" {
  for_each = [80]
}
```

Static is better in such cases.

---

# Common Mistakes

## Overusing dynamic blocks

Bad:

```text
Everything becomes dynamic
Code becomes unreadable
```

---

## Confusing key/value

Remember:

```text
map → key/value
list → value only
```

---

## Using dynamic blocks unnecessarily

If static blocks are clearer, prefer them.

---

# Best Practices

* Use dynamic blocks only when needed
* Prefer static blocks for simplicity
* Use maps for structured rules
* Keep nested dynamics readable
* Avoid deeply nested dynamic blocks
* Document complex dynamic logic

---

# Production Pattern Example

Security Group Module:

```hcl
variable "rules" {
  type = map(object({
    port  = number
    cidrs = list(string)
  }))
}
```

```hcl
resource "aws_security_group" "app" {

  dynamic "ingress" {

    for_each = var.rules

    content {
      from_port = ingress.value.port
      to_port   = ingress.value.port
      protocol  = "tcp"
    }

  }

}
```

This pattern is widely used in enterprise modules.

---

# Key Takeaways

* Dynamic blocks generate nested configuration blocks.
* They use for_each internally.
* Useful for scalable infrastructure definitions.
* Must be used carefully to avoid complexity.
* Best suited for security groups, IAM, and networking.

---

# Next Chapter

Next we move to:

```text
11-complex-data-types
```

You will learn how Terraform models advanced structures like:

```text
map(object)
list(object)
tuple
nested objects
type constraints
```

This is essential for building real production-grade modules.
