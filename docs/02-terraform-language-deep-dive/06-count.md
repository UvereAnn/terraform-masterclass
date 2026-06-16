# Count

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand the count Meta Argument
* Create Multiple Resources
* Use count.index
* Build Dynamic Infrastructure
* Conditionally Create Resources
* Understand Count Limitations
* Follow Production Count Patterns
* Know When to Use count vs for_each

---

# Introduction

Normally, Terraform creates one resource from one resource block.

Example:

```hcl
resource "aws_instance" "web" {

  ami           = "ami-123456"

  instance_type = "t3.micro"

}
```

Result:

```text
1 EC2 Instance
```

But what if we need:

```text
3 Instances

10 Instances

50 Instances
```

without copying code?

This is where:

```hcl
count
```

becomes useful.

---

# What is Count?

Count is a Meta Argument that tells Terraform how many instances of a resource to create.

Example:

```hcl
resource "aws_instance" "web" {

  count = 3

  ami           = "ami-123456"

  instance_type = "t3.micro"

}
```

Result:

```text
3 EC2 Instances
```

Terraform creates:

```text
aws_instance.web[0]

aws_instance.web[1]

aws_instance.web[2]
```

automatically.

---

# Why Count Exists

Without count:

```text
Copy

Paste

Copy

Paste
```

Example:

```hcl
resource "aws_instance" "web1" {}

resource "aws_instance" "web2" {}

resource "aws_instance" "web3" {}
```

Problems:

```text
Hard to Maintain

Error Prone

Not Scalable
```

Count solves this.

---

# Basic Count Example

```hcl
resource "aws_instance" "web" {

  count = 3

  ami           = "ami-123456"

  instance_type = "t3.micro"

}
```

Terraform creates:

```text
web[0]

web[1]

web[2]
```

from a single resource definition.

---

# Understanding count.index

Terraform automatically provides:

```hcl
count.index
```

for each resource instance.

Example:

```hcl
resource "aws_instance" "web" {

  count = 3

  ami           = "ami-123456"

  instance_type = "t3.micro"

  tags = {
    Name = "web-${count.index}"
  }

}
```

Generated names:

```text
web-0

web-1

web-2
```

Each instance receives a unique index.

---

# Count Starts at Zero

Count always begins with:

```text
0
```

Example:

```hcl
count = 3
```

Produces:

```text
0

1

2
```

Not:

```text
1

2

3
```

This is important when generating names.

---

# Using Variables with Count

Example:

```hcl
variable "instance_count" {

  type = number

}
```

Resource:

```hcl
resource "aws_instance" "web" {

  count = var.instance_count

}
```

terraform.tfvars:

```hcl
instance_count = 5
```

Result:

```text
5 EC2 Instances
```

Infrastructure becomes dynamic.

---

# Conditional Resource Creation

One of the most common count patterns.

Example:

```hcl
resource "aws_s3_bucket" "logs" {

  count = var.create_bucket ? 1 : 0

}
```

If:

```hcl
create_bucket = true
```

Terraform creates:

```text
1 Bucket
```

If:

```hcl
create_bucket = false
```

Terraform creates:

```text
0 Buckets
```

Resource creation becomes conditional.

---

# Feature Flags

Production example:

```hcl
variable "enable_monitoring" {

  type = bool

}
```

Resource:

```hcl
resource "aws_cloudwatch_log_group" "logs" {

  count = var.enable_monitoring ? 1 : 0

}
```

This pattern is extremely common.

---

# Referencing Counted Resources

Single resource:

```hcl
aws_instance.web.id
```

does not work when count is used.

Terraform creates:

```text
Multiple Instances
```

You must specify:

```hcl
aws_instance.web[0].id
```

or

```hcl
aws_instance.web[count.index].id
```

depending on context.

---

# Output Example

```hcl
output "instance_ids" {

  value = aws_instance.web[*].id

}
```

Result:

```text
List of Instance IDs
```

Terraform returns every ID automatically.

---

# Using Splat Expressions

Example:

```hcl
aws_instance.web[*].id
```

Meaning:

```text
Give me every ID
```

Result:

```hcl
[
  "i-123",
  "i-456",
  "i-789"
]
```

Very useful for outputs.

---

# Count with Lists

Example:

```hcl
variable "subnets" {

  type = list(string)

}
```

Resource:

```hcl
resource "aws_subnet" "private" {

  count = length(var.subnets)

}
```

Terraform creates:

```text
One subnet per list item
```

This pattern appears frequently.

---

# Accessing List Values

Example:

```hcl
resource "aws_subnet" "private" {

  count = length(var.subnets)

  cidr_block = var.subnets[count.index]

}
```

Terraform uses:

```text
Index 0 → First CIDR

Index 1 → Second CIDR

Index 2 → Third CIDR
```

to build resources.

---

# Real Production Example

Variables:

```hcl
variable "availability_zones" {

  type = list(string)

}
```

Resource:

```hcl
resource "aws_subnet" "private" {

  count = length(var.availability_zones)

  availability_zone =
    var.availability_zones[count.index]

}
```

Result:

```text
One Subnet Per Availability Zone
```

A very common pattern.

---

# Count Limitations

Count works well for:

```text
Simple Resource Replication
```

However, it has drawbacks.

---

# Index Shift Problem

Suppose:

```hcl
servers = [
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

Now remove:

```text
api
```

List becomes:

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

Indexes changed.

Terraform may destroy and recreate resources unexpectedly.

This is called:

```text
Index Drift

or

Index Shift
```

and is one of count's biggest weaknesses.

---

# Why for_each Was Introduced

Terraform introduced:

```hcl
for_each
```

to solve count's indexing problems.

We'll cover that next.

---

# Common Beginner Mistakes

## Using Count Everywhere

Count is not always the best solution.

Sometimes:

```hcl
for_each
```

is safer.

---

## Forgetting count.index

Bad:

```hcl
Name = "web"
```

Result:

```text
Every resource gets same name
```

Better:

```hcl
Name = "web-${count.index}"
```

---

## Referencing Counted Resources Incorrectly

Bad:

```hcl
aws_instance.web.id
```

Good:

```hcl
aws_instance.web[0].id
```

or:

```hcl
aws_instance.web[*].id
```

---

# Production Use Cases

Count is commonly used for:

```text
EC2 Instances

Subnets

Availability Zones

Feature Toggles

Conditional Resources

Temporary Infrastructure
```

Count remains useful despite the existence of for_each.

---

# Best Practices

* Use count for identical resources
* Use count for conditional creation
* Use count for feature flags
* Avoid count when resources have unique identities
* Understand index shift risks
* Prefer for_each when managing named resources

---

# Key Takeaways

* Count creates multiple resource instances.
* count.index provides the current resource index.
* Count is useful for resource replication.
* Count supports conditional creation.
* Count can cause index shift problems.
* for_each often provides safer resource management.

---

# Next Chapter

In the next chapter, we will explore for_each.

Many organizations prefer for_each over count because it:

* Uses unique keys
* Prevents index drift
* Scales better
* Improves resource management

for_each is one of the most important Terraform skills for production infrastructure.
