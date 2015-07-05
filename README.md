# Google Contacts

Present here is a (limited) Google Contacts API client library, an executable
that uses that library to query contacts from within [Mutt][], and a Dockerfile
for ease of use by those without a Haskell installation.

[mutt]: http://www.mutt.org/

This project is installable as a normal Haskell package, but the instructions in
this README focus on a streamlined, Docker-based flow. If you haven't yet,
install and configure [Docker][].

[docker]: https://www.docker.com/

## OAuth Setup

- Register a project in Google's [API Console][console]
- Enable the Contacts API for the project
- Create OAuth2 credentials for the project
- Note your Client ID and Secret

[console]: https://code.google.com/apis/console#access

## Installation

```
docker pull pbrisbin/google-contacts
docker run --name gc-config -it \
  -e GOOGLE_OAUTH_CLIENT_ID=... \
  -e GOOGLE_OAUTH_CLIENT_SECRET=... \
  pbrisbin/google-contacts config you@gmail.com
```

*Note*: multiple emails may be passed at once.

## Usage

```
docker run --rm --volumes-from gc-config \
  pbrisbin/google-contacts mutt-query you@gmail.com query
```

## Configuring Mutt

```
set query_command = "docker run ... you@gmail.com '%s'"
```
