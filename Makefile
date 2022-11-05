GIT_REF_TAG := $(shell git show-ref --head | head -n 1 | awk '{print $$1}' | cut -c35-)
REGISTRY = asajaroff/sample-django-app

build:
	podman build . -t $(REGISTRY):$(GIT_REF_TAG) -t $(REGISTRY):latest
	
push:
	podman push docker.io/$(REGISTRY):$(GIT_REF_TAG)

run:
	podman run -d -p 8000:8000 $(REGISTRY):$(GIT_REF_TAG)

CONTAINER_ID = $(shell podman ps | grep '$(REGISTRY)' | awk '{print $$1}')

stop:
	podman stop $(CONTAINER_ID)


## Django-related

migrations: migrations-run migrations-show migrations-migrate

migrations-run: 
	python3 src/manage.py makemigrations

migrations-show: 
	python3 src/manage.py showmigrations

migrations-migrate: 
	python3 src/manage.py migrate
	make migrations-show


runserver:
	python3 src/manage.py runserver

