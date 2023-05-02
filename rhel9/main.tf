resource "null_resource" "packer" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
export
EOF
  }
}
