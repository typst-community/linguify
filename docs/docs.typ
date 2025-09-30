#import "/src/lib.typ": *
#import "@preview/gentle-clues:0.7.1": abstract, quote as _quote

#let l = [_linguify_]

#show raw.where(block: false): it => {
  box(fill: luma(240), radius: 5pt, inset: (x: 3pt), outset: (y: 3pt), it)
}
#show link: it => {
  set text(fill: blue) if type(it.dest) == str
  it
}
#show quote.where(block: false): it => {
  ["] + h(0pt, weak: true) + it.body + h(0pt, weak: true) + ["]
  if it.attribution != none [ (#it.attribution)]
}

#let lang-data = read("lang.toml")

#set-database(toml("lang.toml"))

#let pkginfo = toml("/typst.toml").package

#let ref-fn(name) = link(label("-" + name), raw(name))

// title
#align(center, text(24pt, weight: 500)[linguify manual])

#abstract[
  #link("https://github.com/jomaway/typst-linguify")[*linguify*] is a package for loading strings for different languages easily.

  Version: #pkginfo.version \
  Authors: #link("https://github.com/jomaway")[jomaway] + community contributions \
  License: #pkginfo.license
]

#outline(depth: 2, indent: 2em)

#v(1cm)

This manual shows a short example for the usage of the #l package inside your document. If you want to *include linguify into your package* make sure to read the #link(<4pck>, "section for package authors").

#pagebreak()
= Usage

== Basic Example

*Load language data file:* #sym.arrow See #link(<db>, "database section") for content of `lang.toml`

```typc
#set-database(toml("lang.toml"))
```

*Example input:* \
```typc
#set text(lang: "LANG")
#smallcaps(linguify("abstract"))
=== #linguify("title")

Test: #linguify("test")
```
#v(1em)

#let example(lang, info: none) = (lang, [
  #set text(lang: lang)
  #smallcaps(linguify("abstract"))
  === #linguify("title")
  // #lorem(10)

  Test: #linguify("test")

  #if info != none [
    #set text(style: "italic", fill: blue)
    *Info*: #info
  ]
])

#table(
  columns: 2,
  inset: 1em,
  align: (center, start),
  table.header([*Lang*], [*Output*]),
  ..example("en"),
  ..example("de"),
  ..example("es", info: [
    The key "test" is missing in the "es" language section, but as we specified a default-lang in the `conf` it will display the entry inside the specified language section, which is "en" in our case. \
    To *disable* this behavior delete the `default-lang` entry from the `lang.toml`.
  ]),
  ..example("cz", info: [
    As the lang data does not contain a section for "cz" this entire output will fallback to the default-lang. \
    To *disable* this behavior delete the `default-lang` entry from the `lang.toml`.
  ]),
)

=== Database<db>
The content of the `lang.toml` file, used in the example above looks like this.
#raw(lang: "toml", read("lang.toml"))

== Information for package authors.<4pck>

As the database is stored in a typst state, it can be overwritten. This leads to the following problem. If you use #l inside your package and use the #ref-fn("set-database()") function it will probably work like you expect. But if a user imports your package and uses #l for their own document as well, he will overwrite the your database by using #ref-fn("set-database()"). Therefore it is recommend to use the `from` argument in the #ref-fn("linguify()") function to specify your database directly.

Example:
```typc
// Load data
#let lang-data = toml("lang.toml")

// Useage
#linguify("key", from: lang-data)
```

This makes sure the end user still can use the global database provided by #l with #ref-fn("set-database()") and calling.

#sym.arrow Have a look at the #link("https://github.com/jomaway/typst-gentle-clues", "gentle-clues") package for a real live example.


== Fluent support

Thanks to #link("https://github.com/sjfhsjfh")[sjfhsjfh], #l also has Fluent#footnote(link("https://projectfluent.org/")[Project Fluent]) support. Fluent allows for more complex localization, such as accounting for separate plural or other counting forms. To use Fluent, the `conf.data-type` key of your database needs to be set to `"ftl"`. In addition, each language contains a Fluent language definition instead of many keys for all the terms. A complete example of a Fluent database could look like this:

```toml
[conf]
default-lang = "en"
# set database type to Fluent
data-type = "ftl"

# add arguments available to Fluent translations by default
[ftl.args]
name = "Lore"

[lang]
# each language is a single key containing a whole Fluent file
en = '''
title = A linguify example - with Fluent
abstract = Abstract
hello = Hello, {$name}!
heading = {$headingCount ->
    [one] {$headingCount} heading
   *[other] {$headingCount} headings
}
'''

de = '''
title = Ein linguify Beispiel - mit Fluent
abstract = Zusammenfassung
hello = Hallo, {$name}!
heading = {$headingCount ->
    [0] keine Überschriften
    [one] eine Überschrift
   *[other] {$headingCount} Überschriften
}
'''
```

Since embedding one file inside another is not optimal for things like IDE support, #l also has #ref-fn("load-ftl-data()") to load languages from separate files. Heres a simple example of how to load translations from Fluent files, which are kept in `l10n` directory and named with the language code, e.g. `en.ftl` and `de.ftl`.

```typc
// my-document.typ
#import "@preview/linguify:0.4.2": *
// Define the languages you have files for.
#set-database(eval(load-ftl-data("./l10n", ("en", "de"))))
```

Note how there is a call to `eval()`, since the #l package can't read your translation files directly; instead #l only generates the code that does the reading and lets you execute it.

Likewise, you have to maintain the language list used in database initialization since Typst currently does not list files in a directory. Of course, you can use an external file to store the list of language files and use that to load the ftl files. One option is to use the TOML database file for this:

#grid(
  columns: 2,
  column-gutter: 1em,
  [
    Store config inside a `lang.toml` file.
    ```toml
    [conf]
    default-lang = "en"
    data-type = "ftl"

    [ftl]
    languages = ["en", "de"]
    path = "./l10n"

    # no `[lang]`, it will be populated
    # by the code on the right
    ```
  ],
  [
    Load config inside your document.

    ```typ
    #let data = toml("lang.toml")

    // insert ftl files into database
    #(data.lang = data.ftl.languages.map(lang => {
      (lang, read(path + "/" + lang + ".ftl"))
    }).to-dict())

    #set-database(data)
    ```
  ],
)

The code above is roughly equivalent to what the #ref-fn("load-ftl-data()") function does, except it lets you store the list of languages in the data file and sets the `default-lang`.

= Contributing

If you would like to integrate a new i18n solution into #l, you can set the `conf.data-type` described in the #link(<db>, "database section"). And then add implementation in the #ref-fn("get-text()") function for your data type.

#pagebreak()
= Reference

#import "@preview/tidy:0.4.1"
#tidy.show-module(
  tidy.parse-module(read("/src/linguify.typ")),
  style: tidy.styles.default,
  show-outline: false,
  sort-functions: none,
)

#tidy.show-module(
  tidy.parse-module(read("/src/fluent.typ")),
  style: tidy.styles.default,
  show-outline: false,
  sort-functions: none,
)
