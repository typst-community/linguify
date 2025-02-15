// #include "fluent-test/test.typ"
#import "/src/lib.typ": *

#let de = smallcaps("DE:")
#let en = smallcaps("EN:")

#let data = toml("lang.toml")

#let path = data.ftl.at("path", default: "./l10n")
#for lang in data.ftl.languages {
  let lang_section = read(path + "/" + lang + ".ftl")
  data.lang.insert(lang, lang_section)
}

#let data2 = eval(load_ftl_data("./l10n", ("en", "de")))
#assert.eq(data.lang, data2.lang)

*Data: *
#box(fill: luma(240), radius: 5pt, inset: 0.8em)[#data]

= Greetings
- #linguify("hello", from: data)
- #linguify("hello", from: data, args: (name: "Pete"))


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
