NAME		=	inception

all			: 	$(NAME)

$(NAME)		:
				docker-compose -f srcs/docker-compose.yml up --force-recreate --build

install		:	
				docker-compose -f srcs/docker-compose.yml up --force-recreate --build

clean		:	
				docker-compose -f srcs/docker-compose.yml down 

fclean		:	clean
				rm -rf home/flmarsil/data/wordpress/*
				rm -rf home/flmarsil/data/mariadb/*
				rm -rf home/flmarsil/data/adminer/*
				docker volume rm srcs_mariadb_data srcs_wordpress_data srcs_adminer_data

.PHONY		:	all clean fclean