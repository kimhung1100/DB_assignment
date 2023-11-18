import os
import sys
from dotenv import load_dotenv, find_dotenv
load_dotenv(find_dotenv(), override=True)
from flask import Flask, jsonify
from flask_cors import CORS
from importlib import reload

from system.model_encoder import AlchemyEncoder
from services.celery_app import make_celery

reload(sys)


def create_app():
    app_init = Flask(__name__)
    CORS(app_init)
    app_init.secret_key = os.environ.get('SECRET_KEY')
    app_init.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('SQLALCHEMY_DATABASE_URI')
    app_init.json_encoder = AlchemyEncoder
    celery_instance = make_celery(app_init)

    from system.model_base import Session
    app_init.sess = Session()

    return app_init, celery_instance


app, celery = create_app()


@app.errorhandler(404)
def not_found(_e):
    rv = dict()
    rv['code'] = 404
    rv['msg'] = 'Please try another endpoint'
    return jsonify(rv), 404


if __name__ == '__main__':
    with app.app_context():
        celery.start()
