fn main() {
    // constants
    let p: i64 = 1279;
    let q: i64 = 71;

    assert!((p - 1) % q == 0);
    let h: i64 = 2;
    let g: i64 = mod_pow(h, (p - 1) / q, p);

    // public key pair
    let s_k: i64 = 17;
    let p_k: i64 = mod_pow(g, s_k, p);

    // sign
    let h: i64 = 17; // hash value
    let k: i64 = 5;
    let k_inv = mod_inverse(k, q).expect("No modular inverse");

    let k: i64 = mod_pow(g, k, p) % q;
    let s: i64 = (k_inv * (h + s_k * k)) % q;

    assert!(k != 0 && s != 0);

    // verify
    let w: i64 = mod_inverse(s, q).expect("No modular inverse");
    let u1: i64 = (h * w) % q;
    let u2: i64 = (k * w) % q;
    let k_star: i64 = (mod_pow(g, u1, p) * mod_pow(p_k, u2, p) % p) % q;

    assert!(k == k_star);

    println!("signature valid");
}

fn mod_pow(base: i64, exp: i64, modulus: i64) -> i64 {
    let mut base = base;
    let mut exp = exp;
    if modulus == 1 {
        return 0;
    }
    let mut result: i64 = 1;
    base = base % modulus;
    while exp > 0 {
        if exp % 2 == 1 {
            result = result * base % modulus;
        }
        exp = exp >> 1;
        base = base * base % modulus
    }
    result
}

fn mod_inverse(a: i64, module: i64) -> Option<i64> {
    let mut mn = (module, a);
    let mut xy = (0, 1);

    while mn.1 != 0 {
        xy = (xy.1, xy.0 - (mn.0 / mn.1) * xy.1);
        mn = (mn.1, mn.0 % mn.1);
    }

    if mn.0 > 1 {
        return None;
    }

    Some((xy.0 + module) % module)
}
