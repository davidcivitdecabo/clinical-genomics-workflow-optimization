#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo "  amelie_vcf.sh <sample>"
    exit 1
fi

SAMPLE=$1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

source "$ROOT_DIR/config/system.conf"
source "$ROOT_DIR/config/amelie_profiles/vcf.conf"

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

HPO_FILE="${SAMPLE_DIR}/HPO_terms.txt"
VCF_FILE="${SAMPLE_DIR}/${VCF_NAME}"

OUTPUT_DIR="${RESULTS_DIR}/amelie_vcf"

mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="${OUTPUT_DIR}/amelie_${SAMPLE}.json"

HPOS=$(paste -sd "," "$HPO_FILE")

export SAMPLE
export HPOS
export VCF_FILE
export OUTPUT_FILE

python3 "$SCRIPT_DIR/amelie_vcf_api.py"
