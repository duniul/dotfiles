# shellcheck shell=bash

# find shorthand
function f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# List all files, long format, colorized, permissions in octal
function la() {
	# shellcheck disable=SC2012
	ls -l "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

# Print original and gzipped size
function gz() {
	printf "%-20s %12s\n" "compression method" "bytes"
	printf "%-20s %'12.0f\n" "original" "$(cat $1 | wc -c)"
	printf "%-20s %'12.0f\n" "gzipped (-5)" "$(cat $1 | gzip -5 -c | wc -c)"
	printf "%-20s %'12.0f\n" "gzipped (--best)" "$(cat $1 | gzip --best -c | wc -c)"
}

# Update all the things
function allup() {
  echo "Some updates might require sudo!"
  sudo -v

  echo "-- HOMEBREW --"
  brewup

  echo "-- PNPM --"
  pnpmup

  echo "-- PIP --"
  pipup
}

# Update pip and it's packages
function pipup() {
  echo 'Updating pip...'
  pip3 install --upgrade pip

  echo 'Updating pip packages...'
  pip3 list --outdated --format=json | jq '.[].name' | xargs -n1 pip3 install -U
}

# Update brew, upgrade brew and cask installs, cleanup and run doctor
function brewup() {
	echo "Some updates might require sudo!"
	sudo -v

	echo "Updating Homebrew..."
	brew -v update

	echo "Upgrading Homebrew installs..."
	brew upgrade -v --force-bottle

	echo "Cleaning up Homebrew installs..."
	cleanup-brew

	echo "Running Homebrew doctor..."
	brew doctor --verbose
}

# Dump a Brewfile to ~/.Brewfile or to a provided path. `brewdump [filepath]`
function brewdump() {
	file=$1
	if [ -n "$file" ]; then
		brew bundle dump --force --file "$file"
	else
		brew bundle dump --force --global
	fi
}

# Clean up unused Homebrew dependencies and packages
function cleanup-brew() {
	echo "Cleaning up Homebrew installs..."
	dateSeconds=$(date +%s)
	tmpBrewfile="$TMPDIR/Brewfile-$dateSeconds"
	brew bundle dump --file=$tmpBrewfile --force &>/dev/null
	brew bundle cleanup --file=$tmpBrewfile &>/dev/null
	brew cleanup >/dev/null
	rm -f $tmpBrewfile >/dev/null
}

# Recursively delete .DS_Store files
function cleanup-dsstore() {
	find . -type f -name '*.DS_Store' -ls -delete
}

# Clean up LaunchServices to remove duplicates in the “Open With” menu
function cleanup-ls() {
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
}

# Change to directory opened by Finder
function cdfinder() {
	if [ -x /usr/bin/osascript ]; then
		target=$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
		if [ "$target" != "" ]; then
			cd "$target" || return
			pwd
		else
			echo 'No Finder window found' >&2
		fi
	fi
}

alias cdf='cdfinder'

# Empty the trash on all mounted volumes and main storage, clear Apple's system logs and then clear download history from quarantine
function emptytrash() {
	sudo rm -rfv /Volumes/*/.Trashes
	sudo rm -rfv /private/var/log/asl/*.asl
	rm -rfv ~/.Trash
	rm -rfv ~/Library/Caches/com.spotify.client/Data
	sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
}

# Direct any output to /dev/null
function nullify() {
	"${@}" >/dev/null 2>&1
}

# Get week number
function week() {
	date +%V
}

# Shut down macOS
function shutdownox() {
	# cf. http://apple.stackexchange.com/a/103633
	osascript -e 'tell app "System Events" to shut down'
}

# Print LS_COLORS, listing types and extensions in their assigned color.
# Uses current LS_COLORS by default, but also accepts a .dircolors file.
function print_colors() {
	originalLsColors=$LS_COLORS
	dircolorsFile=$1

	# temporarily set LS_COLORS if .dircolors file is provided
	if [ -n "$dircolorsFile" ]; then
		eval "$(gdircolors -b $dircolorsFile)"
	fi

	IFS=:
	tags=()
	# shellcheck disable=SC2068
	for ls_color in ${LS_COLORS[@]}; do
		typeOrExt=${ls_color%%=*} # grab content before =
		color=${ls_color##*=}     # grab content after

		if [[ $color =~ ^[0-9\;]+$ ]]; then
			tags+=("\e[${color}m${typeOrExt}\e[0m")
		else
			tags+=("$typeOrExt")
		fi
	done

	# reset LS_COLORS
	export LS_COLORS=$originalLsColors
	echo -e ${tags[*]}
}

alias print_lscolors="print_colors"
alias print_dircolors="print_colors"

# Print all possible dircolors codes
function print_dircolors_codes() {
	tags=()

	# add basic codes
	codes=(
		"00" "01" "02" "03" "04" "05" "07" "08"
		"30" "31" "32" "33" "34" "35" "36" "37"
		"40" "41" "42" "43" "44" "45" "46" "47"
	)

	# add all 256 colors
	for i in {0..255}; do
		codes+=("38;5;$i")
	done

	lbCount=0
	for code in "${codes[@]}"; do
		tags+=("\e[${code}m${code}\e[0m")

		((lbCount++))
		if [ "$lbCount" -eq 5 ]; then
			lbCount=0
			tags+=("\n")
		fi
	done

	echo -e " ${tags[*]}"
}

# Print network name of connected wifi network
function wifi-network() {
	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'
}

#Print wifi password (requires keychain authentication)
function wifi-password() {
	security find-generic-password -wa "$(wifi-network-name)"
}

# Turn wifi connection on and off.
function wifi-reset() {
	networksetup -setairportpower en0 off
	networksetup -setairportpower en0 on
}

# Print the date in ISO format
function isodate() {
	date +%Y-%m-%d
}

# Log in with aws-google-auth and extract credentials with aws-export-profile.
function aws-sso-login() {
	profile=$1

	# If no profile is passed, use the the AWS_PROFILE.
	if [ -z "$profile" ]; then
		profile=$AWS_PROFILE
	fi

	echo "Logging in with profile: $profile"
	echo

	aws sso login --profile $profile
	yawsso --profile $profile
}

# Update all global packages installed with Volta to the latest version
function voltup() {
	packagesPath="$VOLTA_HOME/tools/user/packages"
	voltaFiles=$(ls $packagesPath)

	echo -e "Updating all global packages installed with Volta...\n"

	for file in $voltaFiles; do
		packagePath="$packagesPath/$file"
		name=$(jq -r '.name' $packagePath)

		volta install $name
	done

	echo "Done, all global packages have been updated!"
}
