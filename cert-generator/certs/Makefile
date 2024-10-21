.PHONY: all clean

all: ingress-ca server client 

ingress-ca: ingress-ca.key ingress-ca.crt ingress-ca.jks

server: ORGANISATION_UNIT = ClientEng-SERVER
server: server.key server.crt server.jks server.kdb 

client: ORGANISATION_UNIT = ClientEng-CLIENT
client: client.key client.crt client.jks



clean:
	rm -f server.key server.crt server.p12 server.jks server.kdb server.sth
	rm -f client.key client.crt client.jks
	rm -f ingress-ca.key ingress-ca.crt ingress-ca.jks ingress-ca.srl

ingress-ca.key:
	openssl genrsa \
		-des3 \
		-passout pass:passw0rd \
		-out ingress-ca.key 4096

ingress-ca.crt: ingress-ca.key
	openssl req \
		-x509 \
		-new \
		-sha256 \
		-key ingress-ca.key \
		-passin pass:passw0rd \
		-days 365 \
		-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANISATION}/OU=${ORGANISATION_UNIT}/CN=${COMMON_NAME}" \
		-out ingress-ca.crt

ingress-ca.jks: ingress-ca.crt
	rm -f ingress-ca.jks
	keytool -keystore ingress-ca.jks \
		-deststorepass passw0rd \
		-storetype jks \
		-importcert \
		-file ingress-ca.crt \
		-alias ingress-ca-certificate \
		-noprompt

server.kdb: ingress-ca.crt server.p12
	rm -f server.kdb
	rm -f server.rdb
	rm -f server.sth
	rm -f server.crl
	
	runmqakm -keydb \
		-create -db server.kdb \
		-pw passw0rd \
		-type cms \
		-expire 365 \
		-stash

	runmqakm -cert \
		-add -label mqserver \
		-db server.kdb \
		-pw passw0rd \
		-trust enable \
		-file ingress-ca.crt

	runmqckm -cert \
		-import -file server.p12 \
		-pw passw0rd \
		-type pkcs12 \
		-target server.kdb \
		-target_pw passw0rd \
		-target_type cms \
		-label server-pkcs12 \
		-new_label client

	rm -f server.rdb
	rm -f server.crl


%.key:
	openssl genrsa -out $@ 2048

%.csr: %.key
	openssl req \
		-new \
		-sha256 \
		-key $< \
		-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANISATION}/OU=${ORGANISATION_UNIT}/CN=${COMMON_NAME}" \
		-sha256 \
		-out $@

%.crt: %.csr ingress-ca.crt ingress-ca.key
	openssl x509 \
		-req \
		-sha256 \
		-in $< \
		-extfile san.ext \
		-CA ingress-ca.crt \
		-CAkey ingress-ca.key \
		-CAcreateserial \
		-passin pass:passw0rd \
		-days 365 \
		-sha256 \
		-out $@

%.p12: %.crt %.key
	openssl pkcs12 -export \
		-in $(basename $@).crt \
		-inkey $(basename $@).key \
		-out $@ \
		-passout pass:passw0rd \
		-name $(basename $@)-pkcs12

%.jks: %.p12
	rm -f $@
	keytool -importkeystore \
		-deststorepass passw0rd \
		-destkeypass passw0rd \
		-destkeystore $@ \
		-srckeystore $(basename $@).p12 \
		-srcstoretype PKCS12 \
		-srcstorepass passw0rd \
		-alias $(basename $@)-pkcs12