# shellcheck shell=bash

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

  echo "-- FISHER --"
  fisherup

  echo "-- PIP --"
  pipup

  echo "-- PNPM --"
  pnpmup

  echo "-- RUST --"
  rustup update
}

# Update all fisher packages
function fisherup() {
  echo 'Updating fisher...'
  fisher update
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
	brew upgrade -v

	echo "Cleaning up Homebrew installs..."
	cleanup-brew

	echo "Running Homebrew doctor..."
	brew doctor --verbose
}

# Dump a Brewfile to ~/.Brewfile or to a provided path. `brewdump [filepath]`
function brewdump() {
	file=$1

	if [ -z "$file" ]; then
		file="$HOME/.Brewfile"
	fi

	brew bundle dump --force --file "$file"

	# Remove vscode entries from the Brewfile
	sed -i '' '/^vscode/d' "$file"
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
	gfind . -type f -name '.DS_Store' -ls -delete
}

# Clean up LaunchServices to remove duplicates in the "Open With" menu
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

# Print LS_COLORS, listing types and extensions in their assigned color.
# Uses current LS_COLORS by default, but also accepts a .dircolors file.
function print-colors() {
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

alias print-lscolors="print-colors"
alias print-dircolors="print-colors"

# Print all possible dircolors codes
function print-dircolors-codes() {
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
	ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'
}

#Print wifi password (requires keychain authentication)
function wifi-password() {
	security find-generic-password -a "$(wifi-network)" -s "AirPort" -w
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

# Log in with AWS SSO and extract credentials with yawsso.
function aws-login-sso() {
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
