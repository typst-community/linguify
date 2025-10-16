#import "/src/linguify.typ": *

#let db = toml("lang.toml")

#let test-data = {
  assert(db != none)
  assert(db.at("lang", default: none) != none)

  set-database(db)
  reset-database()

  [run `data` successfully]
}

#let test-get-text = {
  // English (en)
  assert(get-text(db.lang, "apple", "en") == "Apple")
  assert(get-text(db.lang, "pear", "en") == "Pear")
  assert(get-text(db.lang, "banana", "en") == "Banana")

  assert(get-text(db.lang, "red", "en") == "red")
  assert(get-text(db.lang, "green", "en") == "green")
  assert(get-text(db.lang, "yellow", "en") == "yellow")

  assert(get-text(db.lang, "test", "en") == none)

  // German (de)
  assert(get-text(db.lang, "apple", "de") == "Apfel")
  assert(get-text(db.lang, "pear", "de") == "Birne")
  assert(get-text(db.lang, "banana", "de") == "Banane")

  assert(get-text(db.lang, "red", "de") == none)
  assert(get-text(db.lang, "green", "de") == none)
  assert(get-text(db.lang, "yellow", "de") == none)

  assert(get-text(db.lang, "test", "de") == none)

  [run `test-get-text` successfully]
}


#let test-_linguify = {
  reset-database()

  // English (en)
  set text(lang: "en")
  context {
    assert(_linguify("apple", from: db) == ok("Apple"))
    assert(_linguify("pear", from: db) == ok("Pear"))
    assert(_linguify("banana", from: db) == ok("Banana"))

    assert(_linguify("red", from: db) == ok("red"))
    assert(_linguify("green", from: db) == ok("green"))
    assert(_linguify("yellow", from: db) == ok("yellow"))

    assert(is-error(_linguify("test", from: db)))
  }

  // German (de)
  set text(lang: "de")
  context {
    assert(_linguify("apple", from: db) == ok("Apfel"))
    assert(_linguify("pear", from: db) == ok("Birne"))
    assert(_linguify("banana", from: db) == ok("Banane"))

    // keys not inside db - will fallback to en
    assert(_linguify("red", from: db) == ok("red"))
    assert(_linguify("green", from: db) == ok("green"))
    assert(_linguify("yellow", from: db) == ok("yellow"))

    assert(is-error(_linguify("test", from: db)))
  }

  // Spanish (es) ! lang not inside db wil fallback to en
  set text(lang: "es")
  context {
    assert(_linguify("apple", from: db) == ok("Apple"))
    assert(_linguify("pear", from: db) == ok("Pear"))
    assert(_linguify("banana", from: db) == ok("Banana"))

    assert(_linguify("red", from: db) == ok("red"))
    assert(_linguify("green", from: db) == ok("green"))
    assert(_linguify("yellow", from: db) == ok("yellow"))

    assert(is-error(_linguify("test", from: db)))
  }

  [run `test-_linguify` successfully]
}


#let test-_linguify-auto-db = {
  set-database(db)
  // English (en)
  set text(lang: "en")
  context {
    assert(_linguify("apple") == ok("Apple"))
    assert(_linguify("pear") == ok("Pear"))
    assert(_linguify("banana") == ok("Banana"))

    assert(_linguify("red") == ok("red"))
    assert(_linguify("green") == ok("green"))
    assert(_linguify("yellow") == ok("yellow"))

    assert(is-error(_linguify("test")))
  }

  // German (de)
  set text(lang: "de")
  context {
    assert(_linguify("apple") == ok("Apfel"))
    assert(_linguify("pear") == ok("Birne"))
    assert(_linguify("banana") == ok("Banane"))

    // keys not inside db - will fallback to en
    assert(_linguify("red") == ok("red"))
    assert(_linguify("green") == ok("green"))
    assert(_linguify("yellow") == ok("yellow"))

    assert(is-error(_linguify("test")))
  }

  // Spanish (es) ! lang not inside db wil fallback to en
  set text(lang: "es")
  context {
    assert(_linguify("apple") == ok("Apple"))
    assert(_linguify("pear") == ok("Pear"))
    assert(_linguify("banana") == ok("Banana"))

    assert(_linguify("red") == ok("red"))
    assert(_linguify("green") == ok("green"))
    assert(_linguify("yellow") == ok("yellow"))

    assert(is-error(_linguify("test")))
  }

  [run `test-_linguify-auto-db` successfully]
}

#let test-args-in-dict-mode = {
  context {
    assert(_linguify("apple") == ok("Apple"))
    assert(is-error(_linguify("apple", args: (name: "test"))))
    assert(is-error(_linguify("apple", args: none)))
    assert(is-error(_linguify("apple", args: (:))))
    assert(is-error(_linguify("apple", args: "")))
    assert(is-error(_linguify("apple", args: 1)))
  }

  [run `test-args-in-dict-mode` successfully]
}

#let test-linguify-default = {
  assert.eq(linguify-raw("test", from: db, lang: "en", default: "x"), "x")

  [run `test-linguify-default` successfully]
}

= Run tests (#datetime.today().display())

- #test-data
- #test-get-text
- #test-_linguify
- #test-_linguify-auto-db
- #test-args-in-dict-mode
