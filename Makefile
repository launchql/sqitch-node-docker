# Image name and version tag
IMAGE_NAME := pyramation/pstricks-latex
TAG := 1.0.0

# Default target: Build and run the Docker Compose environment
def: cleanup
	docker-compose down && docker-compose build && docker-compose up

# Open an interactive shell in the LaTeX Docker container
ssh:
	docker run -v `pwd`/tex:/usr/src -i -t $(IMAGE_NAME) /bin/bash

# Clean Git repository and remove untracked files
clean:
	@git reset --hard
	@git ls-files --other --exclude-standard | xargs rm -f

# Build the LaTeX document using Docker
tex:
	docker run -v `pwd`/tex:/usr/src $(IMAGE_NAME) pdflatex test.tex

# Build the LaTeX document with PSTricks using Docker
pstricks:
	docker run -v `pwd`/tex:/usr/src $(IMAGE_NAME) sh -c "\
		latex test.tex && \
		dvips test.dvi -o test.ps && \
		ps2pdf test.ps test.pdf"

# Clean LaTeX auxiliary files
clean-latex:
	find tex/ -type f \( -name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.synctex.gz" -o -name "*.toc" \) -delete

# Build Docker image using the Dockerfile in ./latex
build: cleanup
	docker build -t $(IMAGE_NAME):$(TAG) ./latex

# Tag the image as "latest"
tag-latest:
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):latest

# Push Docker image (both versioned and latest tags)
push: build tag-latest
	docker push $(IMAGE_NAME):$(TAG)
	docker push $(IMAGE_NAME):latest
	echo "Image pushed with tags: $(TAG) and latest"

# Cleanup any existing container with the name "pstricks-latex"
cleanup:
	@if [ ! -z "$$(docker ps -aq -f name=pstricks-latex)" ]; then \
		echo "Stopping and removing existing container..."; \
		docker stop pstricks-latex && docker rm pstricks-latex; \
	fi

# Remove all Docker images for this project (optional)
clean-images:
	@if docker images | grep $(IMAGE_NAME); then \
		echo "Removing Docker images for $(IMAGE_NAME)..."; \
		docker rmi $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):latest || true; \
	fi

# Convenience target for full reset: Cleanup, rebuild, and push
reset: cleanup clean-latex build push
