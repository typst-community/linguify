#import "/src/lib.typ": *

#let data = toml("lang.toml")

#set-database(data)

// Database and language are known, so we dont have to provide the context
#assert.eq(type(linguify-raw("apple", from: data, lang: "en")), str)

// Only database known, so we have to provide context
#context assert.eq(type(linguify-raw("apple", from: data)), str)

// Only language known, so we have to provide context
#context assert.eq(type(linguify-raw("apple", lang: "en")), str)

// Assert that without context and without any of `lang` or `from`, the function panics.

#assert-panic(() => linguify-raw("apple"))

#assert-panic(() => linguify-raw("apple", from: data))

#assert-panic(() => linguify-raw("apple", lang: "en"))
