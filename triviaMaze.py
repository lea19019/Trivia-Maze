import arcade
import connect_to_database

# Constants defined here
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
SCREEN_NAME = "Trivia Maze"

MOVEMENT_SPEED = 6


def fetchingData(topic):

    print('CS')
    # Call the database access method, for this topic
    # Store result, which has a structure of a list of lists,
    questionsDict = {}
    result = connect_to_database.connect_to_database(topic)
    for i in range(result.lenght):
        questionsDict.update(
            {result[i][(i % 4)*4]: [result[i][1], result[i][2]]})

    return questionsDict


class gameWindow(arcade.Window):
    def __init__(self):
        # Call the parent class and set up the window
        super().__init__(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_NAME)

        # Define lists for each topic and the player
        self.wall_list = None
        self.player_sprite = None
        self.quiz_list = None

        # Player sprite for direct access (movement needs)
        self.player = None

        # Movement engine
        self.physics_engine = None

        # Load the textures for use
        self.cs_textures = ['assets/collageCS1.jpg', 'assets/collageCS2.jpg']
        self.us_textures = ['assets/collageUS1.jpg', 'assets/collageUS2.jpg',
                            'assets/collageUS3.jpg', 'assets/collageUS4.jpg']
        self.chem_textures = []
        self.math_textures = []

    def setup(self):
        # Initialize sprite lists
        self.wall_list = arcade.SpriteList(use_spatial_hash=True)
        self.player_sprite = arcade.SpriteList()

        topic = "US"
        # Assign wall textures and background color by topic
        if topic == "CS":
            for texture in self.cs_textures:
                self.wall_list.append(arcade.Sprite(texture, scale=.3))
            arcade.set_background_color(arcade.color.GRAY_BLUE)
            # Set quiz_list to first primary key in CS table
        elif topic == "US":
            counter = 0
            for texture in self.us_textures:
                temp = arcade.Sprite(texture, scale=.3, )
                # Assign each a different location
                if counter <= 1:
                    temp.center_x = 100
                    if counter == 0:
                        temp.center_y = SCREEN_HEIGHT - 100
                    else:
                        temp.center_y = 100
                    counter += 1
                else:
                    temp.center_x = SCREEN_WIDTH - 100
                    if counter == 2:
                        temp.center_y = 100
                    else:
                        temp.center_y = SCREEN_HEIGHT - 100
                    counter += 1
                self.wall_list.append(temp)
            arcade.set_background_color(arcade.color.SEPIA)
            # Set quiz_list to first primary key in US table
        elif topic == "Chem":
            for texture in self.chem_textures:
                self.wall_list.append(arcade.Sprite(texture, scale=.3))
            arcade.set_background_color(arcade.color.GRAY_BLUE)
            # Set quiz_list to first primary key in Chem table
        else:
            for texture in self.math_textures:
                self.wall_list.append(arcade.Sprite(texture, scale=.3))
            arcade.set_background_color(arcade.color.GRAY_BLUE)
            # Set quiz_list to first primary key in Math table

        # Assign player sprite texture and placement
        self.player = arcade.Sprite('assets/player.png', scale=.2)
        self.player.center_y = SCREEN_HEIGHT//2
        self.player.center_x = SCREEN_WIDTH//2
        self.player_sprite.append(self.player)

        # Pick the physics engine
        self.physics_engine = arcade.PhysicsEngineSimple(
            self.player, self.wall_list)

    def on_draw(self):
        # this will be where all the drawing takes place in the game

        arcade.start_render()
        self.wall_list.draw()
        self.player_sprite.draw()
        # Draw quiz_list

    def on_key_press(self, key, modifications):
        if key == arcade.key.UP:
            #         self.up_pressed = True
            self.player.change_y = MOVEMENT_SPEED
        elif key == arcade.key.DOWN:
            #         self.down_pressed = True
            self.player.change_y = -MOVEMENT_SPEED
        elif key == arcade.key.LEFT:
            #         self.left_pressed = True
            self.player.change_x = -MOVEMENT_SPEED
        elif key == arcade.key.RIGHT:
            #         self.right_pressed = True
            self.player.change_x = MOVEMENT_SPEED

    def on_key_release(self, key, modifications):
        if key == arcade.key.UP:
            #         self.up_pressed = False
            self.player.change_y = 0
        elif key == arcade.key.DOWN:
            #         self.down_pressed = False
            self.player.change_y = 0
        elif key == arcade.key.LEFT:
            #         self.left_pressed = False
            self.player.change_x = 0
        elif key == arcade.key.RIGHT:
            #         self.right_pressed = False
            self.player.change_x = 0

    def on_update(self, delta_time):
        # This is the callback. it is set to 60fps by default
        self.physics_engine.update()

        """Check for collision with the answers"""
        # If collision is detected
        # If related bool == true
        # Draw text Success and sleep for 2 seconds?
        # Else
        # Draw text Failure and sleep 2 seconds?
        # Update question/answer list with new textures/sprites from db


# Additional methods for handling data access, title and ending screens, etc. can go here

def main():
    # Main method
    window = gameWindow()
    window.setup()
    arcade.run()


# if main file (not a module) run main
if __name__ == "__main__":
    main()
