all: build run

data:
	@if [ ! -d "home/luis-ffe/data/mariadb" ] && [ ! -d "home/luis-ffe/data/wordpress;" ]; then \
	mkdir -p home/luis-ffe/data/mariadb && mkdir -p home/luis-ffe/data/wordpress; fi

build: data
	docker compose -f srcs/docker-compose.yml build

run:
	docker compose -f srcs/docker-compose.yml up -d

exec:
	$(eval service=$(filter-out $@,$(MAKECMDGOALS)))
	docker compose -f srcs/docker-compose.yml exec $(service) bash

down:
	docker compose -f srcs/docker-compose.yml down

clean:
	docker compose -f srcs/docker-compose.yml down --rmi all

vclean:
	docker compose -f srcs/docker-compose.yml down --rmi all -v
	@sudo rm -rf home

fclean: vclean
	docker system prune -af

list:
	docker ps -a

volumes:
	docker volume ls

images:
	docker image ls

network:
	docker network ls

full: list volumes images network

.SILENT:
