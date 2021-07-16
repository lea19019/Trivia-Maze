import arcade
from arcade.color import NAVY_BLUE, WHITE
from arcade.sprite_list import check_for_collision_with_list
import connect_to_database as cdb


# Constants defined here
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
SCREEN_NAME = "Trivia Maze"

MOVEMENT_SPEED = 6

LEFT_X = 50
LEFT_Y = 300
TOP_X = 320
TOP_Y = 520
RIGHT_X = 620
RIGHT_Y = 300
BOTTOM_X = 320
BOTTOM_Y = 100

BUTTON_SIZE = 75

# Button sprite class for topic selection
class TopicButton(arcade.Sprite):
    def __init__(self, topic):
        super().__init__(image_width=BUTTON_SIZE, image_height=BUTTON_SIZE//2)
        self.topic = topic

# Question sprite class for collision
class qSprite(arcade.Sprite):
    def __init__(self, bool):
        super().__init__()
        # Store answer truth value
        if bool == 0:
            self.correct = True
        else:
            self.correct = False
        # underlying hit box for the answers
        self.set_hit_box([(-25,25), (25,25), (25,-25), (-25,-25)])

# Shuffle a passed array's first 4 indicies
def shuffle(array):
    temp = array[0]
    array[0] = array[1]
    array[1] = array[3]
    array[3] = array[2]
    array[2] = temp

# Insert a newline every 25 characters and return the string
def encode(str):
    count = 25
    final = ""
    # slice string, concantenate with \n inserted, reset count
    if count < len(str):
        while count < len(str):
            arr = []
            arr.append(str[:count])
            arr.append("\n")
            arr.append(str[count:])
            final = ''.join(arr)
            count += 25
    else:
        final = str
    
    return final

# Draw the answers on screen based on an array
def draw_answers(array, a, b, c, d, sprite_list):
    count = 0
    while count < len(array):
        # Place answer 1 based on array and count
        if array[count] == 0:
            if count == 0:
                arcade.draw_text(a, LEFT_X, LEFT_Y, color=WHITE)
                sprite_list[array[count]].position = (LEFT_X, LEFT_Y)
            elif count == 1:
                arcade.draw_text(a, TOP_X, TOP_Y, color=WHITE)
                sprite_list[array[count]].position = (TOP_X, TOP_Y)
            elif count == 2:
                arcade.draw_text(a, RIGHT_X, RIGHT_Y, color=WHITE)
                sprite_list[array[count]].position = (RIGHT_X, RIGHT_Y)
            else:
                arcade.draw_text(a, BOTTOM_X, BOTTOM_Y, color=WHITE)
                sprite_list[array[count]].position = (BOTTOM_X, BOTTOM_Y)
        # Place answer 2 based on array and count        
        elif array[count] == 1:
            if count == 0:
                arcade.draw_text(b, LEFT_X, LEFT_Y, color=WHITE)
                sprite_list[array[count]].position = (LEFT_X, LEFT_Y)
            elif count == 1:
                arcade.draw_text(b, TOP_X, TOP_Y, color=WHITE)
                sprite_list[array[count]].position = (TOP_X, TOP_Y)
            elif count == 2:
                arcade.draw_text(b, RIGHT_X, RIGHT_Y, color=WHITE)
                sprite_list[array[count]].position = (RIGHT_X, RIGHT_Y)
            else:
                arcade.draw_text(b, BOTTOM_X, BOTTOM_Y, color=WHITE)
                sprite_list[array[count]].position = (BOTTOM_X, BOTTOM_Y)
        # Place answer 3 based on array and count       
        elif array[count] == 2:
            if count == 0:
                arcade.draw_text(c, LEFT_X, LEFT_Y, color=WHITE)
                sprite_list[array[count]].position = (LEFT_X, LEFT_Y)
            elif count == 1:
                arcade.draw_text(c, TOP_X, TOP_Y, color=WHITE)
                sprite_list[array[count]].position = (TOP_X, TOP_Y)
            elif count == 2:
                arcade.draw_text(c, RIGHT_X, RIGHT_Y, color=WHITE)
                sprite_list[array[count]].position = (RIGHT_X, RIGHT_Y)
            else:
                arcade.draw_text(c, BOTTOM_X, BOTTOM_Y, color=WHITE)
                sprite_list[array[count]].position = (BOTTOM_X, BOTTOM_Y)
        # Place answer 4 based on array and count
        else:
            if count == 0:
                arcade.draw_text(d, LEFT_X, LEFT_Y, color=WHITE)
                sprite_list[array[count]].position = (LEFT_X, LEFT_Y)
            elif count == 1:
                arcade.draw_text(d, TOP_X, TOP_Y, color=WHITE)
                sprite_list[array[count]].position = (TOP_X, TOP_Y)
            elif count == 2:
                arcade.draw_text(d, RIGHT_X, RIGHT_Y, color=WHITE)
                sprite_list[array[count]].position = (RIGHT_X, RIGHT_Y)
            else:
                arcade.draw_text(d, BOTTOM_X, BOTTOM_Y, color=WHITE)
                sprite_list[array[count]].position = (BOTTOM_X, BOTTOM_Y)
        count += 1

def fetchingData(topic):
    # Call the database access method, for this topic
    # Store result, which has a structure of a list of tuples,
    # as a dictionary of lists of tuples (no duplicate questions, 
    # every key has the list of answers, and every answer is a tuple pair of text
    # and boolean)
    questionsDict = {}
    result = cdb.connect_to_database(topic)
    for i in range(len(result)):     
        # If the question is not present
        if result[i][0] not in questionsDict:
            # Add it and the first attached answer
            questionsDict[result[i][0]]= [(result[i][1], result[i][2])]
        # If the question already has been added
        else:
            # Append the next answer pair
            questionsDict[result[i][0]].append((result[i][1], result[i][2]))
    return questionsDict

class GameView(arcade.View):
    def __init__(self):
        # Call the parent class and set up the view
        super().__init__()

        # Define lists for each topic and the player
        self.wall_list = None
        self.player_sprite = None
        self.quiz_list = None

        # Player sprite for direct access (movement needs)
        self.player = None

        # Movement engine
        self.physics_engine = None

        # Load the textures for use
        self.cs_textures = ['assets/collageCS1.jpg', 'assets/collageCS2.jpg',
                            'assets/C++.jpg', 'assets/html.jpg']
        self.us_textures = ['assets/collageUS1.jpg', 'assets/collageUS2.jpg',
                            'assets/collageUS3.jpg', 'assets/collageUS4.jpg']
        self.chem_textures = ['assets/C.jpg', 'assets/Fe.jpg', 
                              'assets/gold.jpg', 'assets/H.jpg']
        self.math_textures = ['assets/plus.jpg', 'assets/minus.jpg',
                              'assets/multiply.jpg', 'assets/division.jpg']

        self.a1 = ''
        self.a2 = ''
        self.a3 = ''
        self.a4 = ''
        self.array = [0,1,2,3]
        self.previous = -1
        self.question_number = 0
        self.questions = []
        self.current_question = []
        
    def setup(self, selection):
        # Initialize sprite lists
        self.wall_list = arcade.SpriteList(use_spatial_hash=True)
        self.player_sprite = arcade.SpriteList()
        self.quiz_list = arcade.SpriteList(use_spatial_hash=True)

        topic = selection
        self.questions = fetchingData(topic)
        self.current_question = list(self.questions.keys())
        
        # Assign wall textures and background color by topic
        # Populate the corners with walls that have a fitting visual element
        if topic == "COMPSCI":
            counter = 0
            for texture in self.cs_textures:
                temp = arcade.Sprite(texture, scale=1)
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
            arcade.set_background_color(arcade.color.BLACK)
        # Populate the corners with walls that have a fitting visual element
        elif topic == "HISTORY":
            counter = 0
            for texture in self.us_textures:
                temp = arcade.Sprite(texture, scale=.75)
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
        # Populate the corners with walls that have a fitting visual element
        elif topic == "CHEMISTRY":
            counter = 0
            for texture in self.chem_textures:
                temp = arcade.Sprite(texture, scale=1)
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
            arcade.set_background_color(arcade.color.GO_GREEN)
        # Populate the corners with walls that have a fitting visual element
        else:
            counter = 0
            for texture in self.math_textures:
                temp = arcade.Sprite(texture, scale=.75)
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
            arcade.set_background_color(arcade.color.GRAY_BLUE)

        # Assign player sprite texture and placement
        self.player = arcade.Sprite('assets/player.png', scale=.5)
        self.player.center_y = SCREEN_HEIGHT//2
        self.player.center_x = SCREEN_WIDTH//2
        self.player_sprite.append(self.player)

        # Pick the physics engine
        self.physics_engine = arcade.PhysicsEngineSimple(
            self.player, self.wall_list)

    def on_draw(self):
        # This will be where all the drawing takes place in the game
        arcade.start_render()
        self.wall_list.draw()
        self.player_sprite.draw()
        arcade.draw_text(encode(self.current_question[self.question_number]), SCREEN_WIDTH//2 - 100,
                         SCREEN_HEIGHT//2 + 50, color=WHITE, width=250)
        draw_answers(self.array, self.a1, self.a2, self.a3, self.a4, self.quiz_list)

    def on_key_press(self, key, modifications):
        """Handle key presses from the keyboard"""
        if key == arcade.key.UP:
            self.player.change_y = MOVEMENT_SPEED
        elif key == arcade.key.DOWN:
            self.player.change_y = -MOVEMENT_SPEED
        elif key == arcade.key.LEFT:
            self.player.change_x = -MOVEMENT_SPEED
        elif key == arcade.key.RIGHT:
            self.player.change_x = MOVEMENT_SPEED

    def on_key_release(self, key, modifications):
        """Handle key releases from the keyboard"""
        if key == arcade.key.UP:
            self.player.change_y = 0
        elif key == arcade.key.DOWN:
            self.player.change_y = 0
        elif key == arcade.key.LEFT:
            self.player.change_x = 0
        elif key == arcade.key.RIGHT:
            self.player.change_x = 0

    def on_update(self, delta_time):
        # This is the callback. It is set to 60fps by default
        self.physics_engine.update()

        # Updates the answers based on the question and saves sprites for each
        if self.previous != self.question_number:
            if self.quiz_list:
                count = 0
                while count < 4:
                    # Clear the answer sprite list before refilling
                    self.quiz_list.pop()
                    count += 1
            # Save new answers and associated sprites
            qlist = self.questions[self.current_question[self.question_number]]
            self.a1 = encode(qlist[0][0])
            self.quiz_list.append(qSprite(qlist[0][1])) 
            self.a2 = encode(qlist[1][0]) 
            self.quiz_list.append(qSprite(qlist[1][1]))
            self.a3 = encode(qlist[2][0]) 
            self.quiz_list.append(qSprite(qlist[2][1]))
            self.a4 = encode(qlist[3][0])
            self.quiz_list.append(qSprite(qlist[3][1]))
            # If the question number has moved on, update the selector
            self.previous = self.question_number

        """Check for collision with the answers"""
        collide = check_for_collision_with_list(self.player, self.quiz_list)
        if collide:
            # Update question/answer list with new textures/sprites from db
            self.question_number += 1
            shuffle(self.array)    
            self.player.center_y = SCREEN_HEIGHT//2
            self.player.center_x = SCREEN_WIDTH//2

        # Figure out how to catch the fail condition to reset nicely
        # instead of crashing

# Additional methods for title and ending screens go here
class SelectionView(arcade.View):
    def __init__(self):
        super().__init__()
        self.button_sprites = None

    def setup(self):
        self.button_sprites = arcade.SpriteList()
        button = TopicButton("COMPSCI")
        button.center_x = 200
        button.center_y = 150
        button.texture = arcade.load_texture("assets/CompSciButton.png")
        button.scale = .5
        self.button_sprites.append(button)
        button = TopicButton("HISTORY")
        button.center_x = 200
        button.center_y = 50
        button.texture = arcade.load_texture('assets/USButton.png')
        button.scale = .5
        self.button_sprites.append(button)
        button = TopicButton("CHEMISTRY")
        button.center_x = 500
        button.center_y = 150
        button.texture = arcade.load_texture('assets/ChemButton.png')
        button.scale = .5
        self.button_sprites.append(button)
        button = TopicButton("MATH")
        button.center_x = 500
        button.center_y = 50
        button.texture = arcade.load_texture('assets/MathButton.png')
        button.scale = .5
        self.button_sprites.append(button)

    """ Class for a title screen and controls to start game """
    def on_show(self):
        arcade.set_background_color(NAVY_BLUE)
        arcade.set_viewport(0,SCREEN_WIDTH-1,0,SCREEN_HEIGHT-1)

    def on_draw(self):
        """ Draw title screen """
        arcade.start_render()
        arcade.draw_text("Trivia Maze", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2,
                         arcade.color.WHITE, font_size=50, anchor_x="center")
        arcade.draw_text("Select topic to begin", SCREEN_WIDTH / 2, 
                         SCREEN_HEIGHT / 2-75, arcade.color.WHITE, font_size=20, 
                         anchor_x="center")
        self.button_sprites.draw()

    def on_mouse_press(self, x, y, button, key_modifiers):
        # Detect click
        hit_sprites = arcade.get_sprites_at_point((x,y), self.button_sprites)
        for sprite in hit_sprites:
            # Start game with selected topic
            if button == arcade.MOUSE_BUTTON_LEFT:
                game_view = GameView()
                game_view.setup(sprite.topic)
                self.window.show_view(game_view)

class ResetView(arcade.View):
    """ Class for ending screen """
    def __init__(self, end):
        super().__init__()
        self.close = end
        arcade.set_background_color(NAVY_BLUE)
        arcade.set_viewport(0,SCREEN_WIDTH-1,0,SCREEN_HEIGHT-1)

    def on_draw(self):
        """ Draw reset directions """
        arcade.start_render()
        arcade.set_viewport(0,SCREEN_WIDTH-1,0,SCREEN_HEIGHT-1)
        arcade.draw_text("Thank you for playing!", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2,
                         arcade.color.WHITE, font_size=50, anchor_x="center")
        arcade.draw_text("Press Enter to choose a new topic", SCREEN_WIDTH / 2, 
                         SCREEN_HEIGHT / 2-75, arcade.color.WHITE, font_size=20, 
                         anchor_x="center")

    # Reset to the select screen
    def on_key_press(self, key, modifiers):
        if key == arcade.key.ENTER:
            game_view = SelectionView()
            self.window.show_view(game_view)

def main():
    # Main method
    window = arcade.Window(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_NAME)
    start_view = SelectionView()
    window.show_view(start_view)
    start_view.setup()
    arcade.run()

# if main file (not a module) run main
if __name__ == "__main__":
    main()