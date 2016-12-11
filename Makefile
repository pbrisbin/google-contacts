app/Client.hs:
	[ -n "$(CLIENT_ID)" ]
	[ -n "$(CLIENT_SECRET)" ]
	echo "module Client where" > app/Client.hs
	echo "clientId, clientSecret :: String" >> app/Client.hs
	printf 'clientId = "%s"\n' "$(CLIENT_ID)" >> app/Client.hs
	printf 'clientSecret = "%s"\n' "$(CLIENT_SECRET)" >> app/Client.hs

install: app/Client.hs
	stack install

.PHONY: install
.DEFAULT: app/Client.hs
