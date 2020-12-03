from ursina import *


class Voxel(Button):
    def __init__(self):
        super().__init__(parent=scene, position=(0, 0, 0), model="cube", origin_y=0.5, texture="white_cube",
                         color=color.azure, highlight_color=color.lime)


app = Ursina()
for z in range(8):
    for x in range(8):
        voxel = Voxel()

app.run()
