![](https://roelldev.de/assets/images/git-update-script-terminal.svg)

Hello there, this script help's you to pull your git repositories with one click.
It also comes with a list of useful commands which might help you.

## Getting started

Open your terminal and execute this command to install the script
``` bash
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/maxiroellplenty/update-script/master/scripts/install.sh)"
```
## Run script
After your done execute this command to start the script

``` bash
update-util
```

## Edit alias
open the alias file
``` bash
sudo nano ~/update-script/scripts/alias.sh
```
## Edit repository list
open the repositories file
``` bash
sudo nano ~/update-script/scripts/repositories.cfg
```
## Remove package
to delete all scripts run 
``` bash 
sudo rm -rf ~/update-script
```
## Alias Cheat Sheet
***

### Terra

| command                | description                                                              |
|:-----------------------|--------------------------------------------------------------------------|
| `terra start`          | starts local terra node server                                           |
| `terra restart`        | removes **node_modules**, installs node packages and restarts node server|
| `terra install`        | removes **node_modules**, installs node packages                         |
| `terra build`          | builds **terra-components** and creates a clean **terra** install        |
| `terra move`           | changes your current dir to **terra**                                    |


### Vagrant

| command                | description                                                              |
|:-----------------------|--------------------------------------------------------------------------|
| `vm start`             | starts vagrant                                                           |
| `vm stop`              | stops vagrant                                                            |
| `vm ssh`               | connect on to vagrant via ssh                                            |
| `vm move`              | changes your current dir to **vagrant-vm**                               |

### Extra

| command                | description                                                              |
|:-----------------------|--------------------------------------------------------------------------|
| `hosts`                | opens hosts file with administrator privileges                           |
| `terra-components`     | changes your current dir to **terra-components**                         |

### Links

<p>Source Code: <a href="https://github.com/maxiroellplenty/update-script">Github</a></p>
