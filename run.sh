#!/bin/bash

mkdir -p repos

export SHELL=/bin/bash
task (){
    export name=$(basename $(dirname $1))
    command=$(cat $1)
    cd repos
    $command
}
export -f task

extract (){
    grep -r --include="*.lisp" "(catch " $1
    grep -r --include="*.lisp" "(throw " $1
}
export -f extract

git-clone (){
    $(which git) clone --depth 1 $@
}
export -f git-clone

git (){
    [ -d $name ] || git-clone $1 $name &>/dev/null
    extract $name
}
export -f git

latest-github-tag (){
    [ -d $name ] || git-clone $1 $name &>/dev/null
    extract $name
}
export -f latest-github-tag

latest-github-release (){
    [ -d $name ] || git-clone $1 $name &>/dev/null
    extract $name
}
export -f latest-github-release

branched-git (){
    [ -d $name ] || git-clone -b $2 $1 $name &>/dev/null
    extract $name
}
export -f branched-git

tagged-git (){
    [ -d $name ] || git-clone -b $2 $1 $name &>/dev/null
    extract $name
}
export -f tagged-git

mercurial (){
    [ -d $name ] || hg clone $1 $name &>/dev/null
    extract $name
}
export -f mercurial

https (){
    if ! [ -d $name ]
    then
        curl -s $1  &>/dev/null
        tar xf $(basename $1) &>/dev/null
    fi
    extract $name
}
export -f https

http (){
    if ! [ -d $name ]
    then
        curl -s $1  &>/dev/null
        tar xf $(basename $1) &>/dev/null
    fi
    extract $name
}
export -f http

ediware-http (){
    [ -d $name ] || git-clone https://github.com/edicl/$1.git $name &>/dev/null
    extract $name
}
export -f ediware-http

svn (){
    [ -d $name ] || svn co $1 $name &>/dev/null
    extract $name
}
export -f svn

single-file (){
    if ! [ -d $name ]
    then
        mkdir $name  &>/dev/null
        curl $1 > $name/$(basename $1)  &>/dev/null
    fi
    extract $name
}
export -f single-file

parallel task ::: quicklisp-projects/projects/*/source.txt
