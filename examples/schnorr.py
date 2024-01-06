# constants
p = 1279
h = 2
g = 2

# public key pair
s_k = 17
p_k = pow(g, s_k, p)

# helper functions
def concat_bytes(a, b):
    a_bytes = a.to_bytes((a.bit_length() + 7) // 8, 'big')
    b_bytes = b.to_bytes((b.bit_length() + 7) // 8, 'big')
    result = a_bytes + b_bytes
    return int.from_bytes(result, byteorder='big')

# sign
m = 17 # message
k = 5
K = pow(g, k, p)
e = concat_bytes(K, m)
s = k - s_k * e
assert K !=0 and s!= 0

# verify
K_star = (pow(g, s, p) * pow(p_k, e, p)) % p
e_star = concat_bytes(K_star, m)
assert e == e_star
print("signature valid")
