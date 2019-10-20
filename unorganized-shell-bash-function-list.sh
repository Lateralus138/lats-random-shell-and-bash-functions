# Lateralus138's random shell and Bash functions
# This list will be updated for a while as I have lots
# to document and organize first
# Text in square brackets '[]' = optional @params
# Text in angle brackets '<>' (operators) = non-optional @params 

# Run a web search query with DuckDuckGo in your default browser
# Usage: duck [-type:[query type based on DDG type results,images,news,videos etc...]] <string query>
# E.g. duck -type:images tech memes
function duck(){
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
function google() {
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    xdg-open "http://www.google.com/search?q=$search"
}

# Run Bing web search queries
function bing(){
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
function search() {
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
function install_cursor(){
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
function rgbtohex(){ # V3
	local int count R G B
	[ $# -gt 0 ] &&
	for int in "$@"; do
		count=$((count + 1))
		[ "${int}" -eq "${int}" -a "${int}" -le 255 ] 2>/dev/null || return
		if [ $count -eq 1 ]; then
			if [ $int -ge 16 ]; then
				R=$(printf '%x' ${int})
			else
				R="0${int}"
			fi
		fi
		if [ $count -eq 2 ]; then
			if [ $int -ge 16 ]; then
				G=$(printf '%x' ${int})
			else
				G="0$(printf '%x' ${int})"
			fi
		fi
		if [ $count -eq 3 ]; then
			if [ $int -ge 16 ]; then
				B=$(printf '%x' ${int})
			else
				B="0${int}"
			fi
		fi
	done || return 
	echo "${R}${G}${B}"
}
