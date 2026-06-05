#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage:"
    echo "  lirical.sh <profile.conf> <sample>"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROFILE_CONFIG=${1}

source "${SCRIPT_DIR}/../config/system.conf"
source "${LIRICAL_PROFILE_DIR}/$(basename "$PROFILE_CONFIG")"

################
# Input sample #
################

SAMPLE=$2

if [[ -z "${SAMPLE:-}" ]]; then
    echo "[ERROR] Sample name required"
    exit 1
fi

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

echo "----------------------------------------"
echo "Running LIRICAL"
echo "Sample: $SAMPLE"
echo "Profile: $PROFILE_NAME"
echo "Allele frequency cutoff: $AF_THRESHOLD"
echo "----------------------------------------"

##################
# Build HPO list #
##################

HPO_FILE="${SAMPLE_DIR}/HPO_terms.txt"

[[ -f "$HPO_FILE" ]] || {
    echo "[ERROR] Missing HPO terms file"
    exit 1
}

HPO_TERMS=$(paste -sd "," "$HPO_FILE")

#########################
# Generate filtered VCF #
#########################

echo "[INFO] Preparing VCF..."

INPUT_VCF="${SAMPLE_DIR}/${SAMPLE}_filtered_sorted_hg38.vcf"
GNOMAD_FILE="${SAMPLE_DIR}/${SAMPLE}_gnomad_values_hg38.txt"
FILTERED_VCF="${SAMPLE_DIR}/${SAMPLE}_${PROFILE_NAME}_filtered_PASS.vcf"
TMP_VARIANTS="${SAMPLE_DIR}/${SAMPLE}_tmp_variants.txt"
FILTERED_VARIANTS="${SAMPLE_DIR}/${SAMPLE}_${PROFILE_NAME}_filtered_variants.txt"

[[ -f "$INPUT_VCF" ]] || {
    echo "[ERROR] Missing input VCF"
    exit 1
}

[[ -f "$GNOMAD_FILE" ]] || {
    echo "[ERROR] Missing gnomAD annotation file"
    exit 1
}

grep "^#" \
    "$INPUT_VCF" \
    > "$FILTERED_VCF"

grep -v "^#" \
    "$INPUT_VCF" \
    | awk -F"\t" '
        {
            if($0 ~ /1\/2/)
                print $0"\n"$0
            else
                print $0
        }' \
    > "$TMP_VARIANTS"

if [[ "$AF_THRESHOLD" == "none" ]]; then

    tail -n +2 "$GNOMAD_FILE" \
        | paste "$TMP_VARIANTS" - \
        | cut -f1-10 \
        > "$FILTERED_VARIANTS"

else

    tail -n +2 "$GNOMAD_FILE" \
        | paste "$TMP_VARIANTS" - \
        | cut -f1-10,21 \
        | awk -F"\t" -v af="$AF_THRESHOLD" '$11<=af' \
        | cut -f1-10 \
        > "$FILTERED_VARIANTS"

fi

awk -F"\t" '$7=="PASS"' \
    "$FILTERED_VARIANTS" \
    >> "$FILTERED_VCF"

rm \
    "$TMP_VARIANTS" \
    "$FILTERED_VARIANTS"

###############
# Run LIRICAL #
###############

echo "[INFO] Running LIRICAL..."

LIRICAL_OUTPUT_DIR="${RESULTS_DIR}/lirical"

mkdir -p "${LIRICAL_OUTPUT_DIR}"

cd "$LIRICAL_DIR"

[[ -f "${LIRICAL_DIR}/${LIRICAL_JAR}" ]] || {
    echo "[ERROR] LIRICAL jar not found"
    exit 1
}

${JAVA_BIN} -jar "${LIRICAL_DIR}/${LIRICAL_JAR}" prioritize \
    --exomiser-hg38 "$EXOMISER_DB" \
    -p "$HPO_TERMS" \
    --vcf "$FILTERED_VCF" \
    --prefix "lirical_${SAMPLE}_${PROFILE_NAME}" \
    --validation-policy="${VALIDATION_POLICY}" \
    --pathogenicity-threshold="${PATHOGENICITY_THRESHOLD}" \
    -o "${LIRICAL_OUTPUT_DIR}" \
    -f tsv
    
echo "[INFO] Finished"

echo "[INFO] Output:"
echo "$LIRICAL_RESULTS_DIR/lirical_${SAMPLE}_${PROFILE_NAME}.tsv"
