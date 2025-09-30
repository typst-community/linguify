// #include "fluent-test/test.typ"
#import "/src/lib.typ": *

#let de = smallcaps("DE:")
#let en = smallcaps("EN:")

#let data = toml("lang.toml")

#let path = data.ftl.at("path", default: "./l10n")
#(data.lang = data.ftl.languages.map(lang => {
  (lang, read(path + "/" + lang + ".ftl"))
}).to-dict())

#let data2 = eval(load-ftl-data("./l10n", ("en", "de")))
#assert.eq(data.lang, data2.lang)

#let data3 = toml("lang-inline-ftl.toml")
#assert.eq(data, data3)

*Data: *
#box(fill: luma(240), radius: 5pt, inset: 0.8em)[#data]

= Greetings
- #linguify("hello", from: data)
- #linguify("hello", from: data, args: (name: "Pete"))
- #linguify("test", from: data, default: "test")


= Headings
#set heading(numbering: "1.a.")
```typc
#set heading(numbering: "1.a.")
```

#let headings = context linguify("heading", from: data, args: (headingCount: counter(heading).get().first()))

Your document has #headings.

#[
  #set text(lang: "de")
  #de Dein Dokument hat #headings.
]

= Head

Your document has #headings.

#[
  #set text(lang: "de")
  #de Dein Dokument hat #headings.
]

= Head

Your document has #headings.

#[
  #set text(lang: "de")
  #de Dein Dokument hat #headings.
]
