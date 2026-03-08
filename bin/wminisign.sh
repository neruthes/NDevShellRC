#!/bin/bash

# 2bf20cd82ecf1ddf56b076b45f2d2855
# refetchw=https://raw.githubusercontent.com/neruthes/NDevShellRC/refs/heads/master/bin/wminisign.sh

#########################################################################################
# The 'wminisign.sh' script
#
# Copyright (c) 2026 Neruthes (https://neruthes.xyz) (https://github.com/neruthes).
# Published with the MIT license (https://mit-license.org/).
#
# This script is a wrapper for the 'minisign' binary, providing some additional data.
#########################################################################################



TMPDIR="$(mktemp -d)"
# Ensure cleanup on exit (normal or error)
trap "rm -r '$TMPDIR'" EXIT


case $1 in 
	sig | s )
		### Common practice to normalize input file
		input_fn="$2"
		[[ -z "$input_fn" ]] && input_fn=/dev/stdin
		cat "$input_fn" > "$TMPDIR/INPUT.txt"

		minisign -Sm "$TMPDIR/INPUT.txt"
		cat "$TMPDIR/INPUT.txt"
		echo '=======_BELOW_IS_MINISIGN_SIGNATURE_======='
		cat "$TMPDIR/INPUT.txt.minisig"
		;;
	validate | verify | v )
		### Common practice to normalize input file
		input_fn="$2"
		[[ -z "$input_fn" ]] && input_fn=/dev/stdin
		cat "$input_fn" > "$TMPDIR/INPUT.txt"

		# grep '=======_BELOW_IS_MINISIGN_SIGNATURE_=======' "$TMPDIR/INPUT.txt"
		if ! grep -qs '=======_BELOW_IS_MINISIGN_SIGNATURE_=======' "$TMPDIR/INPUT.txt"; then
			echo "[FATAL] Input file is not a clear sign file"
			exit 1
		fi
		line_iterating_state=1 # 1=body, 2=separation, 3=sig
		while read -r line; do
			case "$line_iterating_state" in
				1 )
					if grep -qs '=======_BELOW_IS_MINISIGN_SIGNATURE_=======' <<< "$line"; then
						line_iterating_state=2
					else
						echo "$line" >> "$TMPDIR/BODY.txt"
					fi
					;;
				2 )
					line_iterating_state=3
					;;
				3 )
					echo "$line" >> "$TMPDIR/SIG.txt"
					;;
			esac
		done < "$TMPDIR/INPUT.txt"
		ls "$TMPDIR/"*.txt
		echo '================= BODY'
		cat "$TMPDIR/BODY.txt"
		echo '================= SIG'
		cat "$TMPDIR/SIG.txt"
		echo '================= Signature verification result...'
		echo ''
		minisign -V -x "$TMPDIR/SIG.txt" -m "$TMPDIR/BODY.txt"
		echo ''
		;;
esac
