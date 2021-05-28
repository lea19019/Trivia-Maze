import arcade


# Constants defined here


class gameWindow(arcade.Window):
    def __init__(self):
        # Call the parent class and set up the window
        super().__init__(800, 600, "Trivia Maze")

        # The background can be change
        arcade.set_background_color(arcade.color.AMBER)


    def setup(self):
        # Define this, the line below is placeholder
        x = 0


    def on_draw(self):
        # this will be where all the drawing take place in the game
        arcade.start_render()


    def on_key_press(self, key, modifications):
        # Define this, the line below is placeholder
        x = 0
        if key == arcade.key.UP:
            self.up_pressed = True
        elif key == arcade.key.DOWN:
            self.down_pressed = True
        elif key == arcade.key.LEFT:
            self.left_pressed = True
        elif key == arcade.key.RIGHT:
            self.right_pressed = True

    def on_key_release(self, key, modifications):
        # Define this, the line below is placeholder
        if key == arcade.key.UP:
            self.up_pressed = False
        elif key == arcade.key.DOWN:
            self.down_pressed = False
        elif key == arcade.key.LEFT:
            self.left_pressed = False
        elif key == arcade.key.RIGHT:
            self.right_pressed = False


    def on_update(self, delta_time):
        # This is the callback. it is set to 60fps by default
        x = 0


# Additional methods for handling data access, title and ending screens, etc. will go here

def main():
    # Main method
    window = gameWindow()
    window.setup()
    arcade.run()


# if main file (not a module) run main
if __name__ == "__main__":
    main()