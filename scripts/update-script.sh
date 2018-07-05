# Author Frank Wizard

# OPTIONS
# This Array is used to insert your list of repositories you want to use
declare -a repositories=();

# Base working directory
baseWorkspace='/workspace/';

# Colors
DARKGRAY='\033[1;30m'
RED='\033[0;31m'
LIGHTRED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
LIGHTPURPLE='\033[1;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
SET='\033[0m'

bold=$(tput bold)
normal=$(tput sgr0)

readRepositories()
{
    CURDIR=`/bin/pwd`
    while read line || [ -n "$line" ];
    do
        repositories+=("$line")
    done < "$CURDIR/repositories.cfg"
    #echo "${repositories[*]}";
    repositoriesLenght=${#repositories[@]};
    progressStep=$((100 / $repositoriesLenght));
}

calcProgressBar()
{
    progressBar=$(($progressBar + $progressStep));
}
printLine()
{
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' █
}
printWarning()
{
    echo "${bold}This script will reset all current changes to:"
    echo "🔨 ${RED}${repositories[*]}${SET}${normal}"
}
printHeader()
{
    echo "${GREEN}"
cat << "EOF"


████████╗███████╗██████╗ ██████╗  █████╗
╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔══██╗
   ██║   █████╗  ██████╔╝██████╔╝███████║
   ██║   ██╔══╝  ██╔══██╗██╔══██╗██╔══██║
   ██║   ███████╗██║  ██║██║  ██║██║  ██║
   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
EOF
    echo "${SET}"
}
pullForce()
{
    printWarning
    printLine
    echo "\n"
    for i in "${repositories[@]}"
    do
        dir="$baseWorkspace$i"
        cd $dir
        if [ -n "$(git status --porcelain)" ]; then
            echo "🌎 ${GREEN}started pulling ${i}${SET}"
            echo "there were changes";
            git reset --hard
            git pull
        else
            echo "🌎 ${GREEN}started pulling ${i}${SET}"
            git pull
        fi
        calcProgressBar
        echo "🍕 (${PURPLE}$progressBar%${SET}) ${GREEN} $i complete${SET}\n";
    done
    progressBar=$(0);
    printLine
}
pullSave()
{
    printLine
    echo "\n"
    for i in "${repositories[@]}"
    do
        dir="$baseWorkspace$i"
        cd $dir
        if [ -n "$(git status --porcelain)" ]; then
            echo "there are local changes at ${i}";
            echo "${RED}cancel pull action!${SET}"
        else
            echo "🌎 ${GREEN}started pulling ${i}${SET}"
            git pull
        fi
        calcProgressBar
        echo "🍕 (${PURPLE}$progressBar%${SET}) ${GREEN} $i complete${SET}\n";
    done
    progressBar=0;
    printLine
}
showRepositories()
{
    printLine
    echo "${bold}REPOSITORY OVERVIEW ${normal}"
    echo ""
    for repo in "${repositories[@]}"
    do
        dir="$baseWorkspace$repo"
        cd $dir;
        unixTimeStamp=$(stat -f '%m' .git/FETCH_HEAD)
        if [[ -z $(git status -s) ]]; then
            echo "${bold}Repository: ${normal} $repo";
            echo "${bold}Status:     ${normal} ${GREEN}Up to date ${SET}";
            echo "${bold}Last Pull:  ${normal} $(date -r "$unixTimeStamp")";
        else
            echo "${bold}Repository: ${normal} $repo";
            echo "${bold}Status:     ${normal} ${RED}Outdated or Changes ${SET}";
            echo "${bold}Last Pull:  ${normal} $(date -r "$unixTimeStamp")";
        fi
        echo "";
    done
    printLine
}

pause()
{
    read -p "Press [Enter] key to continue..." fackEnterKey
}

# function to display menus
show_menus()
{
    printHeader
    echo "1. Pull all repositories (force reset changes)"
    echo "2. Pull all repositories"
    echo "3. Show repository list"
    echo "4. Clean local repository"
    echo "5. Exit"
}

cleanLocalRepository()
{
    local choice
    local count=0
    
    for i in "${repositories[@]}"
    do
        echo "$count. $baseWorkspace${PURPLE}$i${SET}";
        count=$((count+1))
    done
    
    read -p "select the repository you want to clean  " choice
    dir="$baseWorkspace${repositories[$choice]}";
    cd $dir;
    git fetch -p && for branch in `git branch -vv | grep ': gone]' | awk '{print $1}'`; do git branch -D $branch; done
}

read_options()
{
    local choice
    read -p "Enter choice [ 1 - 5] " choice
    case $choice in
        1) pullForce ;;
        2) pullSave ;;
        3) showRepositories;;
        4) cleanLocalRepository;;
        5) exit 0;;
        *) echo -e "${RED}Error...${SET}" && sleep 2
    esac
}
#trap '' SIGINT SIGQUIT SIGTSTP

main()
{
    readRepositories
    while true
    do
        show_menus
        read_options
    done
}

install()
{
    echo "${PURPLE} Installing terra update script ${SET}";
    
}
if  [ "$1" == "-install" ]
then
    install
elif [ "$1" == "-update" ]
then
    echo "test"
else
    main
fi
