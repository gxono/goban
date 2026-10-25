//! Las imágenes: lo que Typst no sabe hacer con ellas. La opacidad y la silueta (la forma de la imagen, su
//! canal alfa, pintada de un color) de un PNG o un JPEG. Devuelve un PNG con canal alfa.

use serde::Deserialize;
use std::io::Cursor;

/// Lo que se le hace a la imagen: opacity multiplica el canal alfa; con silhouette (r, g, b, a, de 0 a 255),
/// cada píxel toma ese color y su transparencia se multiplica por a.
#[derive(Deserialize)]
pub struct Request {
    #[serde(default = "one")]
    pub opacity: f64,
    #[serde(default)]
    pub silhouette: Option<[u8; 4]>,
}

fn one() -> f64 {
    1.0
}

/// Una imagen con cuatro canales de 8 bits por píxel.
pub struct Rgba {
    pub width: u32,
    pub height: u32,
    pub pixels: Vec<u8>,
}

pub fn decode(data: &[u8]) -> Result<Rgba, String> {
    if data.starts_with(b"\x89PNG\r\n\x1a\n") {
        decode_png(data)
    } else if data.starts_with(&[0xFF, 0xD8]) {
        decode_jpeg(data)
    } else {
        Err("la opacidad y la silueta de una imagen solo se pueden hacer con PNG o JPEG".into())
    }
}

fn decode_png(data: &[u8]) -> Result<Rgba, String> {
    let mut decoder = png::Decoder::new(Cursor::new(data));
    decoder.set_transformations(png::Transformations::EXPAND | png::Transformations::STRIP_16);
    let mut reader = decoder.read_info().map_err(|e| format!("PNG: {e}"))?;
    let size = reader.output_buffer_size().ok_or("PNG: la imagen es demasiado grande")?;
    let mut buffer = vec![0; size];
    let info = reader.next_frame(&mut buffer).map_err(|e| format!("PNG: {e}"))?;
    let data = &buffer[..info.buffer_size()];
    let pixels = match info.color_type {
        png::ColorType::Rgba => data.to_vec(),
        png::ColorType::Rgb => data.chunks_exact(3).flat_map(|p| [p[0], p[1], p[2], 255]).collect(),
        png::ColorType::GrayscaleAlpha => data.chunks_exact(2).flat_map(|p| [p[0], p[0], p[0], p[1]]).collect(),
        png::ColorType::Grayscale => data.iter().flat_map(|&g| [g, g, g, 255]).collect(),
        png::ColorType::Indexed => return Err("PNG: la paleta no se pudo expandir".into()),
    };
    Ok(Rgba { width: info.width, height: info.height, pixels })
}

fn decode_jpeg(data: &[u8]) -> Result<Rgba, String> {
    use zune_core::{bytestream::ZCursor, colorspace::ColorSpace, options::DecoderOptions};
    let options = DecoderOptions::default().jpeg_set_out_colorspace(ColorSpace::RGB);
    let mut decoder = zune_jpeg::JpegDecoder::new_with_options(ZCursor::new(data), options);
    let rgb = decoder.decode().map_err(|e| format!("JPEG: {e:?}"))?;
    let info = decoder.info().ok_or("JPEG: sin encabezado")?;
    let pixels = rgb.chunks_exact(3).flat_map(|p| [p[0], p[1], p[2], 255]).collect();
    Ok(Rgba { width: info.width as u32, height: info.height as u32, pixels })
}

pub fn encode(image: &Rgba) -> Result<Vec<u8>, String> {
    let mut out = Vec::new();
    let mut encoder = png::Encoder::new(&mut out, image.width, image.height);
    encoder.set_color(png::ColorType::Rgba);
    encoder.set_depth(png::BitDepth::Eight);
    encoder.set_compression(png::Compression::Fast);
    let mut writer = encoder.write_header().map_err(|e| format!("PNG: {e}"))?;
    writer.write_image_data(&image.pixels).map_err(|e| format!("PNG: {e}"))?;
    writer.finish().map_err(|e| format!("PNG: {e}"))?;
    Ok(out)
}

pub fn transform(data: &[u8], request: &Request) -> Result<Vec<u8>, String> {
    let mut image = decode(data)?;
    let opacity = request.opacity.clamp(0.0, 1.0);
    for p in image.pixels.chunks_exact_mut(4) {
        let mut alpha = p[3] as f64 * opacity;
        if let Some([r, g, b, a]) = request.silhouette {
            p[..3].copy_from_slice(&[r, g, b]);
            alpha *= a as f64 / 255.0;
        }
        p[3] = alpha.round() as u8;
    }
    encode(&image)
}

pub fn transform_json(data: &[u8], request: &[u8]) -> Result<Vec<u8>, String> {
    let request: Request = serde_json::from_slice(request).map_err(|e| e.to_string())?;
    transform(data, &request)
}

#[cfg(test)]
mod tests;
