setup:
	yarn global add knex-migrator grunt-cli ember-cli bower
	yarn setup
	pip install buster

dev:
	grunt dev

generate:
	buster generate --domain=http://localhost:2368/

serve:
	cd static; python -m SimpleHTTPServer

upload:
	aws s3 cp static/ s3://chrisbest.com/ --recursive
