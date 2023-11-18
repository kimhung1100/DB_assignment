from flask import Blueprint, request, jsonify
from voluptuous import ALLOW_EXTRA, All, Any, Required, Schema, Optional

healthcheck = Blueprint('healthcheck', __name__)

@healthcheck.route('/healthcheck', methods=['GET'])
def healthcheck_api():
    return jsonify({
        'status': True
    })
