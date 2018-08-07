### Paths ###
terra='/workspace/terra'
vagrant='/workspace/vagrant-vm'

### Git Update Script Start ###
alias update-util="sh ~/update-script/scripts/update-script.sh"

### Other ###
alias terra-components="cd /workspace/terra-components"
alias ceres="cd /workspace/localsystem/plugins/inbox/plugins/Ceres"
alias hosts="sudo nano /etc/hosts"

### Import Colors ###
source ~/update-script/scripts/colors.sh

function terra()
{
    case $1 in
        move) cd $terra;;
        start) cd $terra && npm start;;
        install) cd $terra && rm -rf node_modules/ && npm i;;
        restart) cd $terra && rm -rf node_modules/ && npm i && npm start;;
        build) cd $terra && npm run build;;
        help) echo "checkout this link for alias information https://maxiroellplenty.github.io/roelldev-blog/2018/07/24/git-update-script/";;
        *) echo -e "${RED}Wrong option type: 'terra help', for help ${SET}" && sleep 1;;
    esac
}

function vm()
{
    case $1 in
        move) cd $vagrant;;
        start) cd $vagrant && vagrant up;;
        stop) cd $vagrant && vagrant halt;;
        ssh) cd $vagrant && vagrant ssh;;
        help) echo "checkout this link for alias information https://maxiroellplenty.github.io/roelldev-blog/2018/07/24/git-update-script/";;
        *) echo -e "${RED}Wrong option type: 'vm help', for help ${SET}" && sleep 1;;
    esac
}