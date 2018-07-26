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
	# Export POSTS into JSON to track in git
	# access_token is for local dev
	wget 'localhost:2368/ghost/api/v0.1/db/?access_token=${GHOST_TOKEN}' -O posts.json

# Serve static content locally to test
serve:
	cd static; python -m SimpleHTTPServer

# Upload new static content to S3
upload:
	aws s3 sync static/ s3://chrisbest.com/
	aws s3 cp posts.json s3://chrisbest-private/
