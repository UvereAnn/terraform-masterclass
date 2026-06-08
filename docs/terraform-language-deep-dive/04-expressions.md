# Expressions

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Terraform Expressions
* Reference Variables and Resources
* Build Dynamic Values
* Use String Interpolation
* Create Conditional Logic
* Work with Collections
* Use For Expressions
* Create Computed Infrastructure
* Understand Production Expression Patterns

---

# Introduction

An expression is anything that produces a value.

Examples:

```hcl
"dev"
```

```hcl
5
```

```hcl
true
```

```hcl
var.environment
```

```hcl
local.project_name
```

All of these are expressions.

Terraform evaluates expressions and produces values.

---

# Why Expressions Matter

Without expressions:

```text
Static Infrastructure
```

With expressions:

```text
Dynamic Infrastructure
```

Expressions allow Terraform to:

* Calculate values
* Transform inputs
* Build names
* Create logic
* Generate resources dynamically

This is a major part of production Terraform.

---

# Literal Expressions

The simplest expressions.

String:

```hcl
"terraform"
```

Number:

```hcl
10
```

Boolean:

```hcl
true
```

List:

```hcl
[
  "dev",
  "staging",
  "prod"
]
```

Map:

```hcl
{
  environment = "dev"
}
```

Terraform evaluates each expression into a value.

---

# Variable Expressions

Variables are expressions.

Example:

```hcl
var.environment
```

Terraform replaces it with:

```text
dev
```

if:

```hcl
environment = "dev"
```

was provided.

---

# Local Expressions

Example:

```hcl
locals {

  application_name = "inventory"

}
```

Reference:

```hcl
local.application_name
```

Result:

```text
inventory
```

Locals are expressions that simplify configuration.

---

# Resource Attribute Expressions

Terraform can reference resource attributes.

Example:

```hcl
resource "aws_s3_bucket" "logs" {

  bucket = "company-logs"

}
```

Reference:

```hcl
aws_s3_bucket.logs.id
```

Terraform retrieves:

```text
Actual Bucket ID
```

from the resource.

---

# String Interpolation

One of Terraform's most common patterns.

Example:

```hcl
"${var.environment}-app"
```

Result:

```text
dev-app
```

if:

```hcl
environment = "dev"
```

Modern Terraform also allows:

```hcl
"${var.environment}"
```

to be simplified as:

```hcl
var.environment
```

when interpolation is unnecessary.

---

# Building Dynamic Names

Example:

```hcl
locals {

  naming_prefix = "${var.environment}-${var.application}"

}
```

Result:

```text
dev-inventory
```

Usage:

```hcl
bucket = "${local.naming_prefix}-logs"
```

Result:

```text
dev-inventory-logs
```

This pattern is common in production repositories.

---

# Arithmetic Expressions

Terraform supports arithmetic.

Addition:

```hcl
2 + 2
```

Result:

```text
4
```

Multiplication:

```hcl
5 * 3
```

Result:

```text
15
```

Division:

```hcl
10 / 2
```

Result:

```text
5
```

Arithmetic often appears in scaling logic.

---

# Comparison Expressions

Compare values.

Equal:

```hcl
var.environment == "prod"
```

Not Equal:

```hcl
var.environment != "prod"
```

Greater Than:

```hcl
var.replicas > 2
```

Less Than:

```hcl
var.replicas < 10
```

These expressions return:

```text
true

or

false
```

---

# Logical Expressions

AND:

```hcl
var.environment == "prod" &&
var.replicas >= 3
```

OR:

```hcl
var.environment == "prod" ||
var.environment == "staging"
```

NOT:

```hcl
!var.enable_monitoring
```

Logical expressions drive Terraform decisions.

---

# Conditional Expressions

Terraform's ternary operator.

Syntax:

```hcl
condition ? true_value : false_value
```

Example:

```hcl
var.environment == "prod"
? "t3.large"
: "t3.micro"
```

Result:

```text
prod    → t3.large

others  → t3.micro
```

Extremely common in production code.

---

# Conditional Resource Values

Example:

```hcl
instance_type =
var.environment == "prod"
? "t3.large"
: "t3.micro"
```

One configuration.

Multiple behaviors.

---

# Collection Expressions

Terraform can access collection items.

List:

```hcl
var.subnets[0]
```

Result:

```text
First subnet
```

Map:

```hcl
var.tags["Environment"]
```

Result:

```text
dev
```

Objects:

```hcl
var.application.name
```

Result:

```text
inventory
```

---

# For Expressions

For expressions transform collections.

Example:

```hcl
[
  for name in var.names :
  upper(name)
]
```

Input:

```hcl
[
  "web",
  "api"
]
```

Output:

```hcl
[
  "WEB",
  "API"
]
```

Terraform generated the new collection automatically.

---

# For Expression with Objects

Example:

```hcl
[
  for server in var.servers :
  server.name
]
```

Input:

```hcl
servers = [
  {
    name = "web"
  },
  {
    name = "api"
  }
]
```

Output:

```hcl
[
  "web",
  "api"
]
```

Very common in advanced modules.

---

# Filtering with For Expressions

Example:

```hcl
[
  for server in var.servers :
  server.name
  if server.enabled
]
```

Only enabled servers appear.

Powerful and frequently used.

---

# Expression Evaluation

Terraform evaluates expressions during:

```text
terraform plan
```

and

```text
terraform apply
```

Some values are known immediately.

Others become known after resource creation.

Example:

```hcl
aws_instance.web.id
```

may not exist until deployment.

Terraform handles these dependencies automatically.

---

# Production Example

Variables:

```hcl
variable "environment" {
  type = string
}
```

Locals:

```hcl
locals {

  instance_type =
    var.environment == "prod"
    ? "t3.large"
    : "t3.micro"

}
```

Resource:

```hcl
resource "aws_instance" "web" {

  instance_type = local.instance_type

}
```

One codebase.

Multiple environments.

---

# Common Beginner Mistakes

## Hardcoding Values

Bad:

```hcl
instance_type = "t3.micro"
```

Better:

```hcl
instance_type =
var.environment == "prod"
? "t3.large"
: "t3.micro"
```

---

## Overcomplicated Expressions

Bad:

```text
Huge nested expressions
```

If logic becomes difficult to read:

Use:

```hcl
locals {}
```

instead.

---

## Repeating Expressions

Bad:

```hcl
"${var.environment}-${var.application}"
```

everywhere.

Better:

```hcl
locals {

  naming_prefix =
  "${var.environment}-${var.application}"

}
```

Reuse:

```hcl
local.naming_prefix
```

---

# Best Practices

* Keep expressions readable
* Use locals for complex logic
* Avoid duplication
* Use conditionals sparingly
* Prefer clear naming
* Test expressions using terraform console

---

# Using Terraform Console

The console is excellent for learning expressions.

Run:

```bash
terraform console
```

Example:

```bash
> upper("terraform")
```

Output:

```text
TERRAFORM
```

Example:

```bash
> 5 * 10
```

Output:

```text
50
```

A great way to experiment safely.

---

# Key Takeaways

* Expressions produce values.
* Variables, locals, and resources are all expressions.
* Terraform supports arithmetic and logical operations.
* Conditional expressions enable dynamic behavior.
* For expressions transform collections.
* Expressions are foundational to advanced Terraform.

---

# Next Chapter

In the next chapter, we will explore Functions.

Functions allow Terraform to:

* Manipulate strings
* Transform collections
* Read files
* Parse JSON
* Encode data
* Generate dynamic values

Functions are used everywhere in production Terraform and are one of the most important skills to master.
