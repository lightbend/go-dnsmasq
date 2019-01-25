registry := lightbend-docker-registry.bintray.io
image := $(registry)/lightbend/go-dnsmasq
git_rev := $(shell git rev-parse --short HEAD)
git_tag := $(shell git tag --points-at=$(git_rev))

.PHONY: docker
docker:
	docker build . -t $(image):latest

.PHONY: docker-login
docker-login:
	@docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD) $(registry)

.PHONY: release
docker-release: docker docker-login
	@echo "Releasing $(image):latest"
	docker push $(image):latest
	@echo "Releasing $(image):$(git_tag)"
	docker tag $(image):latest $(image):$(git_tag)
	docker push $(image):$(git_tag)
