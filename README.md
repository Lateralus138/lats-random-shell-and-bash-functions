# lats-random-shell-and-bash-functions

Initial unorganized list of some of my shell/Bash functions. More will be added &amp; I'll eventually organize various lists.

## All Code

```Bash
# Lateralus138's random shell and Bash functions
# This list will be updated for a while as I have lots
# to document and organize first
# Text in square brackets '[]' = optional @params
# Text in angle brackets '<>' (operators) = non-optional @params 

# Run a web search query with DuckDuckGo in your default browser
# Usage: duck [-type:[query type based on DDG type results,images,news,videos etc...]] <string query>
# E.g. duck -type:images tech memes
duck(){
	[ $# -ne 0 ] || return
	local s="https://duckduckgo.com/?q="
	for param in "$@"; do
		case "$param" in
			-type:*) local ia="&ia=${param//\-type\:/}" && continue
		esac
		s="${s}+$param"
	done 
	xdg-open "${s}$ia"
}

# Run google web search query
# I no longer use Google, but here ya go...
google() {
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    xdg-open "http://www.google.com/search?q=$search"
}

# Run Bing web search queries
bing(){
	local pre search term delim
	[ $# -ne 0 ] && pre="/search?q=" &&
	for term in $@;do
		[ -n "${search+x}" ] && delim=+ || delim=""
		search="$search$delim$term"
	done
	xdg-open "https://www.bing.com$pre$search"
	echo "Binging: $@"
}

# Search recursively for text in unkown files
# Usage: search [directory] query
# @params: above params can be in any order
# E.g.: search ${HOME}/Documents "text string I'm searching for"
search() {
	if ! [ $# -gt 0 ]; then
		return 1
	fi
	local item dir qry
	for item in "$@"; do
		[ -d "${item}" ] &&
		dir="$item" ||
		qry="${qry} ${item}"
	done
	grep -rnw ${dir} -e ${qry}
}

# Install x-cursor-theme files with update-alternatives
# Usage: install_cursor <cursor.theme> [90]
# @params: theme file and priority 
install_cursor(){
	[ $# -gt 0  ] ||
	return 1
	local int
	[[ $2 =~ ^-?[0-9]+$ ]] &&
	int=$2 || int=100
	[ -f "$1" ] &&
	sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme "$1" $int ||
	return 1
}

# Convert rgb values to hex format
# Usage: rgbtohex <Red Number> <Green Number> <Blue Number>
# E.g.: rgbtohex 200 220 255 = c8dcff
rgbtohex(){
	local int count R G B
	[ $# -gt 0 ] &&
	for int in "$@"; do
		count=$((count + 1))
		[ "${int}" -eq "${int}" -a "${int}" -le 255 ] 2>/dev/null || return
		if [ $count -eq 1 ]; then
			[ $int -ge 16 ] && R=$(printf '%x' ${int}) || R="0$(printf '%x' ${int})"
		fi
		if [ $count -eq 2 ]; then
			[ $int -ge 16 ] && G=$(printf '%x' ${int}) || G="0$(printf '%x' ${int})"
		fi
		if [ $count -eq 3 ]; then
			[ $int -ge 16 ] && B=$(printf '%x' ${int}) || B="0$(printf '%x' ${int})"
		fi
	done || return 
	echo "${R}${G}${B}"
}
# Rainbow Bash Function
# Rainbow colorize input
# Usage: rainbow <any stdin>
# E.g.
#	- rainbow this is some example text
# 	- rainbow "$(cat some_file.txt)"
# 	- rainbow "$(echo -e "This is text\non two lines")"
rainbow(){
	local params="$*" count=0 int clrs
	for int in {{91..96},{31..36}}; do
		clrs+=("${int}")
	done
	for ((index=0;index<${#params};index++)); do
		count=$((count + 1))
		echo -en "\e[${clrs[$((count - 1))]}m${params:${index}:1}\e[0m"
		[ $((count % 12)) -eq 0 ] && count=0
	done	
	echo
}
# Check if a pid exists
# Dependent on my 'all_spaces' function
# E.g.
#	- pid_exists 1 && echo true
#	- if pid_exists 1504; then echo true; fi
pid_exists(){
        [[ $# -gt 0 ]] &&
        ([[ "$(echo $(all_spaces "$(ps aux)" | \
                cut -f2))" == *" $1 "* ]] && \
        return 0) || return 1
}
```