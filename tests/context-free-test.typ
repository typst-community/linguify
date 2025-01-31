#import "../lib/linguify.typ": *

#let data = toml("lang.toml")

= Context Free Test
This #linguify("apple", lang:"en", from: data) is a
#type(linguify("apple", lang:"en", from: data))

#set-database(toml("lang.toml"))

And this 
#linguify("apple", lang:"de") is a #type(linguify("apple", lang:"de"))