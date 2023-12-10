import os
from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
from dotenv import load_dotenv, find_dotenv
import pymysql
import json
import traceback  # Import traceback module for detailed error information


load_dotenv(find_dotenv(), override=True)  # Load env before run powerpaint
app = Flask(__name__)
CORS(app, support_credentials=True)

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


@app.route("/books/", methods=["GET"])
def get_all_books():
    try:
        with create_connection() as connection, connection.cursor() as cursor:
            # Your SQL query to fetch all books goes here
            cursor.execute("SELECT * FROM BOOK")
            books_result = cursor.fetchall()
            print(books_result)
            # Convert the result to a JSON response
            response = jsonify(books_result)
            return response
    except Exception as e:
        print(f"Failed to fetch books from the database: {e}")
        return jsonify({"error": "Failed to fetch books from the database"})


@app.route("/books/", methods=["POST"])
def insert_books():
    try:
        # Get data from the request
        data = request.get_json()
        print("Received data:", data)

        # Extracting data for the stored procedure
        p_ISBN = data.get('ISBN')
        p_title = data.get('title')
        p_book_cover = data.get('book_cover')
        p_description = data.get('description')
        p_width = data.get('width')
        p_length = data.get('length')
        p_thickness = data.get('thickness')  # Fix typo: should be 'thickness'
        p_print_length = data.get('print_length')
        p_price = data.get('price')
        p_publication_date = data.get('publication_date')
        p_publisher = data.get('publisher')
        p_author_ids = json.dumps(data.get('author_ids'))
        p_category_ids = json.dumps(data.get('category_ids'))
        p_image_links = json.dumps(data.get('image_links'))

        # Call the stored procedure
        with create_connection() as connection, connection.cursor() as cursor:
            cursor.callproc('INSERT_BOOK', (
                p_ISBN, p_title, p_book_cover, p_description, p_width, p_length, p_thickness,
                p_print_length, p_price, p_publication_date, p_publisher,
                p_author_ids, p_category_ids, p_image_links
            ))

            # Commit the changes to the database
            connection.commit()

        # Respond with success message
        return jsonify({"message": "Book inserted successfully"}), 201

    except Exception as e:
        # Print detailed error information
        traceback.print_exc()

        # Respond with an error message
        return jsonify({"error": str(e)}), 500
