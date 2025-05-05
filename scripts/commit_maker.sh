#!/bin/bash

reset="\e[0m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
white="\e[39m"
cyan="\e[96m"
bold="\e[1m"
dim="\e[2m"
underline="\e[4m"

welcome="⚡️ ${bold}Weclome to ${cyan}commit_maker$reset ⚡️\n"
types=("new" "fix" "refactor" "structure" "style" "merge" "doc")
emojis=("✨" "🔧" "♻️ " "🏗️ " "🎨" "🔀" "📝")
selected=0

print_box() {
  local size=${#1}
  local text=$1
  local bc=$2
  local tc=$3
  echo -en "$bc╔"
  for ((i = 0; i < size + 2; i++)); do
    echo -n ═
  done
  echo -e "╗$reset"
  echo -en "$bc║ $reset"
  echo -en "$tc$text$reset"
  echo -e " $bc║$reset"
  echo -en "$bc╚"
  for ((i = 0; i < size + 2; i++)); do
    echo -n ═
  done
  echo -e "╝$reset"
}

clear_and_print() {
  clear
  echo -e $1
}

commit_prev() {
  clear_and_print "$welcome"
  print_box $1 $2 $3
  echo
}

print_menu() {
  clear_and_print "$welcome"
  print_box "Use ↑/↓ to choose, Enter to select:" $dim $dim
  echo
  tput civis
  for i in "${!types[@]}"; do
    if [[ $i -eq $selected ]]; then
      echo -e "$bold$cyan> ${types[$i]}$reset"
    else
      echo "  ${types[$i]}"
    fi
  done
}

# START

# DEFINE TYPE
while true; do
  print_menu
  read -rsn1 key
  if [[ $key == $'\x1b' ]]; then
    read -rsn2 key
    case "$key" in
    '[A') ((selected--)) ;;
    '[B') ((selected++)) ;;
    esac
  elif [[ $key == "" ]]; then
    break
  fi

  ((selected < 0)) && selected=$((${#types[@]} - 1))
  ((selected >= ${#types[@]})) && selected=0
done

type=${types[$selected]}
emoji=${emojis[$selected]}
message="$type"

tput reset
commit_prev $message $white $bold$cyan
echo -e "$green>$reset Type : $green$type$reset"
echo -ne "$cyan>$reset Scope : $cyan"

# DEFINE SCOPE
read scope
echo -e $reset
if [[ -z $scope ]]; then
  message+=":"
else
  message+="($scope):"
fi

commit_prev $message $white $bold$cyan
echo -e "$green>$reset Type : $green$type$reset"
if [[ -z $scope ]]; then
  echo -e "$red>$reset Scope : {$dim}no scope$reset"
else
  echo -e "$green>$reset Scope : $green$scope$reset"
fi

# DEFINE DESC
echo -ne "$cyan>$reset Description : $cyan"
read desc
while [[ -z $desc ]]; do
  echo -ne "$cyan>$reset Description : $cyan"
  read desc
done
echo -e "$reset\n"
message+=$desc
commit_prev $message $white $bold$cyan
echo -e "$green>$reset Type : $green$type$reset"
if [[ -z $scope ]]; then
  echo -e "$red>$reset Scope : {$dim}no scope$reset"
else
  echo -e "$green>$reset Scope : $green$scope$reset"
fi
echo -e "$green>$reset Description : $green$desc$reset\n$dim"
echo -e "Press Enter to contiue ...$reset"
tput civis

read -rsn1 key
while [[ $key != "" ]]; do
  read -rsn1 key
done
tput reset

#CONFIRM
echo -e $welcome

full_message="$emoji $message"
echo -e "$full_message\n"
echo -ne "Confirm commit message [${green}y$reset/${red}n$reset] : "
read -n1 conf
while [[ $conf != "y" && $conf != "n" ]]; do
  echo -ne "Confirm commit message [${green}y$reset/${red}n$reset] : "
  read -n1 conf
done
echo
if [[ $conf == 'n' ]]; then
  echo -e "❌ Commit aborted ❌\n"
else
  echo -e "git commit -m \"$full_message\"\n"
fi
