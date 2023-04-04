import werkzeug.utils
from PIL import Image
from flask import Flask, jsonify, request

from processImage import processImage

app = Flask(__name__)


@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST":
        imageFile = request.files['image']
        filename = werkzeug.utils.secure_filename(imageFile.filename)
        imageFile.save("./uploadedImages/" + filename)

        response = processImage(imageFile)

        return jsonify({
            "message": f"{response}"
        })


if __name__ == "__main__":
    app.run(host="0.0.0.0")
