# shellcheck shell=bash
#
# Barebones imitation of Pure theme (https://github.com/sindresorhus)
#

SHELL_COL="$(tput bold)$(tput setaf 8)"
DIR_PATH_COL=$(tput setaf 4)
GIT_BRANCH_COL=$(tput setaf 8)
GIT_STATUS_COL=$(tput setaf 6)
NC=$(tput sgr0)

# color prompt character based on exit code of previous command
function prompt_char() {
  returnVal=$?
  if [ $returnVal -ne 0 ]; then
    promptCharCol=$(tput setaf 1)
  else
    promptCharCol=$(tput setaf 8)
  fi

  echo "${promptCharCol}\$${NC}"
}

# get current branch in git repo
function parse_git_branch() {
  BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ ! "${BRANCH}" == "" ]; then
    STAT=$(parse_git_status)
    echo "${GIT_BRANCH_COL}${BRANCH}${NC}${STAT}"
  else
    echo ""
  fi
}

# get current status of git repo
function parse_git_status() {
  status=$(git status 2>&1 | tee)
  bits=''

  dirty=$(
    echo -n "${status}" 2>/dev/null | grep "Changes " &>/dev/null
    echo "$?"
  )
  if [ "${dirty}" == "0" ]; then
    bits="${bits}${GIT_BRANCH_COL}*${NC}"
  fi

  diverged=$(
    echo -n "${status}" 2>/dev/null | grep "have diverged" &>/dev/null
    echo "$?"
  )
  if [ "${diverged}" == "0" ]; then
    echo "${bits} ${GIT_STATUS_COL}⇡⇣${NC}"
    return
  fi

  behind=$(
    echo -n "${status}" 2>/dev/null | grep "Your branch is behind" &>/dev/null
    echo "$?"
  )
  if [ "${behind}" == "0" ]; then
    echo "${bits} ${GIT_STATUS_COL}⇣${NC}"
    return
  fi

  ahead=$(
    echo -n "${status}" 2>/dev/null | grep "Your branch is ahead" &>/dev/null
    echo "$?"
  )
  if [ "${ahead}" == "0" ]; then
    echo "${bits} ${GIT_STATUS_COL}⇡${NC}"
    return
  fi

  echo "$bits"
}

# shellcheck disable=SC2016
gitStatus='$(parse_git_branch)'
# shellcheck disable=SC2016
promptChar='$(prompt_char)'
shellName="${SHELL_COL}(\s)${NC}"
dirPath="${DIR_PATH_COL}\w${NC}"

export PS1="$dirPath $shellName $gitStatus\n${promptChar} "
# export PROMPT_COMMAND="echo"
