version       = "0.1.0"
author        = "Your Team"
description   = "Basolato + Nim template for Cloud Run"
license       = "MIT"
srcDir        = "."
bin           = @["main"]
backend       = "c"

requires "nim >= 2.0.0"

before build:
  exec "./scripts/install_basolato.sh"
  exec "./scripts/tailwind.sh build"

task setup, "Install Basolato and build Tailwind CSS":
  exec "./scripts/setup.sh"

task css, "Build Tailwind CSS":
  exec "./scripts/tailwind.sh build"

task dev, "Run Tailwind watcher + Basolato hot reloading server":
  exec "./scripts/dev.sh"
