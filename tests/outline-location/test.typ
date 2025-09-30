#import "/src/lib.typ": *

#show outline.entry: it => database-at(it.element.location(), it)

// Initial database for cover page
#let database = toml(bytes(```toml
[conf]
default-lang = "en"

[lang.en]
apple = "Apple"
pear = "Pear"
banana = "Banana"

red = "different red"
```.text))
#set-database(database)

// These keys are found in the initial database
= #linguify("apple")
= #linguify("pear")

// Generate the outline
#outline()

// Switch to the main translation database
#let database = toml(bytes(```toml
[conf]
default-lang = "en"

[lang.en]
red = "red"
green = "green"
yellow = "yellow"
```.text))
#set-database(database)

// This key is NOT found in the header!
= #linguify("red")
// This key IS found in regular text
#linguify("green")