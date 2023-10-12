IMAGE_NAME := const_layout
CONTAINER_NAME := $(IMAGE_NAME)
PORT_START := 30000
PORT_END := 31000
SSH_PORT := 31022
TENSORBOARD_PORT := 31006
ROOT := /const_layout
VSFS := /cvl-gen-vsfs1/

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) --build-arg ROOT=$(ROOT) .

.PHONY: run
run:
	docker run -it --name $(CONTAINER_NAME) \
		--gpus all \
		-p $(PORT_START)-$(PORT_END):$(PORT_START)-$(PORT_END) \
		-p $(SSH_PORT):22 \
        -p $(TENSORBOARD_PORT):6006 \
		-v `pwd`:$(ROOT) \
		-v $(VSFS):$(VSFS) \
		--shm-size 32GB \
		$(IMAGE_NAME) \
		/bin/bash