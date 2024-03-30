# __Simple Algebra__
# Testing how quickly you can answer simple algebra questions

import random

QUESTIONS = 5

operators = ["*", "-", "+", "**", "//"]
counting = 0

for _ in range(QUESTIONS):
    rnd_1 = random.randint(1, 10)
    rnd_2 = random.randint(1, 10)
    oper = random.choice(operators)
    answ = eval(f"{rnd_1}{oper}{rnd_2}")

    # Asking Question
    custom_ans = int(input(f"What is --> {rnd_1}{oper}{rnd_2}: "))

    # Checking
    if custom_ans == answ:
        print("Correct")
        counting += 1
    else:
        print("Incorrect")
else:
    print(f"{round(counting / QUESTIONS,2)*100}% of was correct")
