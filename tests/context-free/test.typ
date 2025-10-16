#import "/src/lib.typ": *

#let data = toml("lang.toml")

#set-database(data)

// Database and language are known: string
#assert.eq(type(linguify-raw("apple", from: data, lang: "en")), str)

// Only database known: content (context)
#assert.eq(type(context linguify-raw("apple", from: data)), content)

// Only language known: content (context)
#assert.eq(type(context linguify-raw("apple", lang: "en")), content)
