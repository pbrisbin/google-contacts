# Google Contacts

A pretty-dumb Google Contacts API client for the sole purpose of outputting
contacts suitably for Mutt's `$query_command`.

## Installation

```
git clone https://github.com/pbrisbin/google-contacts && cd google-contacts
cabal sandbox init
cabal install --dependencies-only
cabal build
```

## Usage

- Register a project in Google's [API Console][console]
- Enable the Contacts API for the project
- Create OAuth2 credentials for the project

[console]: https://code.google.com/apis/console#access

```
export GOOGLE_OAUTH_CLIENT_ID=abc123
export GOOGLE_OAUTH_CLIENT_SECRET=abc123
cabal run -- you@gmail.com query
```

## Integrating with Mutt

I suggest the following approach:

- Create a `.env` file:

  ```
  GOOGLE_OAUTH_CLIENT_ID=abc123
  GOOGLE_OAUTH_CLIENT_SECRET=abc123
  ```

- Write a small wrapper script:

  ```sh
  #!/bin/sh
  cd /path/to/google-contacts

  source ./.env # set CLIENT_ID/CLIENT_SECRET
  dist/build/gc-mutt-query/gc-mutt-query "$@"
  ```

- Configure Mutt:

  ```
  set query_command = "/path/to/wrapper you@gmail.com '%s'"
  ```

**Note**: the first time you run the command, you'll have to do the OAuth2
verification, so be sure to do this outside of Mutt.
