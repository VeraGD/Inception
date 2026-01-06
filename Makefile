DATA_PATH = /home/veragarc/data
DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m


# Regla principal: crear carpetas y levantar el proyecto
all:
	@echo "$(GREEN)Creating directorios of volumes...$(RESET)"
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@echo "$(GREEN)Building and initilization dockers...$(RESET)"
	@$(DOCKER_COMPOSE) up --build -d

# Detener dockers sin borrarlos
stop:
	@echo "$(RED)Stoping dockers...$(RESET)"
	@$(DOCKER_COMPOSE) stop

# Arranca dockers ya creados
start:
	@echo "$(GREEN)Initiating dockers...$(RESET)"
	@$(DOCKER_COMPOSE) start

# Detiene y borra contenedores y redes
down:
	@echo "$(RED)Taking down infrastructure...$(RESET)"
	@$(DOCKER_COMPOSE) down

# Limpieza suave: borra contenedores e imagenes
clean: down
	@echo "$(RED)Eliminating images ang volumes of docker...$(RESET)"
	@docker system prune -a --volumes -f

# Limpieza total, borra tambien los datos del disco duro. Borra para siempre tu base de datos y tu web para siempre.
fclean: clean
	@echo "$(RED)Eliminating persistant data in $(DATA_PATH)...$(RESET)"
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@echo "$(GREEN)Deep cleaning finish.$(RESET)"

re: fclean all

.PHONY: all stop start down clean fclean re
