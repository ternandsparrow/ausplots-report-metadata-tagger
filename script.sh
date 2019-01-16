#!/bin/bash
# looks for Ausplots PDF reports in the current directory and...
#   1. renames them to just the location name
#   2. adds PDF metadata to them for SEO
set -e
thisDir=`pwd`
echo "[INFO] running in dir=$thisDir"

renamedDir=$thisDir/renamed
echo "[INFO] cleaning destination dir=$renamedDir"
rm -fr "$renamedDir"
mkdir -p "$renamedDir"

function dedupeCleanName {
  local val=$targetFileName # var is global
  while [ -f "$renamedDir/$val" ]; do
    echo "[WARN] avoiding collision of filename=$val"
    val=`bash -c "echo $val | perl -pe 's/.pdf$/_.pdf/'"`
  done
  targetFileName=$val
}

for curr in *.pdf; do
  # use https://www.debuggex.com/ to figure out how this regex work. What it does:
  #   - look for some leading stuff, then "Summary"
  #   - next we have some separator word, but we don't capture the group (the ?: prefix in the group)
  #   - now we match the bit we're interested in (in a non-greedy way: the *?)
  #   - then strip an optional comma
  #   - last we strip optional state name and ".pdf" suffix
  cleanName=`bash -c "echo '$curr' | perl -pe 's/[\w\s]* Summary.* (?:of|on|near|in|to) (?:[Tt]he )?([a-zA-Z (,)-]*?)(?:,)?(?: (?:SA|NT|QLD|WA|NSW|Victoria))?.pdf/\1/'"`
  targetFileName=$cleanName.pdf
  dedupeCleanName
  targetFilePath=$renamedDir/$targetFileName
  echo "[INFO] moving '$curr' to '$targetFileName'"
  cp "$curr" "$targetFilePath"
  subject="Report from TERN on ecological surveys conducted in/on/near $cleanName"
  keywords="One, Two, Three" # FIXME add keywords
  exiftool \
    -overwrite_original \
    -quiet \
    -Title="$cleanName - TERN Summary of plots" \
    -Subject="$subject" \
    -Description="$subject" \
    -Keywords="$keywords" \
    -Author="TERN" \
    "$targetFilePath"
done
