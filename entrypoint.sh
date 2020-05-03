#!/bin/bash

pwd

failedfile="${PWD}/failed"

repo="$1"
if [ "sistem_pokljuskega_grebena" == "$repo" ]; then
    ls *.svx */svx/*.svx | xargs -I{ bash -c "echo \"{\"; cd \"\$(dirname {)\"; cavern \"\$(basename {)\" || echo \"{\" >> \"$failedfile\"" >> cavern.log
    entities=$(echo *.3d */svx/*.3d)
elif [ "kanin_rombon" == "$repo" ]; then
    ls *.svx meritve/*/*.svx | xargs -I{ bash -c "echo \"{\"; cd \"\$(dirname {)\"; cavern \"\$(basename {)\" || echo \"{\" >> \"$failedfile\"" >> cavern.log
    entities=$(echo *.3d meritve/*/*.3d)
elif [ "planina_poljana" == "$repo" ]; then
    find . -type f -name '*.svx' | xargs -I{ bash -c "echo \"{\"; cd \"\$(dirname {)\"; cavern \"\$(basename {)\" || echo \"{\" >> \"$failedfile\"" >> cavern.log
    entities=$(echo survey/*/*.3d)
else
    echo "Unknown repo $repo"
    exit 1
fi

if [ -f "$failedfile" ]; then
    echo "One or more conversions failed!"
    cat "$failedfile"
    exit 1
fi

for entity in $entities; do
    md5=$(dump3d "$entity" | grep -vE '^DATE\ "' | grep -vE '^DATE_NUMERIC\ ' | md5sum | awk '{print $1}')
    echo "${entity},${md5}" >> "hashes.csv"

    /surv/usr/bin/survexport --legs --gpx "$entity" "${entity%.3d}".gpx |& tee /tmp/out
    test -s /tmp/out && exit 1
done

zip -r artifact.zip *
