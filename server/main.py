import os
import shutil

import werkzeug.utils
from PIL import Image
from flask import Flask, jsonify, request

from processImage import processImage

app = Flask(__name__)


def cleanMemory():
    images = os.listdir("./uploadedImages")
    for elem in images:
        filenameWithoutExtension = elem.split(".")[0]
        if os.path.exists(f"./{filenameWithoutExtension}"):
            shutil.rmtree(f"./{filenameWithoutExtension}")
        os.remove(f"./uploadedImages/{elem}")


@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST":
        imageFile = request.files['image']
        filename = werkzeug.utils.secure_filename(imageFile.filename)
        imageFile.save("./uploadedImages/" + filename)

        response = processImage(imageFile)
        print("THE RESPONSE IS: " + response)

        cleanMemory()

        return jsonify({
            "message": f"{response}"
        })


if __name__ == "__main__":
    app.run(host="0.0.0.0")
