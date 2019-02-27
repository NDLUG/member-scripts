#!/usr/bin/env python
import re
import requests
import json
import sys


# Functions ----------------------------------------------


def usage(status=0):
    print("""Usage: dining.py [-f -r REGEX -d DATE -m MEAL]
    -f            Search for my favorite foods.
    -r REGEX      Use a regex to search for food items.
    -d DATE       Search only on a certain day. Format: "MM-DD"
    -m MEAL       Search only for certain meals. [breakfast, lunch, latelunch, dinner]"
    -ndh          Search North Dining Hall instead of south
    Note: -f and -r cannot be used together.""")
    exit(status)


# Main execution ------------------------------------------


if __name__ == "__main__":
    # Variables
    URL = "http://auxopsweb2.oit.nd.edu/DiningMenus/api/Menus/47"
    REGEX = ".*"
    FAVORITES = "Amy's|Wing|Reese's Peanut|Bacon|Pancake|Cinnabon|Churo|Cinnamon Iced|French|Cranberry|Cinnamon"
    DATE = "....-..-.."
    MEAL = ".*"

    # Parse command line options
    args = sys.argv[1:]
    while len(args) and args[0].startswith('-') and len(args[0]) > 1:
        arg = args.pop(0)
        if arg == '-f':
            REGEX = FAVORITES
        elif arg == '-r':
                REGEX = args.pop(0)
        elif arg == '-d':
                DATE = "....-" + args.pop(0)
        elif arg == '-m':
            MEAL = args.pop(0).capitalize()
            if MEAL == "Latelunch":
                MEAL = "Late"
        elif arg == '-ndh':
                URL = "http://auxopsweb2.oit.nd.edu/DiningMenus/api/Menus/46"
        elif arg == '-h':
                usage(0)
        else:
            usage(1)

    response = requests.get(URL).text
    jsonData = json.loads(response)

    for meal in reversed(jsonData):
        items = {}
        containsItem = False
        correctDate = re.search(DATE, meal["EventStart"])
        correctMeal = re.search(MEAL, meal["Meal"])
        
        for course in meal["Courses"]:
            category = course["Name"]
            items[category] = []
            for item in course["MenuItems"]:
                if re.search(REGEX, str(item["Name"]), re.IGNORECASE):
                    items[category].append(str(item["Name"]))
                    containsItem = True
        
        if containsItem and correctDate and correctMeal:
            print("")
            print("")
            print(meal["ServiceUnit"])
            print(meal["Meal"])
            print(re.findall("(" + DATE + ")", meal["EventStart"])[0])
            print("********************************")
            for category in items:
                if len(items[category]) > 0:
                    print(category + ":")
                    for item in items[category]:
                        print("        ", item)
            print("********************************")

