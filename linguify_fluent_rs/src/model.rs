use std::collections::HashMap;

use serde::Deserialize;

#[derive(Deserialize, Debug, Clone, PartialEq)]
#[serde(rename_all = "kebab-case")]
pub struct Config {
    pub source: String,
    pub msg_id: String,
    pub args: HashMap<String, Value>,
}

#[derive(Deserialize, Debug, Clone, PartialEq)]
#[serde(untagged, rename_all = "kebab-case")]
pub enum Value {
    String(String),
    Number(i64),
}
