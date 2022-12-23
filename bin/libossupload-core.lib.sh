# Begin Standard Operation Workflow
if [[ -e "$2" ]]; then
    for i in $@; do
        $0 $i
    done
    exit 0
fi

OUTPUT_FN="$(ossfncalc "$1")"
FIANL_OBJ_KEY="${OUTPUT_FN}"
FINAL_HTTP_URL="https://${OSS_DOMAIN}/oss/${OUTPUT_FN}"

echo "FIANL_OBJ_KEY=$FIANL_OBJ_KEY"
echo "FINAL_HTTP_URL=$FINAL_HTTP_URL"
if [[ -e $PWD/.osslist ]] && [[ $TMP != y ]]; then
    relative_path="$(sed "s|$PWD/||" <<< "$(realpath "$1")" )"
    echo "$relative_path $FINAL_HTTP_URL" >> $PWD/.osslist
    sort -u .osslist -o .osslist
fi
# End Standard Operation Workflow
