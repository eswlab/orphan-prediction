#!/bin/bash

# Join all tpm to a single matrix.
# Row is transcript ID, column is RNA-Seq SRR ID.

if [[ $# -ge 2 ]]; then
    function __r {
        if [[ $# -gt 1 ]]; then
            exec join - "$1" | __r "${@:2}"
        else
            exec join - "$1"
        fi
    }

    __r "${@:2}" < "$1"
fi
