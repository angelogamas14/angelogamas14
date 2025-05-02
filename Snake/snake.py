from tkinter import *
from PIL import Image, ImageTk
import random
import pygame

WIDTH = 500
HEIGHT = 500
SPEED = 200
SPACE_SIZE = 20
BODY_SIZE = 2
SNAKE1_COLOR = "#00FF00"
SNAKE2_COLOR = "#FF0000"
FOOD_COLOR = "#FFFFFF"
BG_IMAGE_PATH = "flower.jpg"

pygame.mixer.init()
pygame.mixer.music.load("bg.mp3")
pygame.mixer.music.set_volume(0.3)
pygame.mixer.music.play(-1)
eat_sound = pygame.mixer.Sound("eat.mp3")
eat_sound.set_volume(0.5)

def set_background():
    global bg_image_id
    image = Image.open(BG_IMAGE_PATH)
    image = image.resize((WIDTH, HEIGHT))
    bg_photo = ImageTk.PhotoImage(image)
    bg_image_id = canvas.create_image(0, 0, anchor=NW, image=bg_photo)
    canvas.image = bg_photo

class Snake:
    def __init__(self, color, start_x, start_y):
        self.body_size = BODY_SIZE
        self.coordinates = [[start_x, start_y] for _ in range(BODY_SIZE)]
        self.squares = []
        self.color = color
        for x, y in self.coordinates:
            square = canvas.create_rectangle(
                x, y, x + SPACE_SIZE, y + SPACE_SIZE,
                fill=self.color, tag="snake")
            self.squares.append(square)

class Food:
    def __init__(self):
        x = random.randint(0, (WIDTH // SPACE_SIZE) - 1) * SPACE_SIZE
        y = random.randint(0, (HEIGHT // SPACE_SIZE) - 1) * SPACE_SIZE
        self.coordinates = [x, y]
        canvas.create_oval(x, y, x + SPACE_SIZE, y + SPACE_SIZE,
                           fill=FOOD_COLOR, tag="food")

def next_turn_duo():
    move_snake(snake1, direction1)
    move_snake(snake2, direction2)

    if check_collisions(snake1) or check_collisions(snake2) or check_snake_collision(snake1, snake2):
        game_over()
    else:
        window.after(SPEED, next_turn_duo)

def move_snake(snake, direction):
    global food  # Moved to the top
    x, y = snake.coordinates[0]

    if direction == "up":
        y -= SPACE_SIZE
    elif direction == "down":
        y += SPACE_SIZE
    elif direction == "left":
        x -= SPACE_SIZE
    elif direction == "right":
        x += SPACE_SIZE

    snake.coordinates.insert(0, [x, y])
    square = canvas.create_rectangle(x, y, x + SPACE_SIZE, y + SPACE_SIZE, fill=snake.color)
    snake.squares.insert(0, square)

    if x == food.coordinates[0] and y == food.coordinates[1]:
        global score1, score2
        if snake == snake1:
            score1 += 1
            label1.config(text="P1: {}".format(score1))
        else:
            score2 += 1
            label2.config(text="P2: {}".format(score2))
        canvas.delete("food")
        eat_sound.play()
        food = Food()
    else:
        del snake.coordinates[-1]
        canvas.delete(snake.squares[-1])
        del snake.squares[-1]

def check_collisions(snake):
    x, y = snake.coordinates[0]
    if x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT:
        return True
    for part in snake.coordinates[1:]:
        if part == [x, y]:
            return True
    return False

def check_snake_collision(s1, s2):
    head1 = s1.coordinates[0]
    head2 = s2.coordinates[0]
    if head1 in s2.coordinates:
        return True
    if head2 in s1.coordinates:
        return True
    return False

def game_over():
    canvas.delete(ALL)
    canvas.create_text(WIDTH / 2, HEIGHT / 2 - 40, font=('consolas', 40),
                       text="GAME OVER", fill="red", tag="gameover")
    restart_button = Button(window, text="Restart", font=('consolas', 16),
                            command=lambda: [restart_button.destroy(), show_start_menu()])
    restart_button.pack()

def change_direction_player1(new_dir):
    global direction1
    opposite = {"left": "right", "right": "left", "up": "down", "down": "up"}
    if new_dir != opposite.get(direction1):
        direction1 = new_dir

def change_direction_player2(new_dir):
    global direction2
    opposite = {"left": "right", "right": "left", "up": "down", "down": "up"}
    if new_dir != opposite.get(direction2):
        direction2 = new_dir

def show_start_menu():
    canvas.delete("all")
    set_background()
    canvas.create_text(WIDTH // 2, HEIGHT // 2 - 100,
                       text="Select Game Mode", font=("consolas", 24), fill="white")

    solo_btn = Button(window, text="Solo Game", font=('consolas', 16),
                      command=lambda: [solo_btn.destroy(), duo_btn.destroy(), start_solo_game()])
    solo_btn.pack()

    duo_btn = Button(window, text="Duo Game", font=('consolas', 16),
                     command=lambda: [solo_btn.destroy(), duo_btn.destroy(), start_duo_game()])
    duo_btn.pack()

def start_solo_game():
    global snake1, food, direction1, score1
    canvas.delete("all")
    set_background()
    direction1 = 'down'
    score1 = 0
    label1.config(text="Points: 0")
    label2.config(text="")  # Clear P2 label
    snake1 = Snake(SNAKE1_COLOR, 100, 100)
    food = Food()
    next_turn_solo()

def next_turn_solo():
    move_snake(snake1, direction1)
    if check_collisions(snake1):
        game_over()
    else:
        window.after(SPEED, next_turn_solo)

def start_duo_game():
    global snake1, snake2, food, direction1, direction2, score1, score2
    canvas.delete("all")
    set_background()
    direction1 = 'down'
    direction2 = 'down'
    score1 = 0
    score2 = 0
    label1.config(text="P1: 0")
    label2.config(text="P2: 0")
    snake1 = Snake(SNAKE1_COLOR, 100, 100)
    snake2 = Snake(SNAKE2_COLOR, 300, 300)
    food = Food()
    next_turn_duo()

# -----------------------
# 🖼️ GUI INITIALIZATION
# -----------------------

window = Tk()
window.title("Snake Game with Game Modes")

score1 = 0
score2 = 0
direction1 = 'down'
direction2 = 'down'

label_frame = Frame(window)
label_frame.pack()
label1 = Label(label_frame, text="P1: 0", font=('consolas', 16), fg=SNAKE1_COLOR)
label1.pack(side=LEFT, padx=20)
label2 = Label(label_frame, text="", font=('consolas', 16), fg=SNAKE2_COLOR)
label2.pack(side=LEFT, padx=20)

canvas = Canvas(window, width=WIDTH, height=HEIGHT)
canvas.pack()

window.update()
w, h = window.winfo_width(), window.winfo_height()
screen_w, screen_h = window.winfo_screenwidth(), window.winfo_screenheight()
x = int((screen_w / 2) - (w / 2))
y = int((screen_h / 2) - (h / 2))
window.geometry(f"{w}x{h}+{x}+{y}")

# Controls
window.bind('<Left>', lambda e: change_direction_player1('left'))
window.bind('<Right>', lambda e: change_direction_player1('right'))
window.bind('<Up>', lambda e: change_direction_player1('up'))
window.bind('<Down>', lambda e: change_direction_player1('down'))

window.bind('a', lambda e: change_direction_player2('left'))
window.bind('d', lambda e: change_direction_player2('right'))
window.bind('w', lambda e: change_direction_player2('up'))
window.bind('s', lambda e: change_direction_player2('down'))

show_start_menu()
window.mainloop()
