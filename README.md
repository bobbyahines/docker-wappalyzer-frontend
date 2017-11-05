# wapper
An executable bash script using the dialog widgets library to provide a simplified gui front end for running Wappalyzer in Docker. Oh, and a valuable learning opportunity.

## Dependencies
### Docker https://www.docker.com/what-docker
### Dialog http://invisible-island.net/dialog/
### Bash http://tldp.org/LDP/abs/html/
### Optional: ./jq https://stedolan.github.io/jq/

tl;dr: jq is hot. It's small. It parses and pretty prints json from the command line. It does it very quickly. 

## Why?
It's true, that the wappalyzer team already made it super simple to do this from the command line:
```
$ docker run --rm wappalyzer/cli https://www.some.domain
```
and then just copy paste into your favorite json editor. I was mostly just exploring the dialog library to add some pretty to the bash scripts I was writing for devops purposes (automating the builds of consistent sandboxed development environments for my dev team). It's also a minor convenience for me to double-click an icon and launch a desktop interface on a whim when I'm curious about the stack behind a URL. Granted, you could just make a bash alias without the gui nonsense, but it's another tool to add to your set. 

## Ideas for Extension, Beginner Project, Open Source Contribution
Looking for a project to help you explore bash, dialog, docker, automation, etc?

### Ideas for Extension
Install jq with `sudo apt -y update && sudo apt install jq` and alter the wapper script to parse the gui and log file outputs.

### Beginner Project
Fork this repository and use `wapper.sh` as a template for adding some dialog to your own bash scripts.

### Open Source Contribution

#### Submit A New Feature
Are you looking for your first open source contribution experience? Clone this repo, add a useful feature to the `./wapper-os.sh` and submit a pull request. How about the option to turn logging on and off?

Always leave the `wapper.sh` intact so that others can use the base template for their own needs.

#### Fix An Issue
Or, clone it down, address a current issue ticket, and submit a pull request.

## A Single Linux bash script
***wapper.sh***
Have a look inside, it's pretty darn simple. Most linux distros (e.g. Ubuntu, Mint, etc) include the dialog library of gui widgets. They're plain but effective, and they can be called simply from the command line.
```
#!/usr/bin/env bash
# That first line is called a Shebang line. It lets the system know to 
# pass these commands through the bash program

dialog --title 'wapper' \
         --backtitle 'https://bobbyahines.github.io/wapper/' \
         --no-cancel \
         --inputbox "Enter a URL:" 8 40 \
         https:// \
         2>url.$$
         
# After the shebang  line, dialog is called up as an input box requesting a URL.
# --backtitle prints a string in the upper left corner of the widget's viewport.
# --no-cancel removes the cancel button from the dialog widget.
# --input makes the input box on the widget. The quoted text gets displayed like
# a label on an html form. 8 is a height unit and 40 is a width unit
# https:// is an input option for the --input tag that acts like an html form's
# placeholder option.
# 2>url.$$ sends Dialog's stderr stream to a file called url.$$. The $$ gets 
# converted by the system into a random number.

URL=$(<url.$$)

# A variable called URL is instantiated with the contents of the url.$$ file. 
# $() is a bash method for running a sort of  shell in shell command; most
# anything you'd run on the command line inside of the parentheses. In this 
# case, the < symbol indicates the URL variable will be populated by the contents
# of the url.$$ file.

rm -f url.$$

# Now that the URL is store in a local variable, we can get rid of the temp file.

DATETIME=$(date +%Y%m%d%H%M)

# Next, a variable called DATETIME is instantiated and populate with a string-formatted datetimestamp.

docker run --rm wappalyzer/cli $URL 1>>log-${URL#????????}-$DATETIME.txt

# Docker is then ran using the --rm tag to make the serving container ephemeral. 
# The `$URL` variable is given as a target, and the stdout is directed to a file named `log-url.domain.com-YYYYMMDDHHMM.txt`.

RESULT=`cat log-${URL#????????}-$DATETIME.txt`

# A variable called RESULT is instantiated and populated with the contents of the log file. The ticks ``
# wrapping the cat command are a command substitution method that does the same thing as $().

dialog --title "Wappalyzer" \
        --msgbox "$RESULT" 30 60
        
# A new dialog message box opens, and reads back RESULT variable into a message box.

chown $USER:$USER log-${URL#????????}-$DATETIME.txt

On exit, the text file is preserved as a log file containing the json array, and permissions are modded to the running user.
```

## Run It
Place the wapper.sh file in any folder where you have ownership permissions, or belong to the sudo group.
```
$ sudo ./wapper.sh
```

## Troubleshooting
If the script won't run, first try running it with `sudo`. The script does need write permissions to run.
