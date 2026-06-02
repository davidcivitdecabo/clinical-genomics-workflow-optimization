#!/usr/bin/env bash

set -euo pipefail

######################
# Load configuration #
######################

SYSTEM_CONFIG=${1:-config/system.conf}
PROFILE_CONFIG=${2}

if [[ ! -f "$SYSTEM_CONFIG" ]]; then
    echo "[ERROR] System config not found: $SYSTEM_CONFIG"
    exit 1
fi

if [[ ! -f "$PROFILE_CONFIG" ]]; then
    echo "[ERROR] Profile config not found: $PROFILE_CONFIG"
    exit 1
fi

source "$SYSTEM_CONFIG"
source "$PROFILE_CONFIG"

################
# Input sample #
################

SAMPLE=$3

if [[ -z "${SAMPLE:-}" ]]; then
    echo "[ERROR] Sample name required"
    exit 1
fi

SAMPLE_DIR="${DATA_DIR}/${SAMPLE}"

echo "----------------------------------------"
echo "Running LIRICAL"
echo "Sample: $SAMPLE"
echo "Profile: $PROFILE_NAME"
echo "Allele frequency cutoff: $AF_THRESHOLD"
echo "----------------------------------------"

##################
# Build HPO list #
##################

HPO_TERMS=$(paste -sd "," "$SAMPLE_DIR/HPO_terms.txt")

#########################
# Generate filtered VCF #
#########################

echo "[INFO] Preparing VCF..."

grep "^#" \
    "$SAMPLE_DIR/${SAMPLE}_filtered_sorted_hg38.vcf" \
    > "$SAMPLE_DIR/${SAMPLE}_filtered_PASS.vcf"

grep -v "^#" \
    "$SAMPLE_DIR/${SAMPLE}_filtered_sorted_hg38.vcf" \
    | awk -F"\t" '
        {
            if($0 ~ /1\/2/)
                print $0"\n"$0
            else
                print $0
        }' \
    > "$SAMPLE_DIR/${SAMPLE}_tmp_variants.txt"

tail -n +2 \
    "$SAMPLE_DIR/${SAMPLE}_gnomad_values_hg38.txt" \
    | paste "$SAMPLE_DIR/${SAMPLE}_tmp_variants.txt" - \
    | cut -f1-10,21 \
    | awk -F"\t" -v af="$AF_THRESHOLD" '$11<=af' \
    | cut -f1-10 \
    > "$SAMPLE_DIR/${SAMPLE}_filtered_variants.txt"

awk -F"\t" '$7=="PASS"' \
    "$SAMPLE_DIR/${SAMPLE}_filtered_variants.txt" \
    >> "$SAMPLE_DIR/${SAMPLE}_filtered_PASS.vcf"

rm \
    "$SAMPLE_DIR/${SAMPLE}_tmp_variants.txt" \
    "$SAMPLE_DIR/${SAMPLE}_filtered_variants.txt"

###############
# Run LIRICAL #
###############

echo "[INFO] Running LIRICAL..."

cd "$LIRICAL_DIR"

java -jar "$LIRICAL_JAR" prioritize \
    --exomiser-hg38 "$LIRICAL_DATABASE" \
    -p "$HPO_TERMS" \
    --vcf "$SAMPLE_DIR/${SAMPLE}_filtered_PASS.vcf" \
    --prefix "lirical_${SAMPLE}_${PROFILE_NAME}" \
    --validation-policy=LENIENT \
    --pathogenicity-threshold=1.0 \
    -o "$LIRICAL_RESULTS_DIR" \
    -f tsv

echo "[INFO] Finished"

echo "[INFO] Output:"
echo "$LIRICAL_RESULTS_DIR/lirical_${SAMPLE}_${PROFILE_NAME}.tsv"
