require logging
require config

readonly TEMPDIR="$(mktemp -d)"
readonly NODE_VERSION="$(config::get installer.npm.version)"
readonly NODE_FILENAME="node-v${NODE_VERSION}-linux-x64"
readonly NODE_MIRROR="https://mirrors.aliyun.com/nodejs-release"
readonly NODE_URL="$NODE_MIRROR/v${NODE_VERSION}/${NODE_FILENAME}.tar.xz"

npm::installer() {
  config::get installer.npm.enabled && {
    has_command npm || {
      log::info "Installing node and npm..."
      log::verbose "Downloading ${NODE_URL}"
      curl -sSL ${NODE_URL} -o "${TEMPDIR}/${NODE_FILENAME}.tar.xz"
      log::verbose "Extracting files to /opt..."
      tar xf "${TEMPDIR}/${NODE_FILENAME}.tar.xz" -C /opt
      setup::add_context "PATH" "export PATH=/opt/${NODE_FILENAME}/bin:\$PATH"
      npm::accelerate
      npm install -g yarn lerna >$QUIET_STDOUT 2>&1
    }
  } || {
    has_command npm && {
      log::info "Uninstalling node and npm..."
      setup::del_context "node"
      rm -fr /opt/node-*
    } || true
  }
}

npm::accelerate() {
  log::info "Accelerating npm registry..."
  npm config set registry https://registry.npmmirror.com
}

npm::version() {
  npm --version
}

node::version() {
  node --version
}
