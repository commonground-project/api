IMAGE_NAME = swagger-server
CONTAINER_NAME = swagger-server-container
MOCK_IMAGE_NAME = stoplight/prism:4
MOCK_CONTAINER_NAME = mock-api-container
HOST_PORT = 8000
CONTAINER_PORT = 8000
MOCK_ENDPOINT_PORT = 4010
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

mock: 
	docker run -d --rm --init --name $(MOCK_CONTAINER_NAME) \
		-v $(CUR_DIR):/api \
		-p $(MOCK_ENDPOINT_PORT):$(MOCK_ENDPOINT_PORT) $(MOCK_IMAGE_NAME) \
		mock -h 0.0.0.0 "/api/openapi.yaml"

stop:
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)
	-docker stop $(MOCK_CONTAINER_NAME)

clean: stop
	-docker rmi $(IMAGE_NAME)
	-docker rmi $(MOCK_IMAGE_NAME)
