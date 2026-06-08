resource "null_resource" "bootstrap" {

  provisioner "local-exec" {

    command = "echo Bootstrap Complete"

  }

}

resource "null_resource" "application" {

  depends_on = [
    null_resource.bootstrap
  ]

}