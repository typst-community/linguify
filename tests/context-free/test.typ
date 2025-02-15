#import "/src/lib.typ": *

#let data = toml("lang.toml")

#set-database(data)

// Database and language are known: string
#assert.eq(type(linguify("apple", from: data, lang: "en")), str)

// Only database known: content (context)
#assert.eq(type(linguify("apple", from: data)), content)

// Only language known: content (context)
#assert.eq(type(linguify("apple", lang: "en")), content)

// Neither known: content (context)
#assert.eq(type(linguify("apple")), content)
