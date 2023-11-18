 # Backend API Web Service

## Documentation
Swagger collection:

## Prerequisites

* Python 3.10
* Postgres

Development Tool:

* `mypy`: Type hinting support
* `black`: Python formatter
* `pylint`: Linter

## Development Setup

1. Install dependencies:
```
pip install requirements.txt
```

2. Setup `.env` file
```
virtualenv -p `which python3` .venv # for python 2
python3 -m venv .venv # For python3.8 and higher

source .venv/bin/activate
pip install -r requirements.txt
```

3. Setup database
```
docker run --name db -p 127.0.0.1:5432:5432 -e POSTGRES_USER=rockship -e POSTGRES_PASSWORD=rockship -e POSTGRES_DB=<db_name> -d postgres:11
```

:q
4. (Optional) access Postgres database
```
psql "postgresql://:@localhost:5432/<db_name>"
```

5. Set up redis
```
docker run --name redis -p 127.0.0.1:6379:6379 -d redis:4.0.9
```

6. (Optional) access Redis database
```
redis-cli -h 127.0.0.1 -p 6379 -n 0
```

7. Start Celery worker:
```
python main_celery.py worker --loglevel=info -Ofair --beat
```

8. Start project
```
python main.py
```
