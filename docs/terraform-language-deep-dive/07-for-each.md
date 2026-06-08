# for_each

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand for_each
* Use Maps with for_each
* Use Sets with for_each
* Access each.key and each.value
* Create Dynamic Infrastructure
* Avoid Index Drift
* Understand Production for_each Patterns
* Know When to Use for_each vs count

---

# Introduction

In the previous chapter we learned:

```hcl
count = 3
```

Terraform created:

```text
resource[0]

resource[1]

resource[2]
```

This works.

However, indexes can change.

Example:

Initial list:

```hcl
[
  "web",
  "api",
  "db"
]
```

Terraform creates:

```text
web → [0]

api → [1]

db → [2]
```

Later:

```hcl
[
  "web",
  "db"
]
```

Terraform now sees:

```text
web → [0]

db → [1]
```

The index changed.

Terraform may destroy and recreate resources.

This is one of the biggest risks of count.

---

# What is for_each?

for_each creates resources using unique keys.

Instead of:

```text
resource[0]
```

Terraform creates:

```text
resource["web"]

resource["api"]

resource["db"]
```

Keys remain stable.

Resources become safer to manage.

---

# Basic for_each Example

Example:

```hcl
resource "aws_instance" "server" {

  for_each = toset([
    "web",
    "api",
    "db"
  ])

}
```

Terraform creates:

```text
aws_instance.server["web"]

aws_instance.server["api"]

aws_instance.server["db"]
```

No indexes involved.

---

# Using Sets

A common pattern:

```hcl
toset([
  "web",
  "api",
  "db"
])
```

Result:

```text
Set of Unique Values
```

Terraform can iterate over the set.

---

# Understanding each.key

Terraform provides:

```hcl
each.key
```

Example:

```hcl
resource "aws_instance" "server" {

  for_each = toset([
    "web",
    "api",
    "db"
  ])

  tags = {
    Name = each.key
  }

}
```

Generated:

```text
web

api

db
```

Each resource receives its own value.

---

# each.value

For sets:

```hcl
each.key

and

each.value
```

are identical.

Example:

```hcl
each.key
```

Result:

```text
web
```

and

```hcl
each.value
```

Result:

```text
web
```

With maps, they differ.

---

# Using Maps with for_each

This is where for_each becomes powerful.

Example:

```hcl
variable "servers" {

  type = map(string)

  default = {

    web = "t3.micro"

    api = "t3.small"

    db  = "t3.medium"

  }

}
```

Resource:

```hcl
resource "aws_instance" "server" {

  for_each = var.servers

  instance_type = each.value

  tags = {
    Name = each.key
  }

}
```

Terraform creates:

```text
web → t3.micro

api → t3.small

db → t3.medium
```

---

# Understanding each.key

Using:

```hcl
each.key
```

Returns:

```text
web

api

db
```

The map key.

---

# Understanding each.value

Using:

```hcl
each.value
```

Returns:

```text
t3.micro

t3.small

t3.medium
```

The map value.

---

# Why for_each is Safer

Initial map:

```hcl
{
  web = "t3.micro"
  api = "t3.small"
  db  = "t3.medium"
}
```

Terraform creates:

```text
server["web"]

server["api"]

server["db"]
```

Now remove:

```text
api
```

Terraform sees:

```text
server["web"]

server["db"]
```

Only:

```text
server["api"]
```

is removed.

Everything else stays untouched.

No index shifting.

No unnecessary recreation.

---

# Creating Multiple Subnets

Production example:

```hcl
variable "subnets" {

  type = map(string)

}
```

Example value:

```hcl
subnets = {

  private-a = "10.0.1.0/24"

  private-b = "10.0.2.0/24"

  private-c = "10.0.3.0/24"

}
```

Resource:

```hcl
resource "aws_subnet" "private" {

  for_each = var.subnets

  cidr_block = each.value

}
```

Terraform creates one subnet per map entry.

---

# for_each with Objects

Extremely common.

Variable:

```hcl
variable "servers" {

  type = map(object({

    instance_type = string

    monitoring = bool

  }))

}
```

Value:

```hcl
servers = {

  web = {
    instance_type = "t3.micro"
    monitoring    = true
  }

  api = {
    instance_type = "t3.small"
    monitoring    = true
  }

}
```

Resource:

```hcl
resource "aws_instance" "server" {

  for_each = var.servers

  instance_type = each.value.instance_type

}
```

This pattern appears everywhere in enterprise Terraform.

---

# Referencing for_each Resources

Example:

```hcl
aws_instance.server["web"].id
```

Returns:

```text
Web Server ID
```

Specific resources can be accessed by key.

---

# Output Example

```hcl
output "instance_ids" {

  value = {
    for k, v in aws_instance.server :
    k => v.id
  }

}
```

Result:

```hcl
{
  web = "i-123"
  api = "i-456"
}
```

Very useful in modules.

---

# Conditional Creation with for_each

Example:

```hcl
resource "aws_s3_bucket" "logs" {

  for_each =
    var.enable_logs
    ? { logs = true }
    : {}

}
```

Enabled:

```text
Creates Resource
```

Disabled:

```text
Creates Nothing
```

Alternative to count.

---

# Count vs for_each

Count:

```hcl
count = 3
```

Creates:

```text
resource[0]

resource[1]

resource[2]
```

---

for_each:

```hcl
for_each = {
  web = "small"
  api = "medium"
}
```

Creates:

```text
resource["web"]

resource["api"]
```

Stable identities.

---

# When to Use Count

Use count when:

```text
Resources are identical

Resources do not require unique identities

Feature toggles are needed

Simple replication is sufficient
```

Examples:

```text
3 identical instances

Enable or disable a feature
```

---

# When to Use for_each

Use for_each when:

```text
Resources have names

Resources have different settings

Resources need stable identities

Managing maps or objects
```

Examples:

```text
Subnets

Servers

IAM Users

Security Groups

Route Tables
```

---

# Common Beginner Mistakes

## Using Lists Directly

Bad:

```hcl
for_each = [
  "web",
  "api"
]
```

Terraform expects:

```hcl
toset(...)
```

or:

```hcl
map(...)
```

instead.

---

## Confusing each.key and each.value

Remember:

```text
each.key   = Identifier

each.value = Data
```

---

## Using Count When Resources Have Names

Bad:

```hcl
count = length(var.servers)
```

Better:

```hcl
for_each = var.servers
```

Named resources should generally use for_each.

---

# Production Use Cases

for_each is commonly used for:

```text
Subnets

EC2 Instances

IAM Users

IAM Roles

Security Groups

S3 Buckets

DNS Records

Kubernetes Resources
```

Many enterprise repositories heavily prefer for_each.

---

# Best Practices

* Prefer for_each for named resources
* Use maps whenever possible
* Use objects for complex configurations
* Avoid count when identities matter
* Use meaningful keys
* Design modules around maps and objects

---

# Key Takeaways

* for_each creates resources using keys.
* Keys remain stable over time.
* for_each avoids index drift.
* each.key identifies the resource.
* each.value contains the resource data.
* for_each is preferred in many production environments.
* Maps and objects work particularly well with for_each.

---

# Next Chapter

In the next chapter, we will explore depends_on.

Terraform normally builds a dependency graph automatically.

However, there are situations where we must explicitly tell Terraform:

```text
Create This First

Then Create That
```

This is where depends_on becomes essential.
