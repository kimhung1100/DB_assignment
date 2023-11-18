import os
from flask import Flask, jsonify
from flask_cors import CORS
from dotenv import load_dotenv, find_dotenv
import pymysql

load_dotenv(find_dotenv(), override=True)  # Load env before run powerpaint
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load environment variables from .env file
DB_HOST = os.getenv("DB_HOST")
DB_PORT = int(os.getenv("DB_PORT"))
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

timeout = 10
def create_connection():
    return pymysql.connect(
        charset="utf8mb4",
        connect_timeout=timeout,
        cursorclass=pymysql.cursors.DictCursor,
        db=DB_NAME,
        host=DB_HOST,
        password=DB_PASSWORD,
        read_timeout=timeout,
        port=DB_PORT,
        user=DB_USER,
        write_timeout=timeout,
    )

def test_database_connection():
    try:
        with create_connection() as connection, connection.cursor() as cursor:
            # Your test query goes here
            cursor.execute("SELECT 1")
            result = cursor.fetchone()
            print("Database connection successful! Result:", result)
    except Exception as e:
        print(f"Failed to connect to the database: {e}")

@app.route("/")
def hello_world():
    test_database_connection()
    return "<p>Hello, World!</p>"



def create_app():
    app = Flask(__name__)
    from books_routes import books as books_router

    app.register_blueprint(books_router)

    test_database_connection()
    return app

if __name__ == "__main__":
    app = create_app()
    app.run(debug=True)
