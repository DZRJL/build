#!/bin/bash

pwd

failedfile="${PWD}/failed"

repo="$1"
if [ "sistem_pokljuskega_grebena" == "$repo" ]; then
    _svxFiles=*/svx/*.svx
    _3dFiles=*/svx/*.3d
elif [ "kanin_rombon" == "$repo" ]; then
    surveysDir="surveys"
    _svxFiles=${surveysDir}/*/*.svx
    _3dFiles=${surveysDir}/*/*.3d
elif [ "planina_poljana" == "$repo" ]; then
    surveysDir="surveys"
    _svxFiles=${surveysDir}/*/*.svx
    _3dFiles=${surveysDir}/*/*.3d
else
    echo "Unknown repo $repo"
    exit 1
fi

ls *.svx $_svxFiles | xargs -I{ bash -c "echo \"{\"; cd \"\$(dirname {)\"; cavern \"\$(basename {)\" || echo \"{\" >> \"$failedfile\"" >> cavern.log

if [ -f "$failedfile" ]; then
    echo "One or more conversions failed!"
    cat "$failedfile"
    echo "cavern.log"
    cat cavern.log
    exit 1
fi

for entity in *.3d $_3dFiles; do
    md5_3d=$(dump3d "$entity" | grep -vE '^DATE\ "' | grep -vE '^DATE_NUMERIC\ ' | md5sum | awk '{print $1}')
    echo "${entity},${md5_3d}" >> "hashes.csv"

    /surv/usr/bin/survexport --legs --gpx "$entity" "${entity%.3d}".gpx |& tee /tmp/out
    test -s /tmp/out && exit 1
    
    gpx_file="${entity%.3d}.gpx"
    if [ -f "$gpx_file" ]; then
        md5_gpx=$(md5sum "$gpx_file" | awk '{print $1}')
        echo "${gpx_file},${md5_gpx}" >> "hashes.csv"
    fi
done

zip -r artifact.zip . -i "*.3d" "*.gpx" "ekataster-config.json" "hashes.csv"
