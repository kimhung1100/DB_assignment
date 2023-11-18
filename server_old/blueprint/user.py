from flask import Blueprint, request, jsonify
from voluptuous import ALLOW_EXTRA, All, Any, Required, Schema, Optional
from model.user import User
from model.db import db


CREATE_ACCOUNT_SCHEMA = Schema({
    Required('full_name'): Any(str),
    Required('email'): Any(str),
    Required('password'): Any(str),
    Optional('phone_number'): Any(str),
}, extra=ALLOW_EXTRA)

user = Blueprint('users', __name__)

@user.route('/users', methods=['POST'])
def create_user():
    data = CREATE_ACCOUNT_SCHEMA(request.json)
    user = User(
        full_name=data['full_name'],
        email=data['email'],
        phone_number=data['phone_number'],
        password=data['password']
    )
    user.save(db.session)
    return jsonify({
        'status': True
    })

