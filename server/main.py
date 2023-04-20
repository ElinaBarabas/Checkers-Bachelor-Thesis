import os
import shutil

import werkzeug.utils
from PIL import Image
from flask import Flask, jsonify, request
from waitress import serve
from processImage import processImage

app = Flask(__name__)


@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST":

        imageFile = request.files['image']

        print("AICI AJUNGE")

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
    serve(app, host="0.0.0.0", port=50100, threads=2)
