# Outputs

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what Outputs are
* Create Output blocks
* Reference Resource Attributes in Outputs
* Use Outputs with Data Sources
* Mark Outputs as Sensitive
* Understand Module Outputs
* Follow Output Best Practices

---

# What are Outputs?

Outputs expose information from Terraform configurations.

Think of Outputs as:

```text
Values Terraform returns after execution
```

Examples:

* EC2 Instance IDs
* Public IP Addresses
* VPC IDs
* S3 Bucket Names
* AWS Account IDs
* Database Endpoints

Outputs make this information accessible after Terraform finishes.

---

# Why Outputs Matter

Suppose Terraform creates:

```hcl
resource "aws_instance" "web" {
  ...
}
```

How do you find:

```text
Public IP
Instance ID
Private IP
```

Terraform already knows these values.

Outputs allow Terraform to display them.

---

# Output Block Syntax

General syntax:

```hcl
output "name" {
  value = expression
}
```

Example:

```hcl
output "bucket_name" {
  value = aws_s3_bucket.logs.bucket
}
```

---

# Simple Output Example

Resource:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

Output:

```hcl
output "bucket_name" {
  value = aws_s3_bucket.logs.bucket
}
```

Terraform returns:

```text
bucket_name = company-logs
```

---

# Output Names

Example:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

Here:

```text
vpc_id
```

is simply a Terraform identifier.

Choose meaningful names.

---

# Output Values

Outputs can expose:

### Resource Attributes

```hcl
output "instance_id" {
  value = aws_instance.web.id
}
```

---

### Data Source Attributes

```hcl
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

---

### Variables

```hcl
output "environment" {
  value = var.environment
}
```

---

### Locals

```hcl
output "project_name" {
  value = local.project_name
}
```

---

### Expressions

```hcl
output "full_name" {
  value = "${var.environment}-web"
}
```

Outputs can expose almost any Terraform expression.

---

# Viewing Outputs

After:

```bash
terraform apply
```

Terraform displays:

```text
Outputs:

environment = "dev"
project_name = "dev-web"
```

---

# terraform output Command

Outputs can be retrieved later.

Example:

```bash
terraform output
```

Result:

```text
environment = "dev"
project_name = "dev-web"
```

---

# Retrieve a Specific Output

Example:

```bash
terraform output project_name
```

Result:

```text
dev-web
```

---

# JSON Output

Useful for automation:

```bash
terraform output -json
```

Example result:

```json
{
  "project_name": {
    "value": "dev-web"
  }
}
```

Frequently used in CI/CD pipelines.

---

# Sensitive Outputs

Sometimes outputs contain secrets.

Examples:

* Database passwords
* API keys
* Tokens

Mark them as sensitive.

Example:

```hcl
output "database_password" {
  value     = var.database_password
  sensitive = true
}
```

Terraform hides the value from standard output.

---

# Output Dependencies

Outputs can depend on resources.

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}

output "bucket_name" {
  value = aws_s3_bucket.logs.bucket
}
```

Terraform creates the bucket first and then resolves the output.

---

# Multiple Outputs

Example:

```hcl
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  value = data.aws_region.current.name
}

output "environment" {
  value = var.environment
}
```

Large projects often expose many outputs.

---

# Outputs and Modules

Outputs become especially important with modules.

Module:

```hcl
module "network" {
  source = "./modules/network"
}
```

Module output:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

Usage:

```hcl
module.network.vpc_id
```

This is how modules share information.

---

# Common Real-World Outputs

## VPC ID

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

---

## Public Subnet IDs

```hcl
output "public_subnet_ids" {
  value = aws_subnets.public.ids
}
```

---

## EC2 Public IP

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

---

## Database Endpoint

```hcl
output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}
```

---

## Account ID

```hcl
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

---

# Common Beginner Mistakes

## Exposing Secrets

Bad:

```hcl
output "password" {
  value = var.database_password
}
```

Always use:

```hcl
sensitive = true
```

for secret values.

---

## Meaningless Names

Bad:

```hcl
output "test" {

}
```

Good:

```hcl
output "vpc_id" {

}
```

---

## Too Many Outputs

Expose only useful information.

Avoid cluttering configurations.

---

# Best Practices

* Use descriptive output names
* Mark secrets as sensitive
* Expose information that consumers actually need
* Keep outputs focused
* Use outputs extensively in modules

---

# Key Takeaways

* Outputs expose information from Terraform configurations.
* Outputs can reference resources, data sources, variables, locals, and expressions.
* terraform output retrieves values after deployment.
* Sensitive outputs should be marked appropriately.
* Outputs are essential for module communication.

---

# Next Chapter

In the next chapter, we will explore Locals.

Locals help reduce duplication, simplify expressions, and make Terraform configurations easier to maintain.
