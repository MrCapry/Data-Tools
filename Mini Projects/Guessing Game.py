# __Guessing Game__
# You have to guess integer correctly

import random

MIN_VALUE = int(input("Please enter min limit: "))
MAX_VALUE = int(input("Please enter max limit: "))
MAX_INCORRECT = 7


def game_simulation():
    print(f"Please guess number between {MIN_VALUE} and {MAX_VALUE} .")
    guessing = random.randint(MIN_VALUE, MAX_VALUE)

    counter = 0
    while counter < MAX_INCORRECT:
        inp = int(input("Please enter an integer: "))
        if inp != guessing:
            counter += 1
            if inp < guessing:
                print("Higher")
            else:
                print("Lower")
        elif inp == guessing:
            print("You have guessed integer.")
            break

        print(f"{MAX_INCORRECT - counter} tries left. ")
    if counter == MAX_INCORRECT:
        print(f"Correct integer was {guessing}.")


game_simulation()
