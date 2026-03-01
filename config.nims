import os
import strutils

switch("nimcache", ".nimcache")

proc addNimblePkgPaths(baseDir:string) =
  if not dirExists(baseDir):
    return

  for entry in walkDir(baseDir):
    if entry.kind != pcDir:
      continue
    switch("path", entry.path)
    let srcDir = entry.path / "src"
    if dirExists(srcDir):
      switch("path", srcDir)


let localPkgs2 = getCurrentDir() / ".nimble" / "pkgs2"
let userPkgs2 = getHomeDir() / ".nimble" / "pkgs2"

# Prefer repository-local dependencies, then fall back to user-wide Nimble cache.
addNimblePkgPaths(localPkgs2)
if localPkgs2 != userPkgs2:
  addNimblePkgPaths(userPkgs2)

# Disable LibSass to keep the runtime lightweight.
if not existsEnv("USE_LIBSASS"):
  putEnv("USE_LIBSASS", $false)
if not existsEnv("SESSION_TYPE"):
  putEnv("SESSION_TYPE", "file")
if not existsEnv("SESSION_DB_PATH"):
  putEnv("SESSION_DB_PATH", "./session.db")
if not existsEnv("HOST"):
  putEnv("HOST", "0.0.0.0")
if not existsEnv("PORT"):
  putEnv("PORT", "8080")
if not existsEnv("COOKIE_DOMAINS"):
  putEnv("COOKIE_DOMAINS", "")
