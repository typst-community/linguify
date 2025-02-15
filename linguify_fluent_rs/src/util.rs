pub fn cbor_encode<T>(value: &T) -> Result<Vec<u8>, ciborium::ser::Error<std::io::Error>>
where
    T: serde::Serialize + ?Sized,
{
    let mut writer = Vec::new();
    ciborium::into_writer(value, &mut writer)?;
    Ok(writer)
}

pub trait MapErrToString<T> {
    fn map_err_to_string(self) -> Result<T, String>;
}

impl<T, E: ToString> MapErrToString<T> for Result<T, E> {
    fn map_err_to_string(self) -> Result<T, String> {
        self.map_err(|err| err.to_string())
    }
}
