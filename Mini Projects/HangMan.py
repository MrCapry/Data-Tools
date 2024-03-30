# __HangMan__

import os
import random

current = os.getcwd()

print(current)
MAX_INCORRECT = 4
path = os.path.join(current, "words.txt")
words = []

with open(path, "r") as file:
    for i in file:
        words.append(i.strip())

# Chosen word
chosen = random.choice(words)


# HangMan Game simulation
def game_simulation():
    counter = 0
    customer_inp = []

    while counter < MAX_INCORRECT:
        inp = input("Please enter a letter: ")
        customer_inp.append(inp)

        if inp in chosen:
            print("Nice, you guessed it.")
        else:
            print("Unfortunately, you didn't guessed it.")
            counter += 1

        print(f"You left total {MAX_INCORRECT-counter} guesses.")

        wrd = ""
        for let in chosen:
            if let in customer_inp:
                wrd += let
            else:
                wrd += "_"
        print(wrd)

        if counter == MAX_INCORRECT:
            print("Unfortunately, you have lost")
            print(f"Correct word was {chosen}.")
        elif wrd == chosen:
            print("Nice You have guessed word")
            break


game_simulation()
