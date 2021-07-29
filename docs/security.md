# Security

Last review: 21 july 2021

This document describes the policies and measures

## Web Application Security Policy

A [Web Application Security Policy is in place](https://github.com/qkunst/collectiemanagement/blob/main/SECURITY.md). The purpose of this policy is to define web application security assessments within QKunst. Web application assessments are performed to identify potential or realized weaknesses as a result of inadvertent mis-configuration, weak authentication, insufficient error handling, sensitive information leakage, etc. Discovery and subsequent mitigation of these issues will limit the attack surface of QKunst services available both internally and externally as well as satisfy compliance with any relevant policies in place.

## Automated security scans

In our [Web Application Security Policy](https://github.com/qkunst/collectiemanagement/blob/main/SECURITY.md) tools used for automatic scanning are described.

## Connection

Access to the application is only possible via a secured HTTPS connection (min. TLS v. 1.2). This HTTPS connection is both enforced by the application as well as the server. We use
Strict Transport Security (HSTS) to inform browsers that our application cannot be accessed otherwise.

### Applied cryptography

> #### TLS 1.3 (server has no preference)
>
> TLS_AES_128_GCM_SHA256 (0x1301)   ECDH x25519 (eq. 3072 bits RSA)   FS 	128
> TLS_AES_256_GCM_SHA384 (0x1302)   ECDH x25519 (eq. 3072 bits RSA)   FS 	256
> TLS_CHACHA20_POLY1305_SHA256 (0x1303)   ECDH x25519 (eq. 3072 bits RSA)   FS 	256
>
> #### TLS 1.2 (server has no preference)
>
> TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 (0x9e)   DH 2048 bits   FS 	128
> TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (0xc02f)   ECDH secp521r1 (eq. 15360 bits RSA)   FS 	128
> TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (0x9f)   DH 2048 bits   FS 	256
> TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (0xc030)   ECDH secp521r1 (eq. 15360 bits RSA)   FS 	256
> TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xcca8)   ECDH secp521r1 (eq. 15360 bits RSA)   FS 	256

We strive for a A or higher score at [Qualys SSL Report: collectiemanagement.qkunst.nl](https://www.ssllabs.com/ssltest/analyze.html?d=collectiemanagement.qkunst.nl) (last observed score A+)

We use Let's Encrypt which offers short lived certificates.

## Passwords

Passwords are never stored in plain text. For authentication purposes we hash passwords 10 times using the [bcrypt algorithm](https://en.wikipedia.org/wiki/Bcrypt).

## API

The API is limited to read operations.

### API

The API uses the same HTTPS Connection as the end-user interface. To sign requests, requests need to be signed with a [hash based message authentication code](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code) (HMAC),
which uses a SHA512 digest.

Keys to generate these HMACs have no configured life-span but can be reset upon request.

API requests operate at a minimum of a advisor level, essentially granting access to everything within a certain collection.

## Server management

For our deployments we use OpenSSH using SSH-keys. All servers have automatic, daily security updates configured.

We do not allow for connecting with anything other than SSH-keys, nor is root access allowed. Otherwise we follow the default SSH configuration from the Debian Project.

SSH access is only available to requests coming from whitelisted IP-addresses, both at firewall as well at deployment-server level.