#!/bin/sh
#
# One deliberately bad instruction file against every rule, compared to a
# golden file; then a rewrite, required to produce nothing; then the guards,
# which pin what each rule must leave alone. A Vale rule that matches nothing
# fails silently, so the golden files double as the coverage report: a rule
# no fixture reaches is indistinguishable from one that is broken.
#
# `./test.sh -u` rewrites the golden files instead of comparing.
set -eu

update=0
[ "${1:-}" = "-u" ] && update=1
status=0

root=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

vale=${VALE:-vale}
mkdir -p "$root/testdata"
cp -R "$root/Prompts" "$work/Prompts"

cat > "$work/.vale.ini" <<INI
StylesPath = .
MinAlertLevel = suggestion

[*.md]
BasedOnStyles = Prompts
INI

# Alerts that share a line and column come back in whatever order the checks
# ran; sorting compares the set, which is what the fixtures assert.
run() { # <file> -> alerts on stdout, sorted
	cp "$1" "$work/$(basename "$1")"
	(cd "$work" && "$vale" --output=line --no-global "$(basename "$1")" 2>&1 || true) |
		sort -t: -k2,2n -k3,3n -k4,4
}

compare() { # <label> <fixture> <golden>
	_got=$(run "$2")
	if [ "$update" -eq 1 ]; then
		printf '%s\n' "$_got" > "$3"
		return 0
	fi
	if [ ! -f "$3" ]; then
		echo "FAIL $1: no golden file; run ./test.sh -u"
		status=1
	elif [ "$_got" != "$(cat "$3")" ]; then
		echo "FAIL $1"
		printf '%s\n' "$_got" | diff -u "$3" - || true
		status=1
	else
		echo "ok   $1 ($(printf '%s' "$_got" | grep -c . || true) alerts)"
	fi
}

compare before "$root/fixtures/before.md" "$root/testdata/before.txt"
compare skill "$root/fixtures/SKILL.md" "$root/testdata/skill.txt"
compare guards "$root/fixtures/guards.md" "$root/testdata/guards.txt"

got=$(run "$root/fixtures/after.md")
if [ -n "$got" ]; then
	echo "FAIL after: the rewrite still violates the style"
	printf '%s\n' "$got"
	status=1
else
	echo "ok   after (clean)"
fi

# Every rule has to fire on something.
if [ "$update" -eq 0 ]; then
	(cd "$root/Prompts" && ls *.yml) | sed 's/\.yml$/Prompts./; s/^\(.*\)Prompts\.$/Prompts.\1/' | sort > "$work/rules"
	cat "$root"/testdata/*.txt | cut -d: -f4 | sort -u > "$work/fired"
	missing=$(comm -23 "$work/rules" "$work/fired")
	if [ -n "$missing" ]; then
		echo "FAIL coverage: no fixture reaches these rules"
		printf '%s\n' "$missing" | sed 's/^/       /'
		status=1
	else
		echo "ok   coverage ($(wc -l < "$work/rules" | tr -d ' ') rules, every one exercised)"
	fi
fi

# The repository lints its own prose with the rules it ships. Any alert
# fails it: Vale's exit code only reports errors, and a README that warns
# about itself is the case this exists to catch.
if [ "$update" -eq 0 ]; then
	self=$(cd "$root" && "$vale" --no-global --no-exit --output=line . 2>&1 || true)
	if [ -z "$self" ]; then
		echo "ok   self-lint"
	else
		echo "FAIL self-lint:"
		printf '%s\n' "$self" | head -5
		status=1
	fi
fi

[ "$update" -eq 1 ] && echo "golden files rewritten"
exit $status
