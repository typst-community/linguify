[private]
default:
  just --list

run-tests:
  tt run

build-docs:
  typst compile docs/docs.typ manual.pdf --root ..
