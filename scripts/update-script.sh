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
    while read line || [ -n "$line" ];
    do
        repositories+=("$line")
    done < ~/update-script/scripts/repositories.cfg
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
    echo "⚠️  ${YELLOW}${repositories[*]}${SET}${normal}\n"
    echo "Are you sure you want to reset all local changes Y/N"

    read input
    case $input in
        "Y") pullForce ;;
        "N") main ;;
        "y") pullForce ;;
        "n") main ;;
        *) echo -e "${RED}Error...${SET}" && sleep 2
    esac

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
    printLine
    echo "\n"
    for i in "${repositories[@]}"
    do
        dir="$baseWorkspace$i"
        cd $dir
        if [ -n "$(git status --porcelain)" ]; then
            echo "📂 ${GREEN}started pulling ${i}${SET}"
            echo "there were changes";
            git reset --hard
            git pull
        else
            echo "📂 ${GREEN}started pulling ${i}${SET}"
            git pull
        fi
        calcProgressBar
        echo "🏁 (${PURPLE}$progressBar%${SET}) ${GREEN} $i complete${SET}\n";
    done
    progressBar=0;
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
            echo "📂 ${GREEN}started pulling ${i}${SET}"
            git pull
        fi
        calcProgressBar
        echo "🏁 (${PURPLE}$progressBar%${SET}) ${GREEN} $i complete${SET}\n";
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

cleanLocalRepositoryWarning()
{
    echo "⚠️  ${YELLOW}${bold}This function will remove stale branches and local stashes"${SET}
    echo "Are you sure you want to execute this function Y/N"
    read input
    case $input in
        "Y") cleanLocalRepository ;;
        "N") main ;;
        "y") cleanLocalRepository ;;
        "n") main ;;
        *) echo -e "${RED}Error...${SET}" && sleep 2
    esac
}

install()
{
    echo "${YELLOW}Administrator privileges will be required... ${SET}"
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/maxiroellplenty/update-script/master/scripts/install.sh)"
}

installWarning()
{
    echo "⚠️  ${YELLOW}${bold}Updating the script will override your repository & alias config"${SET}
    echo "Are you sure you want to execute this function Y/N"
    read input
    case $input in
        "Y") install ;;
        "N") main ;;
        "y") install ;;
        "n") main ;;
        *) echo -e "${RED}Error...${SET}" && sleep 2
    esac
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

# function to display menus
show_menus()
{
    printHeader
    echo "1. Pull all repositories"
    echo "2. ${YELLOW}Pull all repositories ${SET} ${RED}(force reset changes)${SET}"
    echo "3. Show repository list"
    echo "${DARKGRAY}4. Clean local repository${SET}"
    echo "5. Exit"
    echo "6. ${YELLOW}Update script${SET}"
}

read_options()
{
    local choice
    read -p "Enter choice [ 1 - 5] " choice
    case $choice in
        1) pullSave ;;
        2) printWarning ;;
        3) showRepositories;;
        4) main;;
        5) exit 0;;
        6) installWarning;;
        *) echo -e "${RED}Error...${SET}" && sleep 2
    esac
}
#trap '' SIGINT SIGQUIT SIGTSTP

main()
{
    repositories=();
    readRepositories
    while true
    do
        show_menus
        read_options
    done
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
