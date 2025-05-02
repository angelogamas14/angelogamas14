import tkinter as tk
from PIL import Image, ImageTk

root = tk.Tk()
root.title("Image-Based Paddle Ball Game")

width = 900
height = 500

canvas = tk.Canvas(root, width=width, height=height)
canvas.pack()

# Load and display background image
bg_image = Image.open("background.jpg").resize((width, height))
bg_photo = ImageTk.PhotoImage(bg_image)
canvas.create_image(0, 0, image=bg_photo, anchor=tk.NW)

# Load ball image
ball_img = Image.open("ball.png").resize((40, 40))
ball_photo = ImageTk.PhotoImage(ball_img)
ball = canvas.create_image(450, 30, image=ball_photo)

# Create platform
platform_y = height - 20
platform = canvas.create_rectangle(width//2-50, platform_y, width//2+50, platform_y+10, fill='black')

# Ball speed
xspeed = yspeed = 2

def move_ball():
    global xspeed, yspeed
    x1, y1 = canvas.coords(ball)
    x2 = x1 + 40
    y2 = y1 + 40

    # Bounce from left or right wall
    if x1 <= 0 or x2 >= width:
        xspeed = -xspeed
    # Bounce from top
    if y1 <= 0:
        yspeed = 2
    elif y2 >= platform_y:
        # Ball center
        cx = (x1 + x2) // 2
        px1, _, px2, _ = canvas.coords(platform)
        if px1 <= cx <= px2:
            yspeed = -2
        else:
            canvas.create_text(width//2, height//2, text='Game Over', font=('Arial Bold', 32), fill='red')
            return

    canvas.move(ball, xspeed, yspeed)
    canvas.after(20, move_ball)

def board_right(event):
    x1, y1, x2, y2 = canvas.coords(platform)
    if x2 < width:
        dx = min(width - x2, 10)
        canvas.move(platform, dx, 0)

def board_left(event):
    x1, y1, x2, y2 = canvas.coords(platform)
    if x1 > 0:
        dx = min(x1, 10)
        canvas.move(platform, -dx, 0)

canvas.bind_all('<Right>', board_right)
canvas.bind_all('<Left>', board_left)

move_ball()
root.mainloop()
