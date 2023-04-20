import os
import shutil

import werkzeug.utils
from PIL import Image
from flask import Flask, jsonify, request
from waitress import serve
from processImage import processImage

app = Flask(__name__)


def cleanMemory():
    images = os.listdir("./uploadedImages")
    for elem in images:
        filenameWithoutExtension = elem.split(".")[0]
        if os.path.exists(f"./{filenameWithoutExtension}"):
            print("exists")
            # shutil.rmtree(f"./{filenameWithoutExtension}")
        # os.remove(f"./uploadedImages/{elem}")


@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST":
        shutil.rmtree(f"./output")
        imageFile = request.files['image']

        print("AICI AJUNGE")
        # filename = werkzeug.utils.secure_filename(imageFile.filename)
        imageFile.save("./uploadedImages/" + "output.jpg")
        img = Image.open(imageFile.stream)
        response = processImage(img)
        print("THE RESPONSE IS: " + response)

        cleanMemory()

        return jsonify({
            "message": f"{response}"
        })


@app.route('/')
def index():
    return "Hello"


if __name__ == "__main__":
    serve(app, host="0.0.0.0", port=50100, threads=2)
