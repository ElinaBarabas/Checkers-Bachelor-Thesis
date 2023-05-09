import os

piece_fields =  os.listdir("chess_dataset/Empty/fields/")

dark =  os.listdir("output/")

for piece in piece_fields:

    piece_without_extension = piece.split(".")[0]
    indices = piece_without_extension.split("-")
    column_index = int(indices[1][-1])
    row_index = int(indices[0][-1])
    sum = row_index + column_index

    if sum % 2 == 0:
        #white field
        label_value = "wf"
    else:
        #black field
        label_value = "bf"

    label_name = piece_without_extension + ".txt"

    with open(f"chess_dataset/Empty/labels/{label_name}", "w") as f:
        print(label_name + " " + label_value)
        f.write(f"{label_value}")

# for piece in dark:
#
#     name = piece.split("f")[1]
#     new = "bf" + name
#
#     print(new)
#     os.rename(f"output/{piece}", f"output/{new}")
#     # os.remove()