from ursina import *
from ursina.prefabs.first_person_controller import FirstPersonController
import pyautogui


# Launch Ursina
app = Ursina()

window.title = 'Pycraft (Minecraft Classic in Ursina)'
window.borderless = True
window.fullscreen = True

# Textures
grass_texture = load_texture('./assets/grass_block.png')
stone_texture = load_texture('./assets/stone_block.png')
brick_texture = load_texture('./assets/brick_block.png')
dirt_texture = load_texture("./assets/dirt_block.png")
sky_texture = load_texture("./assets/skybox.png")
arm_texture = load_texture("./assets/arm_texture.png")
glass = load_texture("./assets/glass.png")
wood = load_texture("./assets/wood.png")
punch_sound = Audio('assets/punch_sound', loop=False, autoplay=False)
door = load_texture("./assets/door.png")
block_select = "Grass Block"
block_pick = 1


def update():
    global block_pick
    global block_select
    if held_keys['left mouse'] or held_keys['right mouse']:
        hand.active()
    else:
        hand.passive()
    if held_keys["1"]:
        block_pick = 1
        block_select = "Grass Block"

    if held_keys["2"]:
        block_pick = 2
        block_select = "Stone"

    if held_keys["3"]:
        block_pick = 3
        block_select = "Bricks"

    if held_keys["4"]:
        block_pick = 4
        block_select = "Dirt"

    if held_keys["5"]:
        block_pick = 5
        block_select = "Glass Block"

    if held_keys["6"]:
        block_pick = 6


class Voxel(Button):

    def __init__(self, position=(0, 0, 0), texture=grass_texture):
        super().__init__(
            parent=scene,
            position=position,
            model='assets/block',
            origin_y=0.5,
            texture=texture,
            color=color.color(0, 0, random.uniform(0.9, 1)),
            scale=0.5)

    def input(self, key):
        if self.hovered:
            if key == "right mouse down":
                punch_sound.play()
                if block_pick == 1:
                    voxel = Voxel(position=self.position + mouse.normal, texture=grass_texture)

                if block_pick == 2:
                    voxel = Voxel(position=self.position + mouse.normal, texture=stone_texture)

                if block_pick == 3:
                    voxel = Voxel(position=self.position + mouse.normal, texture=brick_texture)

                if block_pick == 4:
                    voxel = Voxel(position=self.position + mouse.normal, texture=dirt_texture)

                if block_pick == 5:
                    voxel = Voxel(position=self.position + mouse.normal, texture=glass)

                if block_pick == 6:
                    voxel = Voxel(position=self.position + mouse.normal, texture=door)

            if key == "left mouse down":
                punch_sound.play()
                destroy(self)


class Sky(Entity):
    def __init__(self):
        super().__init__(
            parent=scene,
            model="sphere",
            texture=sky_texture,
            scale=150,
            double_sided=True
        )


class Hand(Entity):
    def __init__(self):
        super().__init__(
            parent=camera.ui,
            model='assets/arm',
            texture=arm_texture,
            scale=0.2,
            rotation=Vec3(150, -10, 0),
            position=Vec2(0.4, -0.6))

    def active(self):
        self.position = Vec2(0.3, -0.5)

    def passive(self):
        self.position = Vec2(0.4, -0.6)


for z in range(20):
    for x in range(20):
        voxel = Voxel(position=(x, 0, z))

player = FirstPersonController()
sky = Sky()
hand = Hand()

app.run()
