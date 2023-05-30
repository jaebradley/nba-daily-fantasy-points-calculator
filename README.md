# DraftKings NBA Daily Fantasy Points Calculator

## Introduction

This project started as an exercise in getting better at Bash while also providing a useful tool for other NBA Daily Fantasy Sports enthusiasts.

One thing I've always wanted to build is a command line program to print a list of the DraftKings Daily Fantasy Points associated with NBA players on a given date. 

This program would make it easy to see how well the players I've picked are doing, but more importantly, to see the performance of players that I did not select.

![](https://media.giphy.com/media/sjo5pxKNidC3Ltgww4/giphy.gif)

## Build and Local Setup

My development environment is on a macOS operating system so the build, dependencies, system programs, etc are tailored _only_ for use on a macOS operating system.

There are two dependencies:

1. [`jq`](https://github.com/wader/fq) for parsing JSON responses from the NBA data API (for getting the games that are played on a given day and for getting the player stats for a given game)
2. [`shellcheck`](https://github.com/koalaman/shellcheck) for linting `.sh` files in the project. This is strictly a "development" dependency, called when building the project, but _not_ used when running the main program.

### To set up this project locally

1. Checkout the repository
2. Run the build by executing `bash build/execute.sh` (assuming the current directory is the project directory)
  * When running the build, the dependencies are installed (there is a very specific version expected for each dependency) in the installation directory (the `.dependencies` directory within the project directory).
  * If the dependencies are _already_ installed, they will not be installed again - unless the detected programs in the `.dependencies` directory have a version that do _not_ match the expected version(s)
  * After the build installs dependencies, a series of unit and integration tests are executed
    * The integration tests will fail if your device is not connected to the Internet
  * After the tests execute successfully, linting via the `shellcheck` program will execute

## Usage

To use the calculator program

1. Checkout the repository
2. Execute the following command in a terminal program (assumes the current directory is the project directory)

```bash
# Command should be in the following form:
bash main.sh "YYYY" "MM" "DD" "some/path/to/the/jq/program"

# So for example:
bash main.sh "2023" "05" "06" "/Users/MyUser/local/bin/jq"
```

If you've executed the `build/execute.sh` program successfully (and installed the dependencies successfully), then the path to the `jq` program  can be omitted and the `jq` program located in the `.dependencies` directory will be used.

```bash
bash main.sh "2023" "05" "06"  | head -5

# Prints the following lines to the terminal
Bam Adebayo|35.00|ACTIVE
Caleb Martin|8.25|ACTIVE
Cody Zeller|14.00|ACTIVE
DaQuan Jeffries|0|ACTIVE
Derrick Rose|0|ACTIVE
```

## Combining this program with other tools

### The 10 Players With The Most DraftKings DFS Points

```bash
bash main.sh "2023" "05" "06" | awk -F '|' '{ print $2, $1 }' | uniq | sort -gr | head -10

# Prints the following lines to the terminal
59.75 Anthony Davis
46.00 LeBron James
40.50 Jimmy Butler
39.50 Jalen Brunson
37.00 Stephen Curry
36.50 Josh Hart
36.25 Andrew Wiggins
35.00 Bam Adebayo
34.25 D'Angelo Russell
30.00 Julius Randle
```
