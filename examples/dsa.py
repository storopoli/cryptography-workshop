# constants
p, q = (1279, 71)
assert (p - 1) % q == 0
h = 2
g = pow(h, (p - 1) // q, p)

# public key pair
s_k = 17
p_k = pow(g, s_k, p)

# sign
H = 17 # hash value
k = 5
K = pow(g, k, p) % q
s = (pow(k, -1, q) * (H + s_k * K)) % q
assert K !=0 and s!= 0

# verify
w = pow(s, -1, q)
u1 = (H * w) % q
u2 = (K * w) % q
K_star = ((pow(g, u1, p) * pow(p_k, u2, p)) % p) % q
assert K == K_star
print("signature valid")
