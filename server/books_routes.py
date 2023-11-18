from flask import Blueprint, jsonify
from connectDB import *
books = Blueprint("books", __name__, url_prefix="/books")

from app import *

@app.route("/books/", method=["GET"])
def get_all_books():
    print("zxcxzc")
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