fedRate = 24
stateRate = 5.75
fica = 7.65
income = 114251+226137

def main():
    # Main program logic goes here
    federal_tax = round(income * (fedRate / 100), 2)
    state_tax = round(income * (stateRate / 100), 2)
    fica_tax =round( income * (fica / 100), 2)
    total_tax = federal_tax + state_tax + fica_tax
    print(total_tax)


if __name__ == "__main__":
    main()