import arcade
from arcade.color import WHITE
from arcade.sprite_list import check_for_collision_with_list
import connect_to_database as cdb


# Constants defined here
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
SCREEN_NAME = "Trivia Maze"

MOVEMENT_SPEED = 6

LEFT_X = 0
LEFT_Y = 0
TOP_X = 0
TOP_Y = 0
RIGHT_X = 0
RIGHT_Y = 0
BOTTOM_X = 0
BOTTOM_Y = 0

class qSprite(arcade.Sprite):
    def __init__(self, bool):
        super().__init__()
        if bool == 0:
            self.correct = True
        else:
            self.correct = False
        self.set_hit_box([(-50,50), (50,50), (50,-50), (-50,50)])

def shuffle(array):
    temp = array[0]
    array[0] = array[1]
    array[1] = array[3]
    array[3] = array[2]
    array[2] = temp

def draw_answers(array, a, b, c, d, sprite_list):
    count = 0
    while count < len(array):
        if array[count] == 0:
            if count == 0:
                arcade.draw_text(a, LEFT_X, LEFT_Y, color=WHITE)
            elif count == 1:
                arcade.draw_text(a, TOP_X, TOP_Y, color=WHITE)
            elif count == 2:
                arcade.draw_text(a, RIGHT_X, RIGHT_Y, color=WHITE)
            else:
                arcade.draw_text(a, BOTTOM_X, BOTTOM_Y, color=WHITE)
        elif array[count] == 1:
            if count == 0:
                arcade.draw_text(b, LEFT_X, LEFT_Y, color=WHITE)
            elif count == 1:
                arcade.draw_text(b, TOP_X, TOP_Y, color=WHITE)
            elif count == 2:
                arcade.draw_text(b, RIGHT_X, RIGHT_Y, color=WHITE)
            else:
                arcade.draw_text(b, BOTTOM_X, BOTTOM_Y, color=WHITE)
        elif array[count] == 2:
            if count == 0:
                arcade.draw_text(c, LEFT_X, LEFT_Y, color=WHITE)
            elif count == 1:
                arcade.draw_text(c, TOP_X, TOP_Y, color=WHITE)
            elif count == 2:
                arcade.draw_text(c, RIGHT_X, RIGHT_Y, color=WHITE)
            else:
                arcade.draw_text(c, BOTTOM_X, BOTTOM_Y, color=WHITE)
        else:
            if count == 0:
                arcade.draw_text(d, LEFT_X, LEFT_Y, color=WHITE)
            elif count == 1:
                arcade.draw_text(d, TOP_X, TOP_Y, color=WHITE)
            elif count == 2:
                arcade.draw_text(d, RIGHT_X, RIGHT_Y, color=WHITE)
            else:
                arcade.draw_text(d, BOTTOM_X, BOTTOM_Y, color=WHITE)
        count += 1

def fetchingData(topic):
    print('CS')
    # Call the database access method, for this topic
    # Store result, which has a structure of a list of tuples,
    questionsDict = {}
    result = cdb.connect_to_database(topic)
    for i in range(len(result)):     
        if result[i][0] not in questionsDict:
            questionsDict[result[i][0]]= [(result[i][1], result[i][2])]
        else:
            questionsDict[result[i][0]].append((result[i][1], result[i][2]))
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

        self.a1 = ''
        self.a2 = ''
        self.a3 = ''
        self.a4 = ''
        self.array = [0,1,2,3]
        self.previous = -1
        self.question_number = 0
        self.questions = []
        self.current_question = []

    def setup(self):
        # Initialize sprite lists
        self.wall_list = arcade.SpriteList(use_spatial_hash=True)
        self.player_sprite = arcade.SpriteList()
        self.quiz_list = arcade.SpriteList(use_spatial_hash=True)

        topic = "HISTORY"
        self.questions = fetchingData(topic)
        self.current_question = list(self.questions.keys())
        
        # Assign wall textures and background color by topic
        if topic == "COMPSCI":
            for texture in self.cs_textures:
                self.wall_list.append(arcade.Sprite(texture, scale=.3))
            arcade.set_background_color(arcade.color.GRAY_BLUE)
            # Set quiz_list to first primary key in CS table
        elif topic == "HISTORY":
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
        elif topic == "CHEMISTRY":
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
        arcade.draw_text(self.current_question[self.question_number], SCREEN_WIDTH//2 - 100,SCREEN_HEIGHT//2 + 50, color=WHITE)
        draw_answers(self.array, self.a1, self.a2, self.a3, self.a4, self.quiz_list)

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

        # Updates the answers based on the question and saves sprites for each
        if self.previous != self.question_number:
            if self.quiz_list:
                count = 0
                while count < 4:
                    self.quiz_list.pop()
                    count += 1
            qlist = self.questions[self.current_question[self.question_number]]
            self.a1 = qlist[0][0]
            self.quiz_list.append(qSprite(qlist[0][1])) 
            self.a2 = qlist[1][0] 
            self.quiz_list.append(qSprite(qlist[1][1]))
            self.a3 = qlist[2][0] 
            self.quiz_list.append(qSprite(qlist[2][1]))
            self.a4 = qlist[3][0] 
            self.quiz_list.append(qSprite(qlist[3][1]))
            self.previous = self.question_number

        """Check for collision with the answers"""
        collide = check_for_collision_with_list(self.player, self.quiz_list)
        if collide:
            if collide[1].correct == True:
                # Victory
                # Draw text Success and sleep for 2 seconds?
                x = 0
            else:
                x = 0
                # Failure
                # Draw text Failure and sleep 2 seconds?
            # Update question/answer list with new textures/sprites from db
            self.question_number += 1
            shuffle(self.array)    
            self.player.center_y = SCREEN_HEIGHT//2
            self.player.center_x = SCREEN_WIDTH//2

# Additional methods for handling data access, title and ending screens, etc. can go here

def main():
    # Main method
    window = gameWindow()
    window.setup()
    arcade.run()


# if main file (not a module) run main
if __name__ == "__main__":
    main()
