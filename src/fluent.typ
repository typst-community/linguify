#let ftl = plugin("./linguify_fluent_rs.wasm")

/// returns a bool
#let has-message(ftl-str, msg-id) = {
  str(ftl.has_id(bytes(ftl-str), bytes(msg-id))) == "true"
}

/// Returns the message from the ftl file
///
#let get-message(
  /// the content of the ftl file
  /// -> string
  ftl-str,
  /// the identifier of the message
  /// -> string
  msg-id,
  /// the arguments to pass to the message
  /// -> dictionary
  args: none,
  /// the default value to return if the message is not found
  /// -> string
  default: none,
) = {
  if args == none {
    args = (:)
  }
  if not has-message(ftl-str, msg-id) {
    return default
  }
  return str(
    ftl.get_message(
      bytes(ftl-str),
      bytes(msg-id),
      bytes(json.encode(args, pretty: false)),
    ),
  )
}

/// Constructs the data dict needed in `linguify.typ`
///
/// Returns a `str`, use `eval` to convert it to a dict
///
/// ## Example:
/// ```typst
/// eval(load-ftl-data("path/to/ftl", ("en", "fr")))
/// ```
#let load-ftl-data(
  /// the path to the directory containing the ftl files
  /// -> string
  path,
  /// the list of languages to load
  /// -> array
  languages,
) = {
  assert.eq(type(path), str, message: "expected path to be a string, found " + str(type(path)))
  assert.eq(type(languages), array, message: "expected languages to be an array, found " + str(type(languages)))
  assert(languages.all(l => type(l) == str), message: "languages array can only contain string values")

  let script = ```Typst
  let import-ftl(path, langs) = {
    let data = (
      conf: (
        data-type: "ftl",
        ftl: (
          languages: langs
        ),
      ),
      lang: (:)
    )
    for lang in langs {
      data.lang.insert(lang, str(read(path + "/" + lang + ".ftl")))
    }
    data
  }
  import-ftl(PATH, LANGS)
  ```.text

  let scope = (
    PATH: repr(path),
    LANGS: repr(languages),
  )

  script.replace(regex("\b(" + scope.keys().join("|") + ")\b"), m => scope.at(m.text))
}
