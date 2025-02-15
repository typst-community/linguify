// Helper function.
// if the value is auto "ret" is returned else the value self is returned
#let if-auto-then(val, ret) = {
  if val == auto {
    ret
  } else {
    val
  }
}

// basic result type implementation
#let ok(value) = ("ok": value)
#let error(msg) = ("error": msg)
#let is-ok(result) = "ok" in result
#let is-error(result) = "error" in result
