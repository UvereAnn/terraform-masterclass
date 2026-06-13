# Terraform State Commands

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Terraform state commands
* List managed resources
* Inspect resources inside state
* Move resources safely
* Remove resources from state
* Troubleshoot state problems
* Perform safe state operations

---

# Introduction

Terraform state is critical.

Because of that, Terraform provides commands to interact with state safely.

The main command:

```bash
terraform state
```

shows all available state operations.

---

# Viewing Available State Commands

Run:

```bash
terraform state
```

Output:

```text
Usage:
terraform state <subcommand>
```

Common commands:

```text
list

show

mv

rm

pull

push
```

---

# 1. terraform state list

## Purpose

Lists all resources tracked in state.

Command:

```bash
terraform state list
```

Example output:

```text
null_resource.server

null_resource.database
```

Terraform is saying:

"I currently manage these resources."

---

# Why Use It?

Useful for:

* Checking what Terraform manages
* Finding resource addresses
* Debugging missing resources

---

# Example

Suppose:

```hcl
resource "null_resource" "server" {}
```

After apply:

```bash
terraform state list
```

Returns:

```text
null_resource.server
```

---

# Resource Addresses

Terraform identifies resources by address.

Example:

```text
aws_instance.web
```

or:

```text
aws_instance.web[0]
```

For modules:

```text
module.network.aws_vpc.main
```

---

# 2. terraform state show

## Purpose

Shows details of a resource in state.

Command:

```bash
terraform state show RESOURCE
```

Example:

```bash
terraform state show null_resource.server
```

Output:

```text
id = 123456789
```

---

# Why Use It?

You can inspect:

* Resource ID
* Attributes
* Stored values
* Current Terraform knowledge

---

# Example

Command:

```bash
terraform state show null_resource.server
```

Output:

```text
resource "null_resource" "server" {

 id = "123456789"

}
```

---

# Difference

## state list

Shows:

```text
What exists
```

Example:

```text
aws_instance.web
```

---

## state show

Shows:

```text
Details of one resource
```

Example:

```text
Instance ID
Attributes
Metadata
```

---

# 3. terraform state mv

## Purpose

Moves resources inside state.

Important:

It does NOT move infrastructure.

It changes Terraform's state mapping.

---

# Problem Example

You have:

```hcl
resource "aws_instance" "web_old" {}
```

You rename it:

```hcl
resource "aws_instance" "web_new" {}
```

Terraform thinks:

```text
Destroy old

Create new
```

Dangerous.

---

# Solution

Move state:

```bash
terraform state mv \
aws_instance.web_old \
aws_instance.web_new
```

Now Terraform understands:

```text
Same Resource

New Name
```

---

# Common Uses

Used during:

* Refactoring
* Module migration
* Resource renaming
* Architecture cleanup

---

# Example Module Move

Before:

```text
aws_instance.web
```

After:

```text
module.compute.aws_instance.web
```

Command:

```bash
terraform state mv \
aws_instance.web \
module.compute.aws_instance.web
```

---

# 4. terraform state rm

## Purpose

Removes a resource from Terraform state.

Command:

```bash
terraform state rm RESOURCE
```

Example:

```bash
terraform state rm null_resource.server
```

---

# Important

This does NOT delete the resource.

Example:

Before:

```text
Terraform State
      +
EC2 Instance
```

After:

```text
No State Entry

EC2 Still Running
```

---

# When To Use state rm

Common scenarios:

## Stop managing a resource

Example:

A team manages:

```text
Application
```

but another team manages:

```text
Database
```

Remove database from your state.

---

## Fix broken state

Example:

Terraform tracks:

```text
wrong resource
```

Remove it safely.

---

# 5. terraform state pull

## Purpose

Downloads current state.

Command:

```bash
terraform state pull
```

Output:

```json
{
 "resources": []
}
```

Useful for:

* Backups
* Debugging
* Inspection

---

# 6. terraform state push

## Purpose

Uploads a state file.

Command:

```bash
terraform state push statefile.tfstate
```

WARNING:

Use carefully.

Wrong state can break infrastructure management.

---

# State Command Workflow

Typical troubleshooting:

```text
1. List resources

terraform state list


2. Inspect resource

terraform state show


3. Fix mapping

terraform state mv


4. Remove incorrect entry

terraform state rm
```

---

# Real Example

Problem:

Terraform wants to recreate:

```text
aws_instance.web
```

Check:

```bash
terraform state list
```

Maybe:

```text
module.ec2.aws_instance.web
```

Move:

```bash
terraform state mv \
module.ec2.aws_instance.web \
aws_instance.web
```

Run:

```bash
terraform plan
```

---

# Common Mistakes

## Running state rm accidentally

Bad:

```bash
terraform state rm resource
```

without understanding.

Result:

Terraform forgets the resource.

---

## Editing JSON manually

Avoid:

```text
terraform.tfstate
```

manual edits.

Use:

```bash
terraform state
```

commands.

---

# Best Practices

* Always backup state before changes
* Use state commands instead of editing JSON
* Run terraform plan after state operations
* Test in development first
* Document state changes

---

# Key Takeaways

* state list shows managed resources
* state show inspects resources
* state mv safely renames/moves resources
* state rm stops Terraform management
* State commands are essential troubleshooting skills

---

# Next Chapter

Next:

```text
04-remote-state.md
```

You will learn:

* Remote backends
* S3 backend
* Azure Storage backend
* GCS backend
* Team collaboration
* Shared Terraform state
