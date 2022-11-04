GIT_REF_TAG := $(shell git show-ref --head | head -n 1 | awk '{print $$1}' | cut -c35-)
REGISTRY = asajaroff/sample-django-app

build:
	podman build . -t $(REGISTRY):$(GIT_REF_TAG) -t $(REGISTRY):latest
	
push:
	podman push docker.io/$(REGISTRY):$(GIT_REF_TAG)

run:
	podman run -d -p 8000:8000 $(REGISTRY):$(GIT_REF_TAG)

CONTAINER_ID = $(shell podman ps | grep 'elplebiscito' | awk '{print $$1}')

stop:
	podman stop $(CONTAINER_ID)

