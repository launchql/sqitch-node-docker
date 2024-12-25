# Version tag for the Docker image
TAG := 1.0.0

# Default target: Build and run the Docker Compose environment
def: cleanup
	docker-compose down && docker-compose build && docker-compose up

# Open an interactive shell in the LaTeX Docker container
ssh:
	docker run -v `pwd`/tex:/usr/src -i -t pyramation/pstricks-latex /bin/bash

# Clean Git repository and remove untracked files
clean:
	@git reset --hard
	@git ls-files --other --exclude-standard | xargs rm -f

# Build the LaTeX document using Docker
tex:
	docker run -v `pwd`/tex:/usr/src pyramation/pstricks-latex pdflatex test.tex

# Clean LaTeX auxiliary files
clean-latex:
	find tex/ -type f \( -name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.synctex.gz" -o -name "*.toc" \) -delete

# Build Docker image using the Dockerfile in ./latex
build: cleanup
	docker build -t pyramation/pstricks-latex:$(TAG) ./latex

# Tag and push Docker image
push:
	docker tag pyramation/pstricks-latex:$(TAG) pyramation/pstricks-latex:$(TAG)
	docker push pyramation/pstricks-latex:$(TAG)
	echo "Image pushed with tag: $(TAG)"

# Cleanup any existing container with the name "pstricks-latex"
cleanup:
	@if [ ! -z "$$(docker ps -aq -f name=pstricks-latex)" ]; then \
		echo "Stopping and removing existing container..."; \
		docker stop pstricks-latex && docker rm pstricks-latex; \
	fi
