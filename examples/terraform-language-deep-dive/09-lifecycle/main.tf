resource "null_resource" "application" {

  lifecycle {

    create_before_destroy = true

  }

}

resource "null_resource" "database" {

  lifecycle {

    prevent_destroy = true

  }

}