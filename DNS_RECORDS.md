# DNS Records untuk ucentric.id

## Records Wajib

| Type | Host/Name | Value | Priority |
|------|-----------|-------|----------|
| A | mail | [IP_SERVER_ANDA] | - |
| MX | @ | mail.ucentric.id | 10 |
| TXT | @ | v=spf1 mx ~all | - |
| TXT | _dmarc | v=DMARC1; p=quarantine; rua=mailto:admin@ucentric.id | - |
| TXT | mail._domainkey | v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqJ1fCANkw9KPEZR1xm0kULwcf+rTBiInjuFHODqJBZ0cB5V/RT8ctVGZL26k0vi5Y6GXMn/oFgVDTldXybVwo8R4T1x4JhL5pUkQv1Sg4TgyyjADWHNOdFPNYJUjW9nMrg4hSy33sAIwsxxTiQdF8jHiHUYSWZVOE+x52RAwm3ccD8gNoJGSz2P94sXC40F+lNM2YV4tLPbDc9ZewPQpwX+hNjBaAWdXLaanLvHhSaSn1sfbWb9FJ1QWujjhyjRQowxo6YHt8tdzd3YfEZzghUPmHQtHBQlCQ9T0sS9keOMxsgXfi+o+uO9LnsFmAXsVTgfw3jkV4hfrXtbTq973iQIDAQAB | - |

## Penjelasan

| Record | Fungsi |
|--------|--------|
| A | Mengarahkan subdomain mail ke IP server |
| MX | Menentukan mail server untuk domain |
| SPF | Mencegah email spoofing |
| DMARC | Kebijakan autentikasi email |
| DKIM | Digital signature untuk verifikasi email |

## Cara Cek IP Server

```bash
curl ifconfig.me
```

## Verifikasi DNS

Setelah semua record ditambahkan, cek dengan:

```bash
# Cek MX
dig MX ucentric.id

# Cek SPF
dig TXT ucentric.id

# Cek DKIM
dig TXT mail._domainkey.ucentric.id

# Cek DMARC
dig TXT _dmarc.ucentric.id
```
