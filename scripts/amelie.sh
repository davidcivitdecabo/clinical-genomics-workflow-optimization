#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage:"
    echo "  amelie.sh <sample> <profile>"
    echo ""
    echo "Available profiles:"
    echo "  gene_list"
    echo "  gene_list_filtered"
    exit 1
fi

SAMPLE=$1
PROFILE=$2

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

source "$ROOT_DIR/config/system.conf"
source "$ROOT_DIR/config/amelie_profiles/${PROFILE}.conf"

if [[ "$PROFILE" == "vcf" ]]; then
    echo "[ERROR] VCF analysis must be executed using amelie_vcf.sh"
    exit 1
fi

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

HPO_FILE="${SAMPLE_DIR}/HPO_terms.txt"
GENE_FILE_PATH="${SAMPLE_DIR}/${GENE_FILE}"

OUTPUT_DIR="${RESULTS_DIR}/amelie/${PROFILE}"

mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="${OUTPUT_DIR}/amelie_${SAMPLE}.json"

echo "[INFO] Starting AMELIE analysis"
echo "[INFO] Sample: ${SAMPLE}"
echo "[INFO] Profile: ${PROFILE}"

if [ ! -f "$HPO_FILE" ]; then
    echo "[ERROR] HPO file not found:"
    echo "$HPO_FILE"
    exit 1
fi

if [ ! -f "$GENE_FILE_PATH" ]; then
    echo "[ERROR] Gene list not found:"
    echo "$GENE_FILE_PATH"
    exit 1
fi

HPOS=$(paste -sd "," "$HPO_FILE")

export SAMPLE
export HPOS
export OUTPUT_FILE
export AMELIE_MODE
export GENE_FILE="$GENE_FILE_PATH"

python3 "$SCRIPT_DIR/amelie_gene_api.py"

echo "[INFO] Finished successfully"
echo "[INFO] Output: ${OUTPUT_FILE}"
