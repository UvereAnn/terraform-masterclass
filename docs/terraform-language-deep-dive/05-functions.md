# Functions

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Terraform Functions
* Use String Functions
* Use Collection Functions
* Use File Functions
* Use Encoding Functions
* Transform Data Efficiently
* Build Dynamic Configurations
* Apply Production Terraform Function Patterns

---

# Introduction

Functions are built-in operations that accept input and return output.

Example:

```hcl
upper("terraform")
```

Result:

```text
TERRAFORM
```

Terraform contains dozens of useful functions.

Functions are heavily used for:

* Naming
* Tagging
* Configuration generation
* Data transformation
* File processing
* JSON handling

---

# Function Syntax

General syntax:

```hcl
function_name(argument1, argument2)
```

Example:

```hcl
upper("terraform")
```

Terraform evaluates:

```text
Input → Function → Output
```

---

# Categories of Functions

Common categories:

```text
String Functions

Collection Functions

Numeric Functions

File Functions

Encoding Functions

Date Functions

Network Functions
```

We'll focus on the functions most commonly used in production Terraform.

---

# String Functions

String functions manipulate text.

---

# upper()

Converts text to uppercase.

Example:

```hcl
upper("terraform")
```

Result:

```text
TERRAFORM
```

Useful for standardized naming.

---

# lower()

Converts text to lowercase.

Example:

```hcl
lower("PRODUCTION")
```

Result:

```text
production
```

Commonly used for resource names.

---

# title()

Capitalizes words.

Example:

```hcl
title("terraform masterclass")
```

Result:

```text
Terraform Masterclass
```

Useful for display values.

---

# replace()

Replaces text.

Example:

```hcl
replace("dev-web", "-", "_")
```

Result:

```text
dev_web
```

Frequently used when naming standards differ.

---

# substr()

Extracts a portion of a string.

Example:

```hcl
substr("terraform", 0, 4)
```

Result:

```text
terr
```

Useful when resource names have length limits.

---

# trim()

Removes unwanted characters.

Example:

```hcl
trim("  terraform  ", " ")
```

Result:

```text
terraform
```

Useful when processing external data.

---

# Collection Functions

Collection functions work with lists, sets, maps, and objects.

---

# length()

Returns collection size.

Example:

```hcl
length([
  "web",
  "api",
  "db"
])
```

Result:

```text
3
```

Commonly used for validation and scaling.

---

# contains()

Checks whether a collection contains a value.

Example:

```hcl
contains(
  ["dev", "staging", "prod"],
  "prod"
)
```

Result:

```text
true
```

Often used in validation rules.

---

# join()

Combines values into a string.

Example:

```hcl
join(
  "-",
  ["dev", "inventory"]
)
```

Result:

```text
dev-inventory
```

Very common in naming conventions.

---

# split()

Splits a string into a list.

Example:

```hcl
split(
  "-",
  "dev-inventory"
)
```

Result:

```hcl
[
  "dev",
  "inventory"
]
```

Useful when parsing values.

---

# concat()

Combines multiple lists.

Example:

```hcl
concat(
  ["web"],
  ["api"],
  ["db"]
)
```

Result:

```hcl
[
  "web",
  "api",
  "db"
]
```

Common in module inputs.

---

# distinct()

Removes duplicates.

Example:

```hcl
distinct([
  "web",
  "api",
  "web"
])
```

Result:

```hcl
[
  "web",
  "api"
]
```

Useful for cleaning data.

---

# sort()

Sorts a collection.

Example:

```hcl
sort([
  "db",
  "web",
  "api"
])
```

Result:

```hcl
[
  "api",
  "db",
  "web"
]
```

Useful for deterministic outputs.

---

# lookup()

Retrieves values from maps.

Variable:

```hcl
{
  dev  = "t3.micro"
  prod = "t3.large"
}
```

Expression:

```hcl
lookup(
  var.instance_types,
  "prod",
  "t3.micro"
)
```

Result:

```text
t3.large
```

The third argument is the default value.

Very common in production Terraform.

---

# merge()

Combines maps.

Example:

```hcl
merge(
  {
    Environment = "dev"
  },
  {
    Team = "Platform"
  }
)
```

Result:

```hcl
{
  Environment = "dev"
  Team        = "Platform"
}
```

Extremely common for tag management.

---

# File Functions

Terraform can read external files.

---

# file()

Reads a file.

Example:

```hcl
file("startup.sh")
```

Terraform returns the file contents.

Useful for:

* User data
* Scripts
* Configuration files

---

# templatefile()

Reads a template and injects variables.

Template:

```text
Hello ${name}
```

Terraform:

```hcl
templatefile(
  "template.txt",
  {
    name = "Terraform"
  }
)
```

Result:

```text
Hello Terraform
```

Widely used for EC2 user-data scripts.

---

# Encoding Functions

Used heavily in cloud automation.

---

# jsonencode()

Converts Terraform data into JSON.

Example:

```hcl
jsonencode({
  environment = "dev"
})
```

Result:

```json
{
  "environment": "dev"
}
```

Useful for:

* IAM policies
* Kubernetes manifests
* API payloads

---

# jsondecode()

Converts JSON into Terraform data.

Example:

```hcl
jsondecode(
  file("config.json")
)
```

Terraform can now access:

```hcl
local.config.environment
```

Useful when external systems provide JSON.

---

# yamlencode()

Converts Terraform data into YAML.

Example:

```hcl
yamlencode({
  app = "inventory"
})
```

Common in Kubernetes deployments.

---

# yamldecode()

Reads YAML files into Terraform.

Example:

```hcl
yamldecode(
  file("config.yaml")
)
```

Useful in cloud-native environments.

---

# Numeric Functions

Useful for calculations.

---

# max()

Example:

```hcl
max(5, 10, 20)
```

Result:

```text
20
```

---

# min()

Example:

```hcl
min(5, 10, 20)
```

Result:

```text
5
```

---

# ceil()

Rounds up.

Example:

```hcl
ceil(2.3)
```

Result:

```text
3
```

---

# floor()

Rounds down.

Example:

```hcl
floor(2.9)
```

Result:

```text
2
```

---

# Common Production Examples

Dynamic Naming:

```hcl
join(
  "-",
  [
    var.environment,
    var.application
  ]
)
```

Result:

```text
dev-inventory
```

---

Tag Merging:

```hcl
merge(
  local.common_tags,
  {
    Application = "inventory"
  }
)
```

---

Environment Lookup:

```hcl
lookup(
  var.instance_types,
  var.environment
)
```

---

JSON Policy Generation:

```hcl
jsonencode({
  Version = "2012-10-17"
})
```

---

# Using Functions in Locals

A common pattern:

```hcl
locals {

  naming_prefix = lower(
    join(
      "-",
      [
        var.environment,
        var.application
      ]
    )
  )

}
```

Result:

```text
dev-inventory
```

Locals often combine multiple functions.

---

# Common Beginner Mistakes

## Ignoring Functions

Bad:

```hcl
bucket = "dev-inventory"
```

Better:

```hcl
bucket = join(
  "-",
  [
    var.environment,
    var.application
  ]
)
```

---

## Hardcoding JSON

Bad:

```hcl
policy = "{ ... }"
```

Good:

```hcl
policy = jsonencode(...)
```

---

## Repeating Transformations

Bad:

```hcl
lower(var.environment)
```

everywhere.

Better:

```hcl
locals {
  environment = lower(var.environment)
}
```

Reuse the local.

---

# Best Practices

* Prefer functions over hardcoding
* Use lookup() for environment mappings
* Use merge() for tags
* Use jsonencode() for policies
* Use templatefile() for scripts
* Use locals to simplify complex expressions
* Keep function chains readable

---

# Key Takeaways

* Functions transform data.
* String functions manipulate text.
* Collection functions manipulate lists and maps.
* File functions process external files.
* Encoding functions work with JSON and YAML.
* Functions are used heavily in production Terraform.
* Mastering functions significantly improves Terraform skills.

---

# Next Chapter

In the next chapter, we will explore Count.

Count is Terraform's first resource replication mechanism and allows infrastructure to be created dynamically based on input values.

This introduces a powerful concept:

```text
One Resource Definition

Many Resource Instances
```

which is heavily used in real-world Terraform projects.
