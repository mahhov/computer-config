#!/usr/bin/env bash

# Path to the bash it configuration
export BASH_IT="/Users/manukhovanesian/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Load Bash It
source $BASH_IT/bash_it.sh

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export PATH=$PATH:/Users/manukhovanesian/Library/Android/sdk/platform-tools/

# script alius
alias setting='open -a atom ~/.bash_profile'
alias gitSetting='open -a atom ~/.gitconfig'
alias manuk.hovanesian@farmersinsurance.com=''
#alias killPort="lsof -i tcp:$1 && kill $(lsof -i tcp:$1 | tail -n +2 | awk '{ print $2 }')"
alias ot='open -a textmate $1'
alias o='open -a atom $1'
alias idea='open -a /Applications/IntelliJ\ IDEA\ 2.app $1'
new() {
    touch $1
    open -a atom $1
}

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_112.jdk/Contents/Home

alias happ=app='$(grep -i dev scripts/apps.properties | cut -f2 -d " ")'

# gradle
alias gcbr='./gradlew clean build --refresh-dependencies'
alias gcb='./gradlew clean build'
alias gup='./gradlew uploadArchives'
#alias runjar='java -jar -Dspring.profiles.active=$1 build/libs/*.jar'

nopush() {
    message='nopush/yespush'
    remote=$1
    if [ -z $remote ]; then
        remote=upstream
    fi
    git remote set-url --push $remote \"$message\"
}

yespush() {
    remote=$1
    if [ -z $remote ]; then
        remote=upstream
    fi
    url=$(git remote get-url $remote)
    git remote set-url --push $remote $url
}

quick-package() {
    pushd ~/workspace/easy/salesforce > /dev/null
    ./quick-package.sh $1
    popd > /dev/null
}

quick-deploy() {
    pushd ~/workspace/easy/salesforce > /dev/null
    ./quick-deploy.sh "$@"
    popd > /dev/null
}

runjar() {
	echo "please don't forget to include spring profiles, runjar mule-dev"
	java -jar -Dspring.profiles.active=$1 build/libs/*.jar
	echo "please don't forget to include spring profiles, runjar mule-dev"
}

gitRenameAuthor() {
	git filter-branch -f --env-filter '
	CORRECT_NAME='${1}'
	CORRECT_EMAIL='${2}'
    if [ -z $CORRECT_NAME ]; then
        CORRECT_NAME=m
    fi
    if [ -z $CORRECT_EMAIL ]; then
        CORRECT_EMAIL='mahhov1@gmail.com'
    fi

    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"

	' --tag-name-filter cat -- --branches --tags
}

gitRemoveFileHistory() {
    git filter-branch --force --index-filter \
        "git rm --cached --ignore-unmatch $1" \
        --prune-empty --tag-name-filter cat -- --all
}

herokuApp() {
	echo "HerokuApp <env>"

	# input
	env=$1

	# prompt input
	if [ -z $env ]; then
	  read -p "env: " env
	fi

	# service directory
	cd "${0%/*}"/..

	# get app name
	appName=$(grep -i "$env" scripts/apps.properties | cut -f2 -d " ")

    echo 'set to $appname'
	echo $appName
}

herokuTable() {
	echo "herokuTable <env>"

	# input
	env=$1

	# prompt input
	if [ -z $env ]; then
	  read -p "env: " env
	fi

	# service directory
	cd "${0%/*}"/..

	# get app name
	appName=$(grep -i "$env" scripts/apps.properties | cut -f2 -d " ")

	# retrieve database url from heroku
	databaseUrl=$(heroku config:get DATABASE_URL --app $appName)
	echo $databaseUrl

	# connect to database
	psql $databaseUrl
}

herokuDeployJar() {
    echo "herokuDeployJar <optional -b to build> <env>"

    # input
    while getopts ":b" opt; do
      case $opt in
        b) build=true;;
      esac
    done
    shift "$((OPTIND-1))"
    env=$1

    # prompt input
    if [ -z $env ]; then
      read -p "env: " env
    fi

    # service directory
    cd "${0%/*}"/..

    # get app name
    appName=$(grep -i "$env" scripts/apps.properties | cut -f2 -d " ")

    # build
    if [ "$build" = true ]; then
      echo "building"
      ./gradlew clean build
    fi

    # deploy
    heroku deploy:jar build/libs/*.jar --app $appName
}

herokuOpen() {
    echo "herokuOpen <env>"

    # input
    env=$1

    # prompt input
    if [ -z $env ]; then
      read -p "env: " env
    fi

    # service directory
    cd "${0%/*}"/..

    # get app name
    appName=$(grep -i "$env" scripts/apps.properties | cut -f2 -d " ")

    # heroku open
    heroku open --app $appName
}

herokuLogs() {
    echo "./logs.sh <env>"

    # input
    env=$1

    # prompt input
    if [ -z $env ]; then
      read -p "env: " env
    fi

    # service directory
    cd "${0%/*}"/..

    # get app name
    appName=$(grep -i "$env" scripts/apps.properties | cut -f2 -d " ")

    # view logs
    heroku logs --tail --app $appName
}

mine() {
    java -jar ~/Downloads/launcher/1.5.jar &
    disown
}

remove-gitdualpush() {
    echo 'usage: gitdualpush R2'
    branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
    sha=$(git rev-parse HEAD)
    git push --set-upstream origin $branch
    git co $1
    git co -b $branch.$1
    git cp $sha
    git push --set-upstream origin $branch.$1
    git co $branch
}

remove-gitpullrequest() {
    echo 'usage: gitpullrequest R2 "pull request title"'
    node ~/workspace/easy/git/pullRequests.js $1 $2
}

gitpp() {
    ~/workspace/easy/git/pushPullRequest.sh "$@"
}

jenkinsConfig() {
    cd ~/workspace/easy/jenkins
    o envConfig.json
    read -p "Press enter to continue"
    node configEnvVars.js

    title=$1
    if [ -z $title ]; then
      read -p "title: " title
    fi
    node convertEnvConfig.js
    cd ../../jenkins-push-dir
    git co -b $title
    git add .
    git commit -m $title
    gitpp master
}

gitDeleteRemoteBranch() {
    git push origin --delete $1
}

deploy() {
    echo 'usage deploy <env> [base commit]'

    env=$1
    if [ -z $env ]; then
      read -p "env: " env
    fi

    pushd ~/workspace/easy/deploy
    . deploy.sh
    options=("deploy CSS" "build & deploy CSS" "deploy SF")
    select opt in "${options[@]}"; do
        case $opt in
            ${options[0]})
                deployCss $env
                break
                ;;
            ${options[1]})
                buildDeployCss $env
                break
                ;;
            ${options[2]})
                deploySf $env $2
                break
                ;;
        esac
    done
    popd
}

master() {
    git fetch upstream
    git co master
    git pull upstream master
    git push
}

cutBranch() {
    master
    git co -b $1
    yespush
    git push upstream
    nopush
}

gitAlias() {
    echo 'gitAlias 2018.RELEASE.R0 r0'
    git co $1
    git co -b $2
    git branch --set-upstream-to=upstream/$1
}

angularDeployHeroku() {
    git co deploy
    git rebase master
    ng build
    git add .
    git commit -m 'auto-build'
    git push heroku deploy:master
}

gitDiff() {
    ~/workspace/easy/git/gitDiff.sh "$@"
}

gitPrs() {
    node ~/workspace/easy/git/pullrequests/listPullRequests.js
}

removeNexusCache() {
    rm -rf ~/.m2/repository/com/farmers/
}

sshJenkins() {
    ssh jenkins@10.141.65.91
}

sshJenkins2() {
    ssh admin@10.141.65.24
}

farmersGitAuthor() {
    git config user.name 'Manuk Hovanesian'
    git config user.email 'manuk.hovanesian@farmersinsurance.com'
}

personalGitAuthor() {
    git config user.name 'mahhov'
    git config user.email 'mahhov1@gmail.com'
}

npmUpdate() {
    npm rm -S $1
    npm i -S $1
}

gitReword() {
    ~/workspace/easy/gitReword.sh "$@"
}

lss() {
    du -s * .[!.]* | sort -nr | cut -f2- | xargs du -hsc
}

zipp() {
    name=${1%/}
    zip -r $name.zip $name
}
