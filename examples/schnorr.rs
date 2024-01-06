#![allow(non_snake_case)]
use std::ops::Mul;

fn main() {
    // Constants
    let p: i64 = 1279;
    let g: i64 = 2;

    // Public key pair
    let s_k: i64 = 17;
    let p_k: i64 = mod_pow(g, s_k, p);

    // Sign
    let m: i64 = 17; // message
    let k: i64 = 5;
    let K: i64 = mod_pow(g, k, p);
    let e: i64 = concat_bytes(K, m, p);
    let s: i64 = (k - s_k * e).rem_euclid(p - 1);

    // Verify
    let K_star: i64 = mod_pow(g, s, p).mul(mod_pow(p_k, e, p)) % p;
    let e_star: i64 = concat_bytes(K_star, m, p);

    assert_eq!(e, e_star);
    println!("signature valid");
}

fn concat_bytes(a: i64, b: i64, p: i64) -> i64 {
    let b_bytes = (b as f64).log2().ceil() as i64 / 8;
    ((a << (b_bytes * 8)) | b) % p
}

fn mod_pow(mut base: i64, mut exp: i64, modulus: i64) -> i64 {
    if modulus == 1 {
        return 0;
    }
    let mut result = 1;
    base = base % modulus;
    while exp > 0 {
        if exp % 2 == 1 {
            result = result * base % modulus;
        }
        exp = exp >> 1;
        base = base * base % modulus;
    }
    result
}
