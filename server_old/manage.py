import click

from dotenv import load_dotenv
load_dotenv()

from flask import url_for
from flask.cli import FlaskGroup
from flask_migrate import Migrate

from model import *
from main import create_app

app = create_app()
manager = FlaskGroup(app)
migrate = Migrate(app, db)
migrate.init_app(app, db)

@manager.command
def list_routes():
    import urllib.parse
    output = []
    for rule in app.url_map.iter_rules():

        options = {}
        for arg in rule.arguments:
            options[arg] = "[{0}]".format(arg)

        methods = ','.join(rule.methods)
        url = url_for(rule.endpoint, **options)
        line = urllib.parse.unquote("{:50s} {:20s} {}".format(rule.endpoint, methods, url))
        output.append(line)

    for line in sorted(output):
        print(line)


if __name__ == '__main__': 
    manager()

