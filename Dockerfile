FROM haskell:7.10
MAINTAINER Pat Bribin <pbrisbin@gmail.com>

RUN mkdir /app
WORKDIR /app

COPY google-contacts.cabal /app/google-contacts.cabal
RUN cabal update
RUN cabal install --dependencies-only --enable-tests

COPY src /app/src
COPY test /app/test
COPY LICENSE /app/LICENSE
RUN cabal test
COPY Token.hs /app/Token.hs
COPY config.hs /app/config.hs
COPY mutt-query.hs /app/mutt-query.hs
RUN cabal build
COPY bin/run /app/run

RUN mkdir -p /root/.cache/contacts
VOLUME /root/.cache/contacts

# Bogus values to prevent getEnv from raising. They must be overridden when
# performing the config command and will be unused once cached values are
# present
ENV GOOGLE_OAUTH_CLIENT_ID=x
ENV GOOGLE_OAUTH_CLIENT_SECRET=x

ENTRYPOINT ["/app/run"]
