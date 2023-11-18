import uuid, random, string
from datetime import datetime

from model.db import db

from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.ext.hybrid import hybrid_property

from util.hash_util import hash_password, check_password


class User(db.Model):
    __tablename__ = 'user'
    __json_hidden__ = [
        '_password',
        'password',
        'forgot_password_code'
    ]
    __update_field__ = []
    __filter_field__ = []

    # Column
    user_id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = db.Column(db.VARCHAR(255), nullable=False, unique=True)
    full_name = db.Column(db.VARCHAR(255), nullable=False)
    phone_number = db.Column(db.VARCHAR(255), nullable=True)
    _password = db.Column(db.TEXT, nullable=False)
    forgot_password_code = db.Column(db.VARCHAR(5), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


    @hybrid_property
    def password(self):
        return None

    @password.setter
    def password(self, value):
        self._password = hash_password(value)

    def check_password(self, verify_password):
        return check_password(self._password, verify_password)

    def generate_forgot_password(self):
        self.forgot_password_code = ''.join([random.choice(string.ascii_letters) for n in range(5)]).upper()
