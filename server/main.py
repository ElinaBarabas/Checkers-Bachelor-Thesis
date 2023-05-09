import os
import shutil

from PIL import Image
from flask import Flask, jsonify, request
from waitress import serve

# from CHESS.processChessImage import processChessImage
from processChessImage import processChessImage
from processImage import processImage

from flask_limiter import Limiter

app = Flask(__name__)

limiter = Limiter(
    app,
    default_limits=["100 per day", "50 per hour"],
)


@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST":

        shutil.rmtree("output")
        imageFile = request.files['image']

        imageFile.save("./uploadedImages/" + "output.jpg")
        img = Image.open(imageFile.stream)
        # img.show()

        response = processImage(img)
        os.remove("uploadedImages/output.jpg")
        print("THE RESPONSE IS: " + response)

        return jsonify({
            "message": f"{response}"
        })


@app.route('/chessify', methods=["POST"])
def uploadChess():
    if request.method == "POST":

        # if os.path.exists("CHESS/output-chessify"):
        #     shutil.rmtree("CHESS/output-chessify")

        imageFile = request.files['image']

        imageFile.save("./uploadedImages-chessify/" + "output-chessify.jpg")

        # img = Image.open(imageFile.stream)

        response = processChessImage()
        os.remove("uploadedImages-chessify/output-chessify.jpg")

        print("CHESSIFY RESPONSE: " + response)

        return jsonify({
            "message": f"{response}"
        })


@app.route('/')
def index():
    return "Hello"


if __name__ == "__main__":
    serve(app, host="0.0.0.0", port=50100, threads=1)
