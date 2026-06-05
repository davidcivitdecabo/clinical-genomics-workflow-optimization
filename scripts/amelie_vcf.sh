#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage:"
    echo "  amelie_vcf.sh <sample>"
    exit 1
fi

SAMPLE=$1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

source "$ROOT_DIR/config/system.conf"

PROFILE_FILE="$ROOT_DIR/config/amelie_profiles/vcf.conf"

if [[ ! -f "$PROFILE_FILE" ]]; then
    echo "[ERROR] Profile not found:"
    echo "        $PROFILE_FILE"
    exit 1
fi

source "$PROFILE_FILE"

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

if [[ ! -d "$SAMPLE_DIR" ]]; then
    echo "[ERROR] Sample directory not found:"
    echo "        $SAMPLE_DIR"
    exit 1
fi

HPO_FILE="${SAMPLE_DIR}/HPO_terms.txt"
VCF_FILE="${SAMPLE_DIR}/${VCF_NAME}"

OUTPUT_DIR="${RESULTS_DIR}/amelie_vcf"

mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="${OUTPUT_DIR}/amelie_${SAMPLE}_vcf.json"

echo "[INFO] Starting AMELIE analysis"
echo "[INFO] Sample: ${SAMPLE}"
echo "[INFO] Profile: vcf"
echo "[WARNING] AMELIE VCF mode was benchmarked using hg19 variants."
echo "[WARNING] Ensure ${VCF_FILE} is in hg19 coordinates."

if [ ! -f "$HPO_FILE" ]; then
    echo "[ERROR] HPO file not found:"
    echo "$HPO_FILE"
    exit 1
fi

if [ ! -f "$VCF_FILE" ]; then
    echo "[ERROR] Vcf file not found:"
    echo "$VCF_FILE"
    exit 1
fi

HPOS=$(paste -sd "," "$HPO_FILE")

if [[ -z "$HPOS" ]]; then
    echo "[ERROR] Empty HPO file"
    exit 1
fi

export SAMPLE
export HPOS
export VCF_FILE
export AMELIE_VCF_API
export OUTPUT_FILE

PYTHON_SCRIPT="${SCRIPT_DIR}/amelie_vcf_api.py"

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
