# Variables
USER_HOME = /home/${USER}
PROJECT_DIR = ./srcs
DATA_DIR = $(USER_HOME)/data

# Targets
all:
	mkdir -p $(DATA_DIR)/mariadb && \
	mkdir -p $(DATA_DIR)/wordpress && \
	@cd $(PROJECT_DIR) && docker compose up --build -d

down:
	@cd $(PROJECT_DIR) && docker compose down

stop: 
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi

container_clean:
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa); fi

images_clean:
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa); fi

volume_clean:
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi

network_clean:
	@if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2>/dev/null || true; fi

clean:
	docker system prune -a --volumes --force

fclean: stop container_clean images_clean volume_clean network_clean

re: fclean all
