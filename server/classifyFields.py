import os
import shutil

from keras.models import load_model
import numpy as np

# Load the model
from keras.utils import load_img, img_to_array, plot_model


def classifyFields():
    # model = load_model("../server/checkerboard_first_model.h5")
    # model = load_model("../server/4labels.h5")
    # model = load_model("../server/4labels+aug.h5")
    model = load_model("../server/4labels+wfieldsaug.h5")
    # model = load_model("../server/4labels+BWfieldsaug.h5")

    untested_fields = os.listdir("split")

    print(len(untested_fields))
    # Generate the matrix with dots
    result_matrix = [['-' for _ in range(8)] for _ in range(8)]

    i = 0

    for elem in untested_fields:
        print("NUME", elem)
        row_field_coordinates = elem.split("-")[0]
        column_field_coordinates = elem.split("-")[1]

        print(row_field_coordinates[-1])
        print(column_field_coordinates[1])

        row = row_field_coordinates[-1]
        column = column_field_coordinates[1]

        i += 1
        actual_path = "split/" + elem

        image = load_img(actual_path, target_size=(256, 256))
        image = img_to_array(image)
        image = np.expand_dims(image, axis=0)

        # Preprocess the image
        image /= 255.0

        pieces_labels = {0: '.', 1: 'E', 2: 'W', 3: 'B'}
        # pieces_labels = {0: 'Empty white field', 1: 'Empty black field', 2: 'Black field with white piece', 3: 'Black field with black piece '}

        piece_output = model.predict(image)

        print("PIECE OUTPUT IS")

        piece_value = np.argmax(piece_output)

        piece_label = pieces_labels[piece_value]

        print("The output for: ", elem, " is: ", piece_label)

        result_matrix[int(row)][int(column)] = piece_label

    resultString = ""
    for i in range(0,8):
        for j in range(0,8):
            resultString += result_matrix[i][j]

    return resultString
    # shutil.rmtree("split//")
    # os.mkdir("split")
