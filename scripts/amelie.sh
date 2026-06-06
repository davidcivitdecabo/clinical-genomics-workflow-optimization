#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
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

PROFILE_FILE="$ROOT_DIR/config/amelie_profiles/${PROFILE}.conf"

if [[ ! -f "$PROFILE_FILE" ]]; then
    echo "[ERROR] Profile not found:"
    echo "        $PROFILE_FILE"
    exit 1
fi

source "$PROFILE_FILE"

if [[ "$PROFILE_NAME" == "vcf" ]]; then
    echo "[ERROR] VCF analysis must be executed using amelie_vcf.sh"
    exit 1
fi

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

if [[ ! -d "$SAMPLE_DIR" ]]; then
    echo "[ERROR] Sample directory not found:"
    echo "        $SAMPLE_DIR"
    exit 1
fi

HPO_FILE="${SAMPLE_DIR}/HPO_terms.txt"
GENE_LIST_FILE="${SAMPLE_DIR}/${GENE_FILE}"

OUTPUT_DIR="${RESULTS_DIR}/amelie/${PROFILE_NAME}"

mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="${OUTPUT_DIR}/amelie_${SAMPLE}_${PROFILE_NAME}.json"

echo "[INFO] Starting AMELIE analysis"
echo "[INFO] Sample: ${SAMPLE}"
echo "[INFO] Profile: ${PROFILE_NAME}"

if [ ! -f "$HPO_FILE" ]; then
    echo "[ERROR] HPO file not found:"
    echo "$HPO_FILE"
    exit 1
fi

if [ ! -f "$GENE_LIST_FILE" ]; then
    echo "[ERROR] Gene list not found:"
    echo "$GENE_LIST_FILE"
    exit 1
fi

HPOS=$(paste -sd "," "$HPO_FILE")

if [[ -z "$HPOS" ]]; then
    echo "[ERROR] Empty HPO file"
    exit 1
fi

export SAMPLE
export HPOS
export OUTPUT_FILE
export AMELIE_MODE
export GENE_LIST_FILE

PYTHON_SCRIPT="${SCRIPT_DIR}/amelie_gene_api.py"

if [[ ! -f "$PYTHON_SCRIPT" ]]; then
    echo "[ERROR] Missing script:"
    echo "        $PYTHON_SCRIPT"
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "[ERROR] python3 not found"
    exit 1
fi

python3 "$PYTHON_SCRIPT"

if [[ ! -s "$OUTPUT_FILE" ]]; then
    echo "[ERROR] AMELIE output file not generated"
    exit 1
fi

echo "[INFO] Finished successfully"
echo "[INFO] Output: ${OUTPUT_FILE}"
