import os
import shutil

import cv2
from PIL import Image

from classifyFields import classifyFields


def processImage(imageFile: Image):

    print(imageFile.filename)
    image = Image.open("./uploadedImages/" + imageFile.filename)
    image.show()
    isDetected = split_into_checkerboard_fields("./uploadedImages/" + imageFile.filename)
    print(isDetected)
    if isDetected == "FOUND":
        response = classifyFields()
    else:
        response = "NOT FOUND"

    return response

def split_into_checkerboard_fields(filename):
    checkerboard_image = cv2.imread(filename)

    filename = filename.split("//")[-1]

    filename_without_extension = filename.split(".")[0]

    # gray_checkerboard_image = cv2.cvtColor(checkerboard_image, cv2.COLOR_BGR2GRAY)

    pattern_size = (7, 7)  # the number of INNER corners of the initial checkerboard (49)

    found, corners = cv2.findChessboardCorners(checkerboard_image, pattern_size)

    if found:
        response = "FOUND"

        rows, cols = pattern_size

        field_width = int(corners[1][0][0] - corners[0][0][0])
        field_height = int(corners[cols][0][1] - corners[0][0][1])

        x, y = int(corners[0][0][0]), \
               int(corners[0][0][1])  # we start from the FIRST inner corner and try to reconstruct the
        # first line and first column, based on the property of the checkerboard - equal alternating squares

        x -= field_width  # move one square to the left
        y -= field_height  # move one square up

        first_row_fields = []

        field = checkerboard_image[y:y + field_height, x:x + field_width]
        first_row_fields.append(field)

        for i in range(0, cols):  # the loop increases the value of x, in order to append the squares from the first row
            x += field_width  # move one square to the right
            field = checkerboard_image[y:y + field_height, x:x + field_width]
            first_row_fields.append(field)

        print(len(first_row_fields))

        for i, f in enumerate(first_row_fields):
            shape = f.shape
            if shape[0] > 0 and shape[1] > 0:
                cv2.imwrite(
                    os.path.join("../server/split/",
                                 f"{filename_without_extension}___r{0}-c{i}.jpg"),
                    f)
        # --------------------------------------------------------------------------------------------------------------
        first_column_fields = []
        x, y = int(corners[0][0][0]), int(
            corners[0][0][1])
        x -= field_width
        # y += field_height

        field = checkerboard_image[y:y + field_height, x:x + field_width]
        first_column_fields.append(field)

        for i in range(1,
                       rows):  # the loop increases the value of x, in order to append the squares from the first column
            y += field_height  # move one square down
            field = checkerboard_image[y:y + field_height, x:x + field_width]
            first_column_fields.append(field)

        for i, f in enumerate(first_column_fields):
            shape = f.shape
            if shape[0] > 0 and shape[1] > 0:

                cv2.imwrite(
                    os.path.join("../server/split/",
                                 f"{filename_without_extension}___r{i + 1}-c{0}.jpg"),
                    f)
        # --------------------------------------------------------------------------------------------------------------

        fields = []

        for c in range(cols):
            for r in range(rows):
                x, y = int(corners[r * cols + c][0][0]), int(corners[r * cols + c][0][1])
                field = checkerboard_image[y:y + field_height, x:x + field_width]
                fields.append(field)

        column = 1  # Start from row 1 instead of 0
        row = 1
        for i, f in enumerate(fields):
            shape = f.shape
            if shape[0] > 0 and shape[1] > 0:
                # Generate the filename using the current row and column numbers
                filename = f"{filename_without_extension}___r{row}-c{column}.jpg"
                cv2.imwrite(os.path.join("../server/split/", filename), f)

            # Increment the column number and wrap around at column 7
            row += 1
            if row > 7:
                row = 1
                column += 1  # Move to the next row

            # Stop iterating if we reach row 8
            if column > 7:
                break

    else:
        response = "NOT found"

    return response


