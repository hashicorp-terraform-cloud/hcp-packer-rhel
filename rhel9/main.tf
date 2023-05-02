variable atlas_configuration_version_github_commit_sha {
  type = "string"
}

resource "null_resource" "packer" {
  triggers = {
    sha = var.atlas_configuration_version_github_commit_sha
  }

  provisioner "local-exec" {
    command = <<EOF
RED='\033[0;31m' # Red Text
GREEN='\033[0;32m' # Green Text
BLUE='\033[0;34m' # Blue Text
NC='\033[0m' # No Color

export HCP_PACKER_BUILD_FINGERPRINT=$TF_VAR_ATLAS_CONFIGURATION_VERSION_GITHUB_COMMIT_SHA
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
