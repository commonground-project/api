IMAGE_NAME = swagger-server
CONTAINER_NAME = swagger-server-container
HOST_PORT = 8080
CONTAINER_PORT = 8080
CUR_DIR = $(shell pwd)

build:
	docker build -t $(IMAGE_NAME) .

run: stop build
	docker run -d --name $(CONTAINER_NAME) \
		-p $(HOST_PORT):$(CONTAINER_PORT) \
		-v $(CUR_DIR)/openapi.yaml:/app/public/swagger.yaml \
		-v $(CUR_DIR)/paths:/app/public/paths \
		-v $(CUR_DIR)/schemas:/app/public/schemas \
		-v $(CUR_DIR)/parameters:/app/public/parameters \
		-v $(CUR_DIR)/definitions:/app/public/definitions \
		$(IMAGE_NAME)

stop:
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)

clean: stop
	-docker rmi $(IMAGE_NAME)
