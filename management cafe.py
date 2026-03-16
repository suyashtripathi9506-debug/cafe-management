import tkinter as tk
from tkinter import messagebox

# -------- Login Function --------
def login():
    user = username.get()
    pwd = password.get()

    if user == "admin" and pwd == "1234":
        login_window.destroy()
        open_cafe()
    else:
        messagebox.showerror("Error", "Invalid Login")

# -------- Cafe System --------
def open_cafe():
    global coffee_qty, tea_qty, burger_qty, pizza_qty

    cafe = tk.Tk()
    cafe.title("Cafe Management System")
    cafe.geometry("500x500")
    cafe.configure(bg="lightyellow")

    tk.Label(cafe, text="Cafe Menu", font=("Arial",20), bg="lightyellow").pack()

    # Menu Items
    tk.Label(cafe, text="Coffee (50)", bg="lightyellow").pack()
    coffee_qty = tk.Entry(cafe)
    coffee_qty.pack()

    tk.Label(cafe, text="Tea (30)", bg="lightyellow").pack()
    tea_qty = tk.Entry(cafe)
    tea_qty.pack()

    tk.Label(cafe, text="Burger (90)", bg="lightyellow").pack()
    burger_qty = tk.Entry(cafe)
    burger_qty.pack()

    tk.Label(cafe, text="Pizza (120)", bg="lightyellow").pack()
    pizza_qty = tk.Entry(cafe)
    pizza_qty.pack()

    tk.Button(cafe, text="Generate Bill", command=generate_bill).pack(pady=10)

    cafe.mainloop()

# -------- Bill Function --------
def generate_bill():
    coffee = int(coffee_qty.get() or 0)
    tea = int(tea_qty.get() or 0)
    burger = int(burger_qty.get() or 0)
    pizza = int(pizza_qty.get() or 0)

    total = coffee*50 + tea*30 + burger*90 + pizza*120

    bill = f"""
---- Cafe Bill ----

Coffee : {coffee} x 50 = {coffee*50}
Tea    : {tea} x 30 = {tea*30}
Burger : {burger} x 90 = {burger*90}
Pizza  : {pizza} x 120 = {pizza*120}

--------------------
Total Bill = {total}
"""

    messagebox.showinfo("Bill", bill)

# -------- Login Window --------
login_window = tk.Tk()
login_window.title("Cafe Login")
login_window.geometry("300x200")
login_window.configure(bg="lightgreen")

tk.Label(login_window, text="Login", font=("Arial",18), bg="lightgreen").pack()

tk.Label(login_window, text="Username", bg="lightgreen").pack()
username = tk.Entry(login_window)
username.pack()

tk.Label(login_window, text="Password", bg="lightgreen").pack()
password = tk.Entry(login_window, show="*")
password.pack()

tk.Button(login_window, text="Login", command=login).pack(pady=10)

login_window.mainloop()