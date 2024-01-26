#import "@preview/slydst:0.1.0": *

#show: slides.with(
  title: "Cryptography Workshop",
  subtitle: none,
  date: none,
  authors: ("Jose Storopoli", ),
  layout: "medium",
  ratio: 4/3,
  title-color: orange,
)

#set text(size: 16pt)
#show link: set text(blue)
#let p = 1279
#let q = 71

/*
Level-one headings corresponds to new sections.
Level-two headings corresponds to new slides.
Blank space can be filled with vertical spaces like #v(1fr).
*/

== License

#align(horizon + center)[#image("images/cc-zero.svg", width: 80%)]

== Outline

#outline()

= One-way Functions

#align(horizon + center)[#image("images/omelet.jpg", width: 50%)]

== Factoring Numbers

#align(horizon)[
    #text(size: 22pt)[
        Factor this number into two prime numbers:

        $ #{p * q } $
    ]
]

== Euclid GCD (300 BCE)

#link("https://en.wikipedia.org/wiki/Euclidean_algorithm")[Euclidean Algorithm]

#align(horizon + center)[#image("images/euclid.jpg", width: 40%)]

== Easy to check

#align(horizon)[
    #text(size: 22pt)[
        - p: #p
        - q: #q

        $ p dot q = #{p * q } $
    ]
]

= Hash Functions

#definition(title: "Hash Functions")[
    A hash function is any function that can be used to map data of arbitrary
    size to fixed-size values.
]

#definition(title: "Cryptographic Hash Functions")[
    A hash function that has statistical properties  desirable for a
    cryptographic application:

    - One way function
    - Deterministic
    - Collision resistance
]

== SHA-2 and Its Functions

#definition(title: "SHA-2")[
    SHA-2 (Secure Hash Algorithm 2) is a set of cryptographic hash functions
    designed by the United States National Security Agency (NSA) and first
    published in 2001.

    - `SHA-224`
    - `SHA-256`
    - `SHA-384`
    - `SHA-512`
]

== `SHA-256`

Our very special one:

- 64 rounds
- `AND`
- `XOR`
- `OR`
- `ROT`
- `ADD` $mod 2^(32)$

All of these stuff is non-linear and very difficult to keep track,
i.e. no way for you to "autodiff" this.

= Public-key Cryptography

#text(size: 14pt)[
    #definition(title: "Public-key cryptography")[
        Cryptography system that uses pair of keys: private and public.
        Going from private to public is a one-way function.
    ]

    Same idea as the prime number factoring problem:

    - $S_k$: random integer
    - $g$: "generator" number
    - $p$: big fucking prime (4096 bits)
    - $P_k$: $g^(S_k) mod p$
    - Good luck finding $S_k$ from knowing only $P_k$
    - But easy to verify that $P_k = g^(S_k) mod p$
]

= DSA

#text(size: 12pt)[
    #algorithm(title: "DSA Signing")[
        + Choose two prime numbers $p, q$ such that $p - 1 mod q = 0$ (e.g. 1279 and 71) 
        + Choose your private key $S_k$ as a random integer $∈ [1, q-1]$
        + Choose a generator $g$
        + Compute your public key $P_k$: $g^(S_k)$
        + Choose your nonce $k$: as a random integer $∈ [1, q-1]$
        + Compute your "public nonce" $K$: $(g^k mod p) mod q$ (also known as $r$)
        + Get your message ($m$) through a cryptopraphic hash function $H$: $H(m)$
        + Compute your signature $s$: $(k^(1) (H(m) + S_k K)) mod q$
        + Send to your buddy $(p, q, g)$, $P_k$, and $(K, s)$
    ]
]

#text(size: 12pt)[
    #algorithm(title: "DSA Verification")[
        + Compute $w = s^(-1) mod q$
        + Compute $u_1 = H(m) dot w mod q$
        + Compute $u_2 = K dot w mod q$
        + Compute $K^* = (g^(u_1) P^(u_2)_k mod p) mod q$
        + Assert $K = K^*$
    ]
]

== Why this works?

#align(horizon)[
    #text(size: 14pt)[
        #theorem(title: "DSA")[
            - $s = k^(-1) dot (H + S_k K) mod q$ #text(blue)[($mod p$ and $H(m)$ implicit)]
            - $k = s^(-1) dot (H + S_k K) mod q$ #text(blue)[(move $s$ to $k$)]
            - $k = H dot s^(-1) + S_k K dot s^(-1) mod q$ #text(blue)[(distribute $s^(-1)$)]
            - $k = H dot w + S_k K dot w mod q$ #text(blue)[($w = s^(-1)$)]
            - $g^k = g^(H dot w + S_k K dot w mod q)$ #text(blue)[(put $g$ in both sides)]
            - $g^k = g^(H dot w mod q) dot g^(S_k K dot w mod q)$ #text(blue)[(product of the exponents)]
            - $g^k = g^(H dot w mod q) dot g^(S_k)^(K dot w mod q)$ #text(blue)[(power of the power rule)]
            - $g^k = g^(H dot w mod q) dot P^(K dot w mod q)_k$ #text(blue)[($P_k = g^(S_k)$)]
            - $g^k = g^(u_1) dot P^(u_2)_k$ #text(blue)[(replace $u_1$ and $u_2$)]
            - $K = K^*$ #text(blue)[(replace $K$ and $K^*$)]
        ]
    ]
]

= Schnorr

#text(size: 12pt)[
    #algorithm(title: "Schnorr Signing")[
        + Choose a prime number $p$
        + Choose your private key $S_k$ as a random integer $∈ [1, p-1]$
        + Choose a generator $g$
        + Compute your public key $P_k$: $g^(S_k)$
        + Choose your nonce $k$: as a random integer $∈ [1, p-1]$
        + Compute your "public nonce" $K$: $g^k mod p$ (also known as $r$)
        + Get your message ($m$) through a cryptopraphic hash function $H$ concatenating with $K$: $e = H(K || m)$
        + Compute your signature $s$: $k - S_k e$
        + Send to your buddy $(p, g)$, $P_k$, and $(K, s)$
    ]
]

#v(2em)

#text(size: 12pt)[
    #algorithm(title: "Schorr Verification")[
        + Compute $e = H(K || m)$
        + Compute $K^* = g^s P_k^e$
        + Compute $e^* = H(K^* || m)$
        + Assert $e = e^*$
    ]
]

== Why this works?

#align(horizon)[
    #theorem(title: "Schnorr")[
        - $K^* = g^s P_k^e$ #text(blue)[($mod p$ implicit)]
        - $K^* = g^(k - S_k e) g^(S_k e)$ #text(blue)[($s = k - S_k e$ and $P_k = g^(S_k)$)]
        - $K^* = g^k$ #text(blue)[(cancel $S_k e$ in the exponent of $g$)]
        - $K^* = K$ #text(blue)[($K = g^k$)]
        - Hence $H(K^* || m) = H(K || m)$
    ]
]

= Why we don't reuse nonces?

#v(2em)

#text(size: 20pt)[
    #align(horizon + center)[
        *Because we can recover $S_k$*:
    ]
]

== Recovering Nonce in DSA

#align(horizon)[
    $ s' - s = (k'^(-1) (H(m_1) + S_k K')) - (k^(-1) (H(m_2) + S_k K)) $

    If $k' = k$ (nonce reuse) then you can isolate $k$:

    $ s' - s = k^(-1) (H(m_1) - H(m_2)) $

    Remember: you know $s', s, H(m_1), H(m_2), K', K$.

    And then derive $S_k$:

    $ S_k = K^(-1) (k s - H(m)) $
]

== Recovering Nonce in Schnorr

#align(horizon)[
    $ s' - s = (k' - k) - S_k (e' - e) $

    If $k' = k$ (nonce reuse) then you can easily isolate $S_k$ with simple algebra.

    Remember: you know $s', s, e, e'$ and $k' - k = 0$.
]

= Why we can combine Schnorr $P_k$ and not DSA?

#text(size: 12pt)[
    Revisit the signature step in each one:

    - DSA: $s = k^(-1) (H(m) + S_k K)$
    - Schorr: $s = k - S_k H(K || m)$

    Modular addition, i.e. anything with $+, dot, -$, is linear:

    $ P'_k + P_k = g^(S'_k) + g^(S_k) = g^(S_k' + S_k) $

    and $s' + s$ in Schnorr is signed from $S_k' + S_k$ (assuming $m' = m$).

    Modular inverse, i.e. anything with $x^(-1)$, is _not_ linear
    and $s' + s'$ in DSA is _not_ signed from $S_k' + S_k$ (assuming $m' = m$).
]
