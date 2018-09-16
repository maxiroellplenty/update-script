# Author Frank Wizard
declare -a repositories=();

source ~/update-script/scripts/colors.sh
source ~/update-script/scripts/art.sh

# Base working directory
baseWorkspace='/workspace/';

function readRepositories()
{
    while read line || [ -n "$line" ];
    do
        repositories+=("$line")
    done < ~/update-script/scripts/repositories.cfg
    #echo "${repositories[*]}";
    repositoriesLenght=${#repositories[@]};
}

function calcProgressBar()
{
    progressBar=$(($progressBar + 1 ));
}
function printLine()
{
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' █
}
function printWarning()
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
function pullForce()
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
function pullSave()
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
function showRepositories()
{
    printLine
    echo "${bold}REPOSITORY OVERVIEW ${normal}"
    for repo in "${repositories[@]}"
    do
        dir="$baseWorkspace$repo"
        cd $dir;
        echo "$dir ${bold}=> ${normal} ${PURPLE}`git branch | grep \* | cut -d ' ' -f2`${SET}"
    done
    echo ""
    printLine
}

function pause()
{
    read -p "Press [Enter] key to continue..." fackEnterKey
}

function cleanLocalRepositoryWarning()
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

function install()
{
    echo "${YELLOW}Administrator privileges will be required... ${SET}"
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/maxiroellplenty/update-script/master/scripts/install.sh)"
}

function installAdventure()
{
    printTroll
    cd ~/update-script
    if [ ! -d "BashVenture" ]; then
        sudo git clone https://github.com/apetro/BashVenture.git
    fi
    cd BashVenture
    sudo sh adventure.sh
}

function installWarning()
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

function editRepositories()
{
    sudo nano ~/update-script/scripts/repositories.cfg
}

function cleanLocalRepository()
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
function show_menus()
{
    printHeader
    echo "1. Pull all repositories"
    echo "2. ${YELLOW}Pull all repositories ${SET} ${LIGHTRED}(force reset changes)${SET}"
    echo "3. List repositories"
    echo "4. Clean local repository ${LIGHTRED}(disabled)${SET}"
    echo "5. Edit repositories" 
    echo "6. ${YELLOW}Update script${SET}"
    #echo "7. ${YELLOW}Change branch${SET}"
    echo "exit"
}

function changeBranch()
{
    for i in "${repositories[@]}"
    do
        dir="$baseWorkspace$i"
        cd $dir
        
    done
}

function read_options()
{
    local choice
    read -p "Enter choice [ 1 - 8] " choice
    case $choice in
        1) pullSave ;;
        2) printWarning ;;
        3) showRepositories;;
        4) main;;
        5) editRepositories;;
        6) installWarning;;
        #7) changeBranch;;
        "exit") exit 0;;
        1337) installAdventure;;
        *) echo -e "${RED}Error...${SET}" && sleep 2
    esac
}

#trap '' SIGINT SIGQUIT SIGTSTP

function main()
{
    repositories=();
    readRepositories
    while true
    do
        show_menus
        read_options
    done
}
main