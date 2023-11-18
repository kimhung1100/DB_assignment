.PHONY: test

run-dev:
	python src/main.py

test:
	PYTHONPATH=.:src pytest --disable-pytest-warnings --capture=no

run-celery:
	python main_celery.py worker --loglevel=info --beat

run-server:
	export FLASK_APP=manage
	flask db upgrade
	gunicorn --bind 0.0.0.0:5000 --workers 8 --threads 8 --pythonpath src 'main:create_app()'

migrate-db:
	export FLASK_APP=manage
	flask db migrate -m '$(message)'

deploy-server:
	git pull
	docker-compose down
	docker-compose up -d --build
