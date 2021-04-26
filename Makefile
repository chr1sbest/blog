# Setup development environment
setup:
	yarn global add knex-migrator grunt-cli ember-cli bower
	yarn setup
	pip install buster

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

replace-local:
	grep -rl localhost:2368 static/ | xargs sed -i -- 's/localhost\:2368/chrisbest\.com/g'

# Serve static content locally to test
serve:
	grep -rl localhost:2368 static/ | xargs sed -i -- 's/localhost\:2368/localhost\:8000/g'
	cd static; python -m SimpleHTTPServer

# Upload new static content to S3
upload:
	aws s3 sync static/ s3://chrisbest.com/
	aws s3 cp posts.json s3://chrisbest-private/

# Bust S3 Cache
bust-cache:
	aws cloudfront create-invalidation --distribution-id ESUFV9I55SS5I --paths '/*'

# Generate static files, upload them to S3, and bust cloudfront cache
push: generate replace-local upload bust-cache
