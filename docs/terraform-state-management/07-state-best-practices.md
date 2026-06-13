# Terraform State Best Practices

## Learning Objectives

By the end of this chapter, you should be able to:

- Understand production Terraform state workflows
- Apply state management best practices
- Design scalable backend structures
- Understand disaster recovery for state
- Understand state migration strategies
- Avoid common state mistakes

---

# Introduction

Terraform state is the foundation of Terraform operations.

We learned:

```
Configuration
      |
      v
Terraform State
      |
      v
Infrastructure
```

A well-managed state allows teams to:

- Collaborate safely
- Deploy reliably
- Recover from failures
- Scale infrastructure

---

# Production State Requirements

A production Terraform environment should have:

```
Remote State

+

Encryption

+

Locking

+

Access Control

+

Backup Strategy
```

---

# 1. Always Use Remote State

Local state:

```
terraform.tfstate
```

is not suitable for teams.

Problems:

```
Lost files

No collaboration

No locking

Manual sharing
```

Production:

```
Terraform

      |

Remote Backend

      |

Infrastructure
```

---

# 2. Separate Environments

Avoid:

```
one-state-file.tfstate
```

for everything.

Better:

```
terraform-state/

├── dev/

│   └── terraform.tfstate

├── staging/

│   └── terraform.tfstate

└── prod/

    └── terraform.tfstate
```

---

# Why Separate State?

Example:

Developer changes:

```
dev environment
```

should not affect:

```
production environment
```

Separate state creates isolation.

---

# 3. Use Backend Versioning

Remote backends should support versions.

Example:

AWS S3:

```
Versioning Enabled
```

Benefits:

- Recover previous state
- Undo accidental changes
- Investigate problems

---

# 4. Enable Encryption

State should always be encrypted.

Example:

```
State File

     |

Encrypted Storage

     |

Cloud Backend
```

---

# 5. Protect Backend Access

Control who can access state.

Use:

- IAM
- Roles
- Policies
- Least privilege

---

# Example Permission Model

Developers:

```
terraform plan

terraform apply
```

Administrators:

```
Backend administration
```

Avoid giving everyone:

```
Full Admin Access
```

---

# 6. Use State Locking

Always enable locking.

Without locking:

```
Engineer A apply

Engineer B apply

Conflict
```

With locking:

```
Engineer A apply

Lock

Engineer B waits
```

---

# 7. Never Edit State Manually

Avoid:

```
Opening terraform.tfstate

Changing JSON

Saving
```

Possible results:

```
Broken state

Incorrect resources

Failed deployments
```

Use:

```bash
terraform state
```

commands.

---

# 8. Backup State

State is critical.

Backup strategies:

```
Backend Versioning

Scheduled Backups

Recovery Testing
```

---

# 9. Review State Changes

Treat state changes seriously.

Before:

```bash
terraform apply
```

Review:

```bash
terraform plan
```

Check:

```
Resources to create

Resources to update

Resources to destroy
```

---

# 10. Use Terraform Plan In CI/CD

Production workflow:

```
Developer

    |

Pull Request

    |

terraform plan

    |

Approval

    |

terraform apply
```

---

# 11. State Migration

Sometimes you need to move state.

Example:

Local:

```
terraform.tfstate
```

to:

```
S3 Backend
```

Command:

```bash
terraform init
```

Terraform asks:

```
Migrate state?
```

---

# 12. State Splitting

Large projects may have one huge state.

Example:

```
company.tfstate
```

contains:

```
Network

Compute

Database

Kubernetes
```

This becomes difficult.

---

# Better Architecture

Split:

```
network.tfstate

compute.tfstate

database.tfstate

kubernetes.tfstate
```

Each component owns its state.

---

# 13. Avoid Large Blast Radius

Bad:

```
terraform apply
```

changes:

```
Entire company infrastructure
```

Better:

```
Apply network

Apply compute

Apply database
```

Smaller changes are safer.

---

# 14. Use Remote State Data Carefully

Remote state sharing:

Example:

```
Network Project

        |

        v

Application Project
```

Application reads:

```
VPC ID
```

from network state.

Avoid sharing everything.

Only expose required outputs.

---

# 15. Disaster Recovery

Plan for:

```
State Loss

Backend Failure

Accidental Deletion
```

Recovery:

```
Restore state backup

Validate

Run terraform plan
```

---

# Common Mistakes

## Mistake 1

Committing state to Git.

Fix:

```
Use remote backend
```

---

## Mistake 2

One state file for everything.

Fix:

```
Separate environments
```

---

## Mistake 3

No locking.

Fix:

```
Enable backend locking
```

---

## Mistake 4

Everyone has access.

Fix:

```
IAM controls
```

---

# Production Terraform State Checklist

Before production:

```
Remote backend configured

Encryption enabled

Locking enabled

Versioning enabled

IAM restricted

Backups available

CI/CD workflow created

State reviewed regularly
```

---

# Real Enterprise Architecture

Example:

```
Developer

    |

GitHub

    |

CI/CD

    |

Terraform

    |

Remote Backend

    |

Cloud Resources
```

---

# Key Takeaways

- State is Terraform's source of truth
- Production requires remote state
- Locking prevents conflicts
- Encryption protects sensitive data
- Backups provide recovery
- Separate state improves safety
- State management is a core Terraform skill

---

# Terraform State Management Complete

You now understand:

```
What State Is

State Structure

State Commands

Remote State

State Locking

State Security

Best Practices
```

---

# Next Phase

Next major Terraform skill:

```
Modules
```

You will learn:

```
Creating Modules

Using Modules

Inputs

Outputs

Module Versioning

Reusable Infrastructure
```