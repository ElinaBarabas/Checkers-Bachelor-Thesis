import os
import shutil

from keras.models import load_model
import numpy as np

# Load the model
from keras.utils import load_img, img_to_array, plot_model


def convert_chars(matrix):
    for i in range(0, 8):
        for j in range(0, 8):
            current_element = matrix[i][j]
            if current_element == "e":
                matrix[i][j] = "."
            elif current_element == "wh":
                matrix[i][j] = "N"
            elif current_element == "bh":
                matrix[i][j] = "n"
            elif current_element[0] == "w":
                matrix[i][j] = str(current_element[1]).upper()
            else:
                matrix[i][j] = str(current_element[1]).lower()

    for elem in matrix:
        print(elem)

    return matrix

def convert_matrix_to_fen(matrix):
    fen = ''
    empty_count = 0
    for row in matrix:
        for cell in row:
            if cell == ".":
                empty_count += 1
            else:
                if empty_count > 0:
                    fen += str(empty_count)
                    empty_count = 0
                fen += str(cell)
        if empty_count > 0:
            fen += str(empty_count)
            empty_count = 0
        fen += '/'

    fen = fen[:-1] + " w KQkq - 0 1"

    # fen = "8/8/3K4/8/8/4P3/7k/8 w KQkq - 0 1"

    print(fen)
    return fen


def classifyChessFields():
    model = load_model("chessify-2.h5")

    untested_fields = os.listdir("output-chessify")

    print(len(untested_fields))
    result_matrix = [['.' for _ in range(8)] for _ in range(8)]

    i = 0

    for elem in untested_fields:
        field_coordinates = elem.split(".")[0][-4:]
        field_coordinates = field_coordinates.split("-")
        row = field_coordinates[0]
        column = field_coordinates[1][-1]

        actual_path = "output-chessify/" + elem

        image = load_img(actual_path, target_size=(256, 256))
        image = img_to_array(image)
        image = np.expand_dims(image, axis=0)

        image /= 255.0

        pieces_labels = {0: "bb",
                         1: "bh",
                         2: "bk",
                         3: "bp",
                         4: "bq",
                         5: "br",
                         6: "e",
                         7: "wb",
                         8: "wh",
                         9: "wk",
                         10: "wp",
                         11: "wq",
                         12: "wr",
                         }

        piece_output = model.predict(image)
        piece_value = np.argmax(piece_output)
        piece_label = pieces_labels[piece_value]

        print("Output value for", elem, "is :\n", piece_label)

        result_matrix[int(row)][int(column)] = piece_label

    result_matrix = convert_chars(result_matrix)
    fen_string = convert_matrix_to_fen(result_matrix)

    return fen_string
