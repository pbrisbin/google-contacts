# Contacts

*New, less generic name TBD*

Use Google Contacts API to implement a Mutt `$query_command`.

## Installation

```
git clone https://github.com/pbrisbin/contacts && cd contacts
cabal sandbox init
cabal install --dependencies-only
cabal build
```

Place the binary somewhere in `$PATH`, e.g.:

```
sudo cp dist/build/contacts/contacts /bin/google-contacts
```

## Usage

- Register a project in Google's [API Console][console]
- Enable the Contacts API for the project
- Create OAuth2 credentials for the project

[console]: https://code.google.com/apis/console#access

```
export GOOGLE_OAUTH_CLIENT_ID=abc123
export GOOGLE_OAUTH_CLIENT_SECRET=abc123
google-contacts "you@gmail.com" "some-query"
```

## Usage with Mutt

Assuming Mutt's execution will see the required environment variables:

```
set query_command = "google-contacts you@gmail.com '%s'"
```

**Note**: the first time you run the command, you'll have to do the OAuth2
verification, so be sure to do this outside of Mutt.
