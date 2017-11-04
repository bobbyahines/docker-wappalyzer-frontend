# docker-wappalyzer-frontend
An executable bash script using the dialog widgets library to provide a simplified gui front end for running Wappalyzer in Docker.

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
and then just copy paste into your favorite json editor. I was mostly just exploring the dialog library to add some pretty to the bash scripts I was writing for devops purposes (automating the builds of consistent sandboxed development environments for my dev team). It's also a minor convenience for me

## Ideas for Extension, Beginner Project, Open Source Contribution
Looking for a project to help you explore bash, dialog, docker, automation, etc?

### Ideas for Extension
Install jq with `sudo apt -y update && sudo apt install jq` and alter the wapper script to parse the gui and log file outputs.

### Beginner Project
Fork this repository and use `wapper.sh` as a template for adding some dialog to your own bash scripts.

### Open Source Contribution

#### Submit A New Feature
Are you looking for your first open source contribution experience? Clone this repo, add a useful feature to the `./wapper-os.sh` and submit a pull request. Leave the `wapper.sh` intact so that others can use the base template for their own needs.

#### Fix An Issue
Or, clone it down, address a current issue ticket, and submit a pull request.

## A Single Linux bash script
***wapper.sh***
Have a look inside, it's pretty darn simple. Most linux distros (e.g. Ubuntu, Mint, etc) include the dialog library of gui widgets. They're plain but effective, and they can be called simply from the command line.
1. After the shebang `#!` line, dialog is called up as an input box requesting a URL.
2. Once the URL is received, the stderr output from dialog is directed into a temporary file called `url.$$`.
3. The temp file is then fed to a variable in the script called `URL`, and then `url.$$` is removed.
4. A variable `DATETIME` is created and is assigned a datetimestamp in string format with numeric characters only.
5. Docker is then ran using the --rm tag to make the serving container ephemeral. The `$URL` variable is given as a target, and the stdout is directed to a file named `log-url.domain.com-YYYYMMDDHHMM.txt`.
6. A new dialog message box opens, and reads the new text file to a message box.
7. On exit, the text file is preserved as a log file containing the json array, and permissions are modded to the running user.

## Run It
Place the wapper.sh file in any folder where you have ownership permissions, or belong to the sudo group.
```
$ sudo ./wapper.sh
```

## Troubleshooting
If the script won't run, first try running it with `sudo`. The script does need write permissions to run.
