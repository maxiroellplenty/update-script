# Author Frank Wizard

# OPTIONS
# This Array is used to insert your list of repositories you want to use
declare -a repositories=();

# Import colors
source ~/update-script/scripts/colors.sh

# Base working directory
baseWorkspace='/workspace/';

readRepositories()
{
    while read line || [ -n "$line" ];
    do
        repositories+=("$line")
    done < ~/update-script/scripts/repositories.cfg
    #echo "${repositories[*]}";
    repositoriesLenght=${#repositories[@]};
}

calcProgressBar()
{
    progressBar=$(($progressBar + 1 ));
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
cat << "EOF"
   _______ __     __  __          __      __          _____           _       __ 
  / ____(_) /_   / / / /___  ____/ /___ _/ /____     / ___/__________(_)___  / /_
 / / __/ / __/  / / / / __ \/ __  / __ `/ __/ _ \    \__ \/ ___/ ___/ / __ \/ __/
/ /_/ / / /_   / /_/ / /_/ / /_/ / /_/ / /_/  __/   ___/ / /__/ /  / / /_/ / /_  
\____/_/\__/   \____/ .___/\__,_/\__,_/\__/\___/   /____/\___/_/  /_/ .___/\__/  
                   /_/                                             /_/           
EOF
echo ""
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
        echo "🏁 (${PURPLE}$progressBar/$repositoriesLenght${SET}) ${GREEN} $i √${SET}\n";
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
        echo "🏁 (${PURPLE}$progressBar/$repositoriesLenght${SET}) ${GREEN}$i${SET} √\n";
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

editRepositories()
{
    sudo nano ~/update-script/scripts/repositories.cfg
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
    echo "2. ${YELLOW}Pull all repositories ${SET} ${LIGHTRED}(force reset changes)${SET}"
    echo "3. Show repository list"
    echo "4. Clean local repository ${LIGHTRED}(disabled)${SET}"
    echo "5. Exit"
    echo "6. Edit repositories" 
    echo "7. ${YELLOW}Update script${SET}"
}

read_options()
{
    local choice
    read -p "Enter choice [ 1 - 7] " choice
    case $choice in
        1) pullSave ;;
        2) printWarning ;;
        3) showRepositories;;
        4) main;;
        5) exit 0;;
        6) editRepositories;;
        7) installWarning;;
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
