# Rust Fluent WebAssembly

Basic functionalities.

## Usage

generate the wasm file by running

```bash
rustup target add wasm32-unknown-unknown
cargo build --release --target wasm32-unknown-unknown
cp target/wasm32-unknown-unknown/release/linguify_fluent_rs.wasm .
```
