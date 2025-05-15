# Image name and version tag
IMAGE_NAME := pyramation/node-sqitch
TAG := 20.12.0

# Architectures to build for
PLATFORMS := linux/amd64,linux/arm64

# Build multi-arch Docker image using buildx
build:
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_NAME):$(TAG) \
		--output=type=docker \
		./node-sqitch

# Tag the image as "latest"
tag-latest:
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):latest

# Push Docker image (both versioned and latest tags)
push: tag-latest
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_NAME):$(TAG) \
		-t $(IMAGE_NAME):latest \
		--push \
		./node-sqitch
	@echo "Image pushed with tags: $(TAG) and latest"

# Open an interactive shell in the Docker container (with platform specified)
ssh:
	docker run --platform=linux/arm64 -it $(IMAGE_NAME):$(TAG)

# Clean Git repository and remove untracked files
clean:
	@git reset --hard
	@git ls-files --other --exclude-standard | xargs rm -f

# Cleanup any existing container with the name "node-sqitch"
cleanup:
	@if [ ! -z "$$(docker ps -aq -f name=node-sqitch)" ]; then \
		echo "Stopping and removing existing container..."; \
		docker stop node-sqitch && docker rm node-sqitch; \
	fi

# Remove all Docker images for this project (optional)
clean-images:
	@if docker images | grep $(IMAGE_NAME); then \
		echo "Removing Docker images for $(IMAGE_NAME)..."; \
		docker rmi $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):latest || true; \
	fi

# Convenience target for full reset: Cleanup, rebuild, and push
reset: cleanup push
