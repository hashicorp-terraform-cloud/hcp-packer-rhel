resource "null_resource" "packer" {
  triggers = {
    ami_name = local.ami_name
  }
  provisioner "local-exec" {
    working_dir = "./packer"
    command = <<EOF
RED='\033[0;31m' # Red Text
GREEN='\033[0;32m' # Green Text
BLUE='\033[0;34m' # Blue Text
NC='\033[0m' # No Color

packer build .

if [ $? -eq 0 ]; then
  printf "\n $GREEN Packer Succeeded $NC \n"
else
  printf "\n $RED Packer Failed $NC \n" >&2
  exit 1
fi
EOF
  }
}
