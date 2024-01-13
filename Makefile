SHELL := /bin/bash

tests:
	docker compose exec app symfony console doctrine:database:drop --force --env=test || true
	docker compose exec app symfony console doctrine:database:create --env=test
	docker compose exec app symfony console doctrine:migrations:migrate -n --env=test
	docker compose exec app symfony console doctrine:fixtures:load -n --env=test
	docker compose exec app symfony php bin/phpunit $(MAKECMDGOALS)
.PHONY: tests
