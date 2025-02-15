use fluent::{FluentArgs, FluentBundle, FluentResource, FluentValue};
use unic_langid::LanguageIdentifier;

#[cfg(target_arch = "wasm32")]
use wasm_minimal_protocol::wasm_func;

mod model;
mod util;

use model::*;
use util::*;

#[cfg(target_arch = "wasm32")]
wasm_minimal_protocol::initiate_protocol!();

#[cfg_attr(target_arch = "wasm32", wasm_func)]
pub fn get_message(config: &[u8]) -> Result<Vec<u8>, String> {
    let Config {
        source,
        msg_id,
        args,
    } = ciborium::from_reader(config).map_err_to_string()?;

    let args: FluentArgs = args
        .into_iter()
        .map(|(k, v)| {
            let v = match v {
                Value::String(s) => FluentValue::String(s.into()),
                Value::Number(n) => FluentValue::Number(n.into()),
            };
            (k, v)
        })
        .collect();

    let li = LanguageIdentifier::default();
    let res =
        FluentResource::try_new(source).map_err(|_| "Failed to add FluentResource".to_string())?;

    let mut bundle = FluentBundle::new(vec![li]);
    bundle
        .add_resource(res)
        .map_err(|_| "Failed to add FluentResource".to_string())?;

    let message = bundle.get_message(&msg_id);
    let value = message
        .map(|message| {
            let pattern = message
                .value()
                .ok_or_else(|| "Failed to get value".to_string())?;

            let value = bundle.format_pattern(pattern, Some(&args), &mut vec![]);
            Ok::<_, String>(value)
        })
        .transpose()?;

    let output = cbor_encode(&value).map_err_to_string()?;
    Ok(output)
}
