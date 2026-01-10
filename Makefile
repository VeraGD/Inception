# Detección automática del usuario y ruta
LOGIN       = $(shell whoami)
DATA_PATH   = /home/$(LOGIN)/data
DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml

# Colores
GREEN = \033[0;32m
RED   = \033[0;31m
RESET = \033[0m

# Regla principal
all: host up

# Levanta el proyecto (Crea carpetas + Build + Up)
up:
	@echo "$(GREEN)Creating directories for volumes at $(DATA_PATH)...$(RESET)"
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@echo "$(GREEN)Building and initializing dockers...$(RESET)"
	@# Pasamos la variable DATA_PATH al comando para que la lea el docker-compose.yml
	DATA_PATH=$(DATA_PATH) $(DOCKER_COMPOSE) up --build -d

# Arranca contenedores que ya existían pero estaban parados
start:
	@echo "$(GREEN)Starting dockers...$(RESET)"
	@$(DOCKER_COMPOSE) start

# Tumba la infraestructura
down:
	@echo "$(RED)Taking down infrastructure...$(RESET)"
	@DATA_PATH=$(DATA_PATH) $(DOCKER_COMPOSE) down

# Limpieza de contenedores e imágenes
clean: down
	@echo "$(RED)Eliminating images and docker volumes...$(RESET)"
	@docker system prune -a --volumes -f

# Limpieza total (Borra también los datos del disco)
fclean: clean
	@echo "$(RED)Eliminating persistent data in $(DATA_PATH)...$(RESET)"
	@# Usamos sudo porque los archivos creados por Docker suelen pertenecer a root
	@sudo rm -rf $(DATA_PATH)
	@echo "$(GREEN)Deep cleaning finished.$(RESET)"

# Reconstrucción total
re: fclean all

# Configuración del dominio local
host:
	@echo "$(GREEN)Setting local domain in /etc/hosts...$(RESET)"
	@grep -q "veragarc.42.fr" /etc/hosts || echo "127.0.0.1 veragarc.42.fr" | sudo tee -a /etc/hosts

.PHONY: all up start down clean fclean re host
