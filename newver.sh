# export NDEVSHELLRC_VERSION="1.1.0"

printf -- 'export NDEVSHELLRC_VERSION="Snapshot %s"\n' "$(TZ=UTC date +%Y-%m-%d)" > _version.sh
