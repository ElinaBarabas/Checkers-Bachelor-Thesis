import os
import shutil

import werkzeug.utils
from PIL import Image
from flask import Flask, jsonify, request
from waitress import serve
from processImage import processImage

from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

app = Flask(__name__)

limiter = Limiter(
    app,
    default_limits=["100 per day", "50 per hour"],
)


@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST":

        imageFile = request.files['image']

        imageFile.save("./uploadedImages/" + "output.jpg")
        img = Image.open(imageFile.stream)
        response = processImage(img)
        print("THE RESPONSE IS: " + response)

        # cleanMemory()

        return jsonify({
            "message": f"{response}"
        })


@app.route('/')
def index():
    return "Hello"


if __name__ == "__main__":
    serve(app, host="0.0.0.0", port=50100, threads=1)
