# Terraform CLI

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand the Terraform CLI
* Initialize Terraform Projects
* Validate Configurations
* Format Terraform Code
* Create Execution Plans
* Apply Infrastructure Changes
* Destroy Infrastructure
* Inspect State
* Work with Outputs
* Debug Terraform Configurations
* Follow CLI Best Practices

---

# What is the Terraform CLI?

The Terraform CLI (Command Line Interface) is the primary tool used to interact with Terraform.

Almost all Terraform operations happen through the CLI.

Examples:

```bash
terraform init

terraform plan

terraform apply
```

The CLI allows you to:

* Manage infrastructure
* Validate code
* Inspect state
* Troubleshoot issues
* Automate deployments

---

# Checking Terraform Version

Always verify your Terraform version.

Command:

```bash
terraform version
```

Example:

```text
Terraform v1.13.0
```

This helps ensure consistency across teams.

---

# terraform init

The first command executed in any Terraform project.

Command:

```bash
terraform init
```

Purpose:

* Downloads providers
* Configures backend
* Creates .terraform directory
* Prepares working directory

Example output:

```text
Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized.
```

Run:

```bash
terraform init
```

whenever:

* Starting a new project
* Adding providers
* Changing backend configuration

---

# terraform fmt

Formats Terraform code automatically.

Command:

```bash
terraform fmt
```

Example:

Bad:

```hcl
resource "aws_instance" "web"{
instance_type="t3.micro"
}
```

After:

```bash
terraform fmt
```

Result:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.micro"
}
```

Always format before committing.

---

# terraform validate

Checks syntax and configuration validity.

Command:

```bash
terraform validate
```

Example:

```text
Success! The configuration is valid.
```

This command does not create infrastructure.

It only verifies correctness.

---

# terraform plan

One of the most important Terraform commands.

Command:

```bash
terraform plan
```

Purpose:

Shows what Terraform intends to do.

Example:

```text
+ create aws_s3_bucket.logs
```

Terraform compares:

```text
Desired State
vs
Current State
```

and generates an execution plan.

Always review plans carefully.

---

# Saving a Plan

You can save a plan file.

Command:

```bash
terraform plan -out=tfplan
```

Creates:

```text
tfplan
```

Benefits:

* Reproducible deployments
* CI/CD compatibility
* Approval workflows

Apply later:

```bash
terraform apply tfplan
```

---

# terraform apply

Executes infrastructure changes.

Command:

```bash
terraform apply
```

Terraform:

1. Generates plan
2. Requests confirmation
3. Applies changes

Example:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

Confirm:

```text
yes
```

Infrastructure is created.

---

# Auto Approve

Terraform can skip confirmation.

Command:

```bash
terraform apply -auto-approve
```

Common in CI/CD pipelines.

Use carefully.

---

# terraform destroy

Removes infrastructure.

Command:

```bash
terraform destroy
```

Terraform:

```text
Deletes managed resources
```

Example:

```text
Plan: 0 to add, 0 to change, 3 to destroy.
```

Be extremely careful.

---

# terraform output

Displays outputs.

Command:

```bash
terraform output
```

Example:

```text
environment = "dev"

project_name = "dev-web"
```

Specific output:

```bash
terraform output project_name
```

---

# terraform output -json

Machine-readable outputs.

Command:

```bash
terraform output -json
```

Frequently used in automation pipelines.

---

# terraform show

Displays Terraform state or plan information.

Command:

```bash
terraform show
```

Useful for:

* Troubleshooting
* State inspection
* Understanding resource attributes

---

# terraform providers

Displays provider information.

Command:

```bash
terraform providers
```

Example:

```text
Providers required by configuration:
├── provider[registry.terraform.io/hashicorp/aws]
```

Helpful for dependency analysis.

---

# terraform state

Used for inspecting and managing state.

Examples:

List resources:

```bash
terraform state list
```

Show resource:

```bash
terraform state show aws_s3_bucket.logs
```

More advanced state management is covered later.

---

# terraform console

Interactive Terraform shell.

Command:

```bash
terraform console
```

Example:

```bash
> upper("terraform")

TERRAFORM
```

Useful for:

* Testing expressions
* Testing functions
* Debugging logic

---

# terraform graph

Generates dependency graph.

Command:

```bash
terraform graph
```

Terraform outputs dependency relationships.

Useful for large infrastructures.

---

# terraform workspace

Manage workspaces.

List:

```bash
terraform workspace list
```

Create:

```bash
terraform workspace new dev
```

Switch:

```bash
terraform workspace select dev
```

Workspaces will be covered in detail later.

---

# Common Terraform Workflow

Typical workflow:

```bash
terraform fmt

terraform validate

terraform plan

terraform apply
```

Production teams execute this cycle repeatedly.

---

# Debugging Terraform

Useful commands:

Validate:

```bash
terraform validate
```

Inspect outputs:

```bash
terraform output
```

Inspect state:

```bash
terraform state list
```

Interactive testing:

```bash
terraform console
```

These commands solve many day-to-day issues.

---

# Common Beginner Mistakes

## Skipping terraform plan

Bad:

```bash
terraform apply
```

Good:

```bash
terraform plan

terraform apply
```

Always review changes first.

---

## Ignoring terraform fmt

Consistent formatting improves maintainability.

Always run:

```bash
terraform fmt
```

---

## Running destroy Carelessly

Never run:

```bash
terraform destroy
```

without understanding the impact.

---

## Not Reading Errors

Terraform errors are often very informative.

Read them carefully before troubleshooting.

---

# Production CLI Workflow

A common production sequence:

```bash
terraform fmt

terraform validate

terraform plan -out=tfplan

terraform apply tfplan
```

Benefits:

* Predictable deployments
* Approval processes
* Reduced risk

---

# Best Practices

* Run terraform fmt regularly
* Validate before planning
* Review every plan
* Save plans in production
* Avoid auto-approve outside automation
* Understand destroy before using it
* Learn state commands early

---

# Key Takeaways

* The Terraform CLI is the primary interface for Terraform.
* init prepares a project.
* fmt formats code.
* validate checks configuration correctness.
* plan previews changes.
* apply executes changes.
* destroy removes infrastructure.
* output, show, console, and state help with troubleshooting.
* Mastering the CLI is essential for day-to-day Terraform work.

---

# Next Chapter

In the next chapter, we will bring everything together and learn how to write production-grade Terraform.

We will cover project organization, naming conventions, reusable patterns, tagging strategies, environment management, and code structure used by professional Terraform teams.
