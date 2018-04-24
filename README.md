# Google Contacts

Present here is a (limited) Google Contacts API client library and an executable
that uses that library to query contacts from within [Mutt][].

[mutt]: http://www.mutt.org/

## OAuth Setup

- Register a project in Google's [API Console][console]
- Enable the Contacts API for the project
- Create OAuth2 credentials for the project
- Note your Client ID and Secret

[console]: https://code.google.com/apis/console#access

## Installation

```
git clone https://github.com/pbrisbin/google-contacts
cd google-contacts
make CLIENT_ID=x CLIENT_SECRET=y
make install
```

**NOTE**: This will create `src/Client.hs` with your client credentials.

## Setup

```
gc-config you@gmail.com
```

**NOTE**: This will create `~/.cache/contacts/` for caching OAuth tokens.

## Usage

```
gc-mutt-query you@gmail.com query
```

## Configuring Mutt

```
set query_command = "gc-mutt-query you@gmail.com '%s'"
```

---

[LICENSE](./LICENSE)
