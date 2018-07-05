## Welcome to Update Script

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

![Preview](/assets/images/preview.png)

## Update alias
open the alias file
``` bash
sudo nano ~/update-script/scripts/alias.sh
```
## Update repository list
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
|:-----------------------|:-------------------------------------------------------------------------|
| `terra-start`          | starts local terra node server                                           |
| `terra-clean-restart`  | removes `node_modules`, installs node packages and restarts node server  |
| `terra-install`        | removes `node_modules`, installs node packages                           |
| `terra-build`          | builds `terra-components` and makes clean `terra` install                |


### Vagrant

| command                | description                                                              |
|:-----------------------|:-------------------------------------------------------------------------|
| `vac-start`            | starts vagrant                                                           |
| `vac-stop`             | stops vagrant                                                            |
| `vac-ssh`              | connect on to vagrant via ssh                                            |
                                     

### Support or Contact

Having trouble with the install? Contact use [contact support](https://github.com/contact) and we’ll help you sort it out.
