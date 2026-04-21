# Apple OAuth test fixtures

This directory is intentionally empty of real Apple material.

`tests/domains/auth/test_adapters.py` generates a fresh RSA keypair per test
run, publishes the public half as a JWKS document via `respx`, and signs
identity_tokens inline. **Do not commit real Apple private keys, real
Apple-issued JWKS contents, or real identity_tokens from a developer
account.**

If you add canned JWKS snapshots in the future, strip everything except the
public RSA parameters (kty / n / e / kid / alg / use) and confirm they were
never valid for a production audience.
