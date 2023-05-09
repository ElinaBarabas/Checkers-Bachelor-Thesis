import os

import cv2
from PIL import Image

# from classifyChessFields import classifyChessFields
from classifyChessFields import classifyChessFields


def processChessImage():
    image = Image.open("./uploadedImages-chessify/" + "output-chessify.jpg")

    image.show()

    filename = "output-chessify.jpg"
    filename = filename.split(".")[0]

    newPath = "./" + filename
    if not os.path.exists(newPath):
        os.makedirs(newPath)

    isDetected = split_into_checkerboard_fields("./uploadedImages-chessify/" + "output-chessify.jpg", newPath)
    if isDetected == "FOUND":

        response = classifyChessFields()
    else:
        response = "NOT FOUND"

    return response


def split_into_checkerboard_fields(filename, newPath):
    print(newPath + "IS HERE")
    checkerboard_image = cv2.imread(filename)

    filename = filename.split("//")[-1]

    filename_without_extension = filename.split(".")[0]

    pattern_size = (7, 7)  # the number of INNER corners of the initial checkerboard (49)

    found, corners = cv2.findChessboardCorners(checkerboard_image, pattern_size)

    if found:
        print("HERE IS FOUND")

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


        for i, f in enumerate(first_row_fields):
            shape = f.shape
            if shape[0] > 0 and shape[1] > 0:

                print(1)

                cv2.imwrite(
                    os.path.join(f"../server/{newPath}/",
                                 f"chess{filename_without_extension}___r{0}-c{i}.jpg"),
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

        print(os.getcwd())

        for i, f in enumerate(first_column_fields):
            shape = f.shape
            if shape[0] > 0 and shape[1] > 0:

                print(2)

                cv2.imwrite(
                    os.path.join(f"../server/{newPath}/",
                                 f"chess{filename_without_extension}___r{i + 1}-c{0}.jpg"),
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

                print(3)
                # Generate the filename using the current row and column numbers
                filename = f"chess{filename_without_extension}___r{row}-c{column}.jpg"
                cv2.imwrite(os.path.join(f"../server/{newPath}/", filename), f)


            # Increment the column number and wrap around at column 7
            row += 1
            if row > 7:
                row = 1
                column += 1  # Move to the next row

            # Stop iterating if we reach row 8
            if column > 7:
                break


    else:
        print("HERE IS NOT FOUND")

        response = "NOT found"

    return response


# processChessImage()
