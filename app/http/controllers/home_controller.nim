import std/asyncdispatch
import std/os
import std/strutils
import basolato/controller
import ../views/pages/home_page

proc isSafeHost(host: string): bool =
  if host.len == 0:
    return false

  for ch in host:
    if ch notin {'a'..'z', 'A'..'Z', '0'..'9', '.', '-', ':', '[', ']'}:
      return false

  return true

proc detectBaseUrl(request: Request): string =
  var siteUrl = getEnv("SITE_URL", "").strip()
  while siteUrl.endsWith("/"):
    siteUrl.setLen(siteUrl.len - 1)
  if siteUrl.len > 0:
    return siteUrl

  let headers = request.headers
  let rawHost = headers.getOrDefault("Host").split(",")[0].strip()
  let host = if isSafeHost(rawHost): rawHost else: ""
  var proto = headers.getOrDefault("X-Forwarded-Proto").split(",")[0].strip().toLowerAscii()

  if proto.len == 0:
    let forwarded = headers.getOrDefault("Forwarded").toLowerAscii()
    if forwarded.contains("proto=https"):
      proto = "https"
    elif forwarded.contains("proto=http"):
      proto = "http"

  if proto.len == 0:
    if host.startsWith("localhost") or host.startsWith("127.0.0.1"):
      proto = "http"
    else:
      proto = "https"

  let normalizedProto =
    if proto == "http" or proto == "https":
      proto
    else:
      "https"

  if host.len == 0:
    return "http://localhost:8080"

  return normalizedProto & "://" & host

proc index*(context:Context, params:Params):Future[Response] {.async.} =
  discard params
  let baseUrl = detectBaseUrl(context.request)
  let siteName = getEnv("SITE_NAME", "Todo App Template")
  return render(homePage(baseUrl, siteName))
