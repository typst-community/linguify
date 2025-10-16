#import "/src/lib.typ": *

#show outline.entry: it => database-at(it.element.location(), it)

// Initial database for cover page
#let database = toml("a.toml")
#set-database(database)

// These keys are found in the initial database
= #linguify("apple")
= #linguify("pear")

// Generate the outline
#outline()

// Switch to the main translation database
#let database = toml("b.toml")
#set-database(database)

// This key is NOT found in the header!
= #linguify("red")
// This key IS found in regular text
#linguify("green")
