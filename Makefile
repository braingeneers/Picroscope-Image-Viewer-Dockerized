CONTAINER = "braingeneers/images:latest"
IMAGE_NAME = "image-viewer"

build:
	docker build -t $(CONTAINER) .

#build-and-test:
#	docker build -f Dockerfile -t $(CONTAINER) .
#	docker run -v ~/.aws/credentials:/root/.aws/credentials:ro -v  $(PWD)/users.py:/console/users.py --rm -it -p 8050:8050 $(CONTAINER)

push:
	docker push $(CONTAINER)


shell:
	docker run -it -p 8080:8080 --rm --name $(IMAGE_NAME) --entrypoint /bin/sh $(CONTAINER)

run:
	docker run -it -p 8080:80 --rm --name $(IMAGE_NAME) $(CONTAINER)

run-prod:  	# run in production on gi server
	docker run -d --rm -p 127.0.0.1:8055:80 --name $(IMAGE_NAME) $(CONTAINER)

#run-test:   # run in parallel on production gi server on a different port (8051)
#	docker pull braingeneers/dashboard:latest && \
#	docker run -d -v ~/.aws/credentials:/root/.aws/credentials:ro -p 0.0.0.0:8051:8050 $(CONTAINER)

run-dev:	# run local dev instance in docker container
	docker run -d --rm -p 0.0.0.0:8055:80 --name $(IMAGE_NAME) $(CONTAINER)

# Creates a versioned tag from :latest, uses the version number in $NEXT_RELEASE_CONTAINER defined above
# Also updates the default production tag to the latest (this tag is used to start the latest production container on boot)
#release:
#	docker tag $(CONTAINER) $(NEXT_RELEASE_CONTAINER) && \
	docker push $(NEXT_RELEASE_CONTAINER) && \
	docker tag $(NEXT_RELEASE_CONTAINER) "braingeneers/piscope-control:prod" && \
	docker push "braingeneers/piscope-console:prod"

