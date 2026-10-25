use super::*;

fn png_of(width: u32, height: u32, pixels: Vec<u8>) -> Vec<u8> {
    encode(&Rgba { width, height, pixels }).unwrap()
}

#[test]
fn opacity_multiplies_alpha() {
    let data = png_of(2, 1, vec![10, 20, 30, 255, 40, 50, 60, 100]);
    let out = decode(&transform(&data, &Request { opacity: 0.5, silhouette: None }).unwrap()).unwrap();
    assert_eq!(out.pixels, vec![10, 20, 30, 128, 40, 50, 60, 50]);
}

#[test]
fn silhouette_keeps_the_shape() {
    let data = png_of(2, 1, vec![10, 20, 30, 255, 40, 50, 60, 0]);
    let request = Request { opacity: 1.0, silhouette: Some([255, 0, 0, 255]) };
    let out = decode(&transform(&data, &request).unwrap()).unwrap();
    assert_eq!(out.pixels, vec![255, 0, 0, 255, 255, 0, 0, 0]);
}

#[test]
fn jpeg_and_png_of_the_package() {
    let board = decode(include_bytes!("../../../images/pgfgo-board.jpg")).unwrap();
    assert!(board.width > 0 && board.pixels.len() == (board.width * board.height * 4) as usize);
    assert!(board.pixels.chunks_exact(4).all(|p| p[3] == 255));
    let stone = decode(include_bytes!("../../../images/pgfgo-shell-black.png")).unwrap();
    assert!(stone.pixels.chunks_exact(4).any(|p| p[3] == 0));
}

#[test]
fn other_formats_are_an_error() {
    assert!(decode(b"<svg/>").is_err());
}
