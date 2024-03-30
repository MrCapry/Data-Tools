#  __Dice Game__
# Dice game with N players
# Player can choose between rolling and not rolling (Y/N)
# If roll is 1, score becomes 0
# Aim of game is to reach MAX_PTS

import random

TOTAL_PLAYERS = int(input("Please enter players count: "))
MAX_PTS = int(input("Please enter max point limit: "))

players_scores = [0 for _ in range(TOTAL_PLAYERS)]
round_counting = 0


def rolling():
    min_dice = 1
    max_dice = 6
    dc = random.randint(min_dice, max_dice)
    return dc


def game_simulation():
    while True:
        round_counting += 1
        winner = 0
        print(f"Round {round_counting} is Open.")

        for player in range(0, TOTAL_PLAYERS):
            print(f"Player {player+1} turn.")

            while True:
                asking = input("Do you want to Continue game? (Y/N)")
                dc = rolling()

                if asking.lower() == "y":
                    print(f"You rolled {dc} ")
                    if dc != 1:
                        players_scores[player] += dc
                    elif dc == 1:
                        players_scores[player] = 0
                        print("Unfortunately your total score is 0")
                        break
                elif asking.lower() == "n":
                    print("Your Turn is Over")
                    break
                else:
                    print("Please enter valid option.")
                    continue

                if players_scores[player] >= MAX_PTS:
                    players_scores[player] == MAX_PTS
                    winner = player + 1
                    print("You overdid max score.")
                    break

                print(f"Curret score is {players_scores[player]}.")

            if winner != 0:
                break

        for pl, score in enumerate(players_scores):
            print(f"Player {pl+1} score is {score}.")

        if winner != 0:
            print(f"Winner is {winner}.")
            break


game_simulation()
