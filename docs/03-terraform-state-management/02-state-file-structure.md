# Terraform State File Structure

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand the structure of terraform.tfstate
* Read state file JSON
* Understand resources and instances
* Understand state metadata
* Understand Terraform state lineage
* Understand dependencies stored in state
* Troubleshoot state-related problems

---

# Introduction

In the previous chapter, we learned:

```text
Terraform State = Terraform's memory
```

Now we go deeper.

A Terraform state file is a JSON document.

Default:

```text
terraform.tfstate
```

Example:

```json
{
  "version": 4,
  "terraform_version": "1.8.0",
  "serial": 1,
  "lineage": "abc123"
}
```

Terraform uses this information to manage infrastructure safely.

---

# Viewing State

After applying infrastructure:

```bash
terraform apply
```

You can inspect:

```bash
cat terraform.tfstate
```

or:

```bash
code terraform.tfstate
```

---

# Basic State Structure

A Terraform state file contains:

```text
version

terraform_version

serial

lineage

outputs

resources
```

---

# Version

Example:

```json
{
  "version": 4
}
```

This represents the state format version.

Terraform uses this to understand how to read the file.

---

# Terraform Version

Example:

```json
{
  "terraform_version": "1.8.0"
}
```

This records which Terraform version created the state.

Important for:

* Troubleshooting
* Upgrades
* Compatibility

---

# Serial Number

Example:

```json
{
  "serial": 5
}
```

Every successful state change increases the serial number.
The serial is a simple counter that tracks how many times the state has been changed.

Every time Terraform successfully modifies the state (like after terraform apply, terraform refresh, or terraform import), it increments this number by 1.

Example:

Initial:

```text
serial = 1
```

After apply:

```text
serial = 2
```

---

# Lineage

Example:

```json
{
  "lineage": "7f83abc..."
}
```

Lineage identifies a unique state file.
Lineage is a unique identifier (a UUID) assigned to a state file when it's first created. It stays with that state file forever, even if the serial number changes many times.

Think of it like a DNA fingerprint or a birth certificate number for your state.

It helps Terraform detect:

* Different state files
* Accidental replacements
* State mismatches

---

# Outputs Section

The outputs section in a Terraform state file stores the values of any output blocks defined in your configuration.

Example Terraform:

```hcl
output "instance_id" {
  value = aws_instance.web.id
}
```

State stores:

```json
"outputs": {
  "instance_id": {
    "value": "i-123456",
    "type": "string"
  }
}
```

---

# Resources Section

This is the most important part.
It's the heart of the state file — it lists everything Terraform is managing.

Example:

```json
"resources": [
 {
   "type": "aws_instance",
   "name": "web"
 }
]
```

Terraform stores every managed resource here.

---

# Resource Structure

Example:

```json
{
 "mode": "managed",
 "type": "aws_instance",
 "name": "web",
 "provider": "provider.aws"
}
```

Meaning:

```text
mode
  ↓
managed resource

type
  ↓
resource type

name
  ↓
resource label

provider
  ↓
provider managing it
```

---

# Instances

A resource can contain instances.

Example:

```json
"instances": [
 {
   "attributes": {}
 }
]
```

Why?

Because resources can use:

```text
count

for_each
```

Example:

```hcl
resource "aws_instance" "web" {

 count = 3

}
```

Creates:

```text
web[0]

web[1]

web[2]
```

State tracks each instance.

---

# Attributes

State stores actual values.

Example:

Terraform:

```hcl
resource "aws_instance" "web" {

instance_type = "t3.micro"

}
```

State:

```json
{
 "instance_type": "t3.micro"
}
```

Terraform compares:

```text
Configuration

against

State
```

---

# Provider Information

State records which provider manages resources.

Example:

```json
"provider":
"registry.terraform.io/hashicorp/aws"
```

This prevents confusion.

---

# Dependencies

Terraform builds dependency relationships.

Example:

```hcl
resource "aws_instance" "web" {

 depends_on = [
 aws_security_group.web
 ]

}
```

Terraform understands:

```text
Security Group

↓

EC2 Instance
```

---

# Example State Flow

Terraform code:

```hcl
resource "aws_s3_bucket" "logs" {}
```

State stores:

```text
Resource:

aws_s3_bucket.logs

ID:

terraform-example-bucket
```

Now Terraform knows:

```text
This bucket already exists.
```

---

# Terraform State Is a Mapping Database

Think of state as:

```text
Terraform Resource Name

        ↓

Real Cloud Resource ID
```

Example:

```text
aws_instance.web

        ↓

i-0abc123456
```

---

# Why Understanding State Matters

When something breaks:

Example:

```text
terraform plan shows replacement
```

You need to understand:

* What Terraform knows
* What exists
* What changed

State knowledge helps diagnose problems.

---

# Common State Problems

## Missing Resource

Terraform says:

```text
Create resource
```

but it exists.

Possible cause:

```text
Resource missing from state
```

---

## Wrong State

Terraform manages:

```text
Wrong AWS Account
```

Possible cause:

```text
Incorrect backend
Incorrect provider
```

---

## Drift

Someone manually changes:

```text
AWS Console
```

State becomes different from reality.

Terraform detects this.

---

# Inspecting State Safely

Use:

```bash
terraform show
```

Example:

```bash
terraform show terraform.tfstate
```

Better than manually editing.

---

# Best Practices

* Never edit state JSON manually
* Use Terraform commands
* Understand resource addresses
* Keep Terraform versions consistent
* Protect state files

---

# Key Takeaways

* terraform.tfstate is JSON
* State stores infrastructure mappings
* Resources contain instances
* Outputs are stored in state
* Providers are recorded
* State enables Terraform tracking

---

# Next Chapter

Next:

```text
03-state-commands.md
```

You will learn:

```bash
terraform state list

terraform state show

terraform state mv

terraform state rm
```

These commands are essential for real Terraform troubleshooting.
