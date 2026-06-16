# Variable Types

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Terraform's type system
* Use primitive types
* Use collection types
* Use structural types
* Design strongly typed variables
* Create complex input structures
* Build reusable modules using advanced types
* Avoid common type-related mistakes

---

# Introduction

Terraform is a strongly typed language.

Every value has a type.

Examples:

```text id="1v8fdw"
"dev"        → string

5            → number

true         → bool
```

Terraform uses types to:

* Validate inputs
* Prevent mistakes
* Improve module design
* Increase predictability

Strong typing is a major reason Terraform scales well in large environments.

---

# Why Types Matter

Without types:

```text id="hpnm5w"
Users can provide anything
```

With types:

```text id="j6j3o9"
Terraform validates inputs automatically
```

Example:

```hcl id="q4w5ex"
variable "instance_count" {
  type = number
}
```

Valid:

```text id="f7ydtz"
3
```

Invalid:

```text id="hax0px"
"three"
```

Terraform fails before deployment.

---

# Terraform Type Categories

Terraform types fall into three groups:

```text id="5kl6ut"
Primitive Types

Collection Types

Structural Types
```

---

# Primitive Types

The simplest Terraform types.

---

# String

Represents text values.

Example:

```hcl id="s4cq6j"
variable "environment" {
  type = string
}
```

Valid values:

```text id="p1y1pi"
dev

staging

prod
```

Usage:

```hcl id="7e8e3x"
var.environment
```

Strings are the most common Terraform type.

---

# Number

Represents numeric values.

Example:

```hcl id="vhllbw"
variable "instance_count" {
  type = number
}
```

Valid:

```text id="czcz1v"
1

5

100
```

Usage:

```hcl id="r0uz2t"
count = var.instance_count
```

Numbers can be integers or decimals.

---

# Bool

Represents true/false values.

Example:

```hcl id="0kzc3f"
variable "enable_monitoring" {
  type = bool
}
```

Valid:

```text id="r29h0k"
true

false
```

Usage:

```hcl id="nknz4w"
monitoring = var.enable_monitoring
```

Frequently used for feature toggles.

---

# Collection Types

Collection types store multiple values.

---

# List

An ordered collection.

Example:

```hcl id="tkk5o0"
variable "availability_zones" {
  type = list(string)
}
```

Value:

```hcl id="kq3pva"
[
  "eu-west-1a",
  "eu-west-1b",
  "eu-west-1c"
]
```

Access:

```hcl id="s3r9n4"
var.availability_zones[0]
```

Result:

```text id="9xax0r"
eu-west-1a
```

Lists preserve order.

---

# Set

An unordered collection of unique values.

Example:

```hcl id="e99y8w"
variable "security_groups" {
  type = set(string)
}
```

Value:

```hcl id="kkvkzj"
[
  "web",
  "app",
  "db"
]
```

Characteristics:

```text id="2wrtpg"
No duplicates

No guaranteed order
```

Sets are useful when uniqueness matters.

---

# Map

A collection of key-value pairs.

Example:

```hcl id="rx9c5q"
variable "tags" {
  type = map(string)
}
```

Value:

```hcl id="bj06t8"
{
  Environment = "dev"
  Team        = "Platform"
}
```

Access:

```hcl id="c31yb7"
var.tags["Environment"]
```

Result:

```text id="l7n4o5"
dev
```

Maps are heavily used for tags and configuration settings.

---

# Structural Types

Structural types describe complex objects.

These are extremely important in production Terraform.

---

# Object

An object defines a structure.

Example:

```hcl id="7fxszi"
variable "server" {

  type = object({
    name          = string
    instance_type = string
    monitoring    = bool
  })

}
```

Value:

```hcl id="o3q7rt"
server = {
  name          = "web"
  instance_type = "t3.micro"
  monitoring    = true
}
```

Access:

```hcl id="yozwlu"
var.server.name
```

Result:

```text id="m4dr4u"
web
```

Objects are used extensively in modules.

---

# Tuple

A fixed-length collection with defined types.

Example:

```hcl id="9z7t2l"
variable "server_info" {
  type = tuple([
    string,
    number,
    bool
  ])
}
```

Value:

```hcl id="3xavgu"
[
  "web",
  2,
  true
]
```

Access:

```hcl id="9qjyz7"
var.server_info[0]
```

Result:

```text id="w8t4cw"
web
```

Tuples are less common than objects.

---

# Nested Objects

Objects can contain other objects.

Example:

```hcl id="0sujmf"
variable "application" {

  type = object({

    name = string

    database = object({
      engine = string
      port   = number
    })

  })

}
```

Value:

```hcl id="uyk11n"
application = {

  name = "inventory"

  database = {
    engine = "postgres"
    port   = 5432
  }

}
```

Access:

```hcl id="pqqtf4"
var.application.database.engine
```

Result:

```text id="n0wyxj"
postgres
```

Nested structures appear frequently in enterprise modules.

---

# List of Objects

One of the most important Terraform patterns.

Variable:

```hcl id="kegqq4"
variable "servers" {

  type = list(object({

    name = string

    size = string

  }))

}
```

Value:

```hcl id="uh71p7"
servers = [

  {
    name = "web"
    size = "t3.micro"
  },

  {
    name = "api"
    size = "t3.small"
  }

]
```

This pattern is used extensively with:

```text id="fnpn0w"
for_each

dynamic blocks

modules
```

---

# Map of Objects

Another production pattern.

Variable:

```hcl id="aw4p5h"
variable "environments" {

  type = map(object({

    instance_type = string

    replicas = number

  }))

}
```

Value:

```hcl id="u9y70e"
environments = {

  dev = {
    instance_type = "t3.micro"
    replicas      = 1
  }

  prod = {
    instance_type = "t3.large"
    replicas      = 3
  }

}
```

Extremely useful for environment-specific infrastructure.

---

# Type Constraints

Terraform validates types automatically.

Example:

```hcl id="z6xzys"
variable "replicas" {
  type = number
}
```

Invalid:

```hcl id="hknjlwm"
replicas = "five"
```

Terraform fails immediately.

This prevents many deployment errors.

---

# Common Production Examples

Tags:

```hcl id="0s8y9j"
variable "tags" {
  type = map(string)
}
```

---

Subnets:

```hcl id="eznm18"
variable "subnets" {
  type = list(string)
}
```

---

Application Configuration:

```hcl id="uv5z8u"
variable "application" {

  type = object({

    name     = string
    version  = string
    replicas = number

  })

}
```

These patterns appear repeatedly in production repositories.

---

# Common Beginner Mistakes

## Using string for Everything

Bad:

```hcl id="1ldpij"
variable "instance_count" {
  type = string
}
```

Good:

```hcl id="lg8bgm"
variable "instance_count" {
  type = number
}
```

---

## Avoiding Objects

Beginners often create many separate variables.

Better:

```hcl id="3l85y0"
variable "database" {

  type = object({
    engine = string
    port   = number
  })

}
```

Related settings stay together.

---

## Using list Instead of set

If order doesn't matter and uniqueness matters:

Use:

```hcl id="s55f3w"
set(string)
```

instead.

---

# Best Practices

* Always specify types
* Use objects for related values
* Use maps for configurations
* Use lists for ordered collections
* Use sets for unique collections
* Keep structures logical
* Design module inputs carefully

---

# Real-World Enterprise Pattern

Many enterprise modules expose a single object variable:

```hcl id="t9yqxo"
variable "application" {

  type = object({

    name        = string
    environment = string
    owner       = string

  })

}
```

Instead of dozens of independent variables.

This improves readability and scalability.

---

# Key Takeaways

* Terraform is strongly typed.
* Primitive types are string, number, and bool.
* Collection types are list, set, and map.
* Structural types are object and tuple.
* Objects are heavily used in production modules.
* Lists of objects and maps of objects are common enterprise patterns.
* Strong typing improves reliability and maintainability.

---

# Next Chapter

In the next chapter, we will explore Variable Validation.

We will learn how to enforce rules, prevent invalid deployments, and create self-validating Terraform configurations.
