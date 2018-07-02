# Setup development environment
setup:
	yarn global add knex-migrator grunt-cli ember-cli bower
	yarn setup
	pip install buster
	./scripts/patch_ghost_hunter.sh

# Run the local Ghost CMS to edit posts and style
dev:
	grunt dev

generate:
	# Generate static content while running Ghost locally
	buster generate --domain=http://localhost:2368/
	# Generate mock JSON output while running Ghost locally.
	wget 'localhost:2368/rss' -O content/themes/blacklist/assets/output.xml
	cp content/themes/blacklist/assets/output.xml static/assets/output.xml

# Serve static content locally to test
serve:
	cd static; python -m SimpleHTTPServer

# Upload new static content to S3
upload:
	aws s3 cp static/ s3://chrisbest.com/ --recursive
