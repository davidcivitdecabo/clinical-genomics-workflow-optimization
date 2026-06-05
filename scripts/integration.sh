#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Usage:"
    echo "  integration.sh <sample> <exomiser_profile> <lirical_profile>"
    exit 1
fi

SAMPLE=$1
EXOMISER_PROFILE=$2
LIRICAL_PROFILE=$3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

source "$ROOT_DIR/config/system.conf"

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

[[ -d "$SAMPLE_DIR" ]] || {
    echo "[ERROR] Sample directory not found:"
    echo "        $SAMPLE_DIR"
    exit 1
}

EXOMISER_RESULTS="${RESULTS_DIR}/exomiser/${EXOMISER_PROFILE}"
LIRICAL_RESULTS="${RESULTS_DIR}/lirical/${LIRICAL_PROFILE}"

INTEGRATION_DIR="${RESULTS_DIR}/integration"

mkdir -p "$INTEGRATION_DIR"

EXOMISER_FILE="${EXOMISER_RESULTS}/${SAMPLE}_${EXOMISER_PROFILE}.variants.tsv"
LIRICAL_FILE="${LIRICAL_RESULTS}/lirical_${SAMPLE}_${LIRICAL_PROFILE}.tsv"

[[ -f "$EXOMISER_FILE" ]] || {
    echo "[ERROR] Missing Exomiser results"
    exit 1
}

[[ -f "$LIRICAL_FILE" ]] || {
    echo "[ERROR] Missing LIRICAL results"
    exit 1
}

OUTPUT_ALL="${INTEGRATION_DIR}/${SAMPLE}_integration.txt"

echo "[INFO] Sample: ${SAMPLE}"
echo "[INFO] Integrating Exomiser and LIRICAL"

echo -e \
"RANK\tChr\tStart\tEnd\tRef\tAlt\tGENE_SYMBOL\tRank_lirical\tDisease_lirical\tVariants_lirical\tP-VALUE\tEXOMISER_GENE_COMBINED_SCORE\tEXOMISER_GENE_PHENO_SCORE\tEXOMISER_GENE_VARIANT_SCORE\tEXOMISER_VARIANT_SCORE\tMOI\tID\tENTREZ_GENE_ID\tRS_ID\tCHANGE_LENGTH\tQUAL\tFILTER\tGENOTYPE\tFUNCTIONAL_CLASS\tHGVS\tEXOMISER_ACMG_CLASSIFICATION\tEXOMISER_ACMG_EVIDENCE\tEXOMISER_ACMG_DISEASE_ID\tEXOMISER_ACMG_DISEASE_NAME\tCLINVAR_VARIATION_ID\tCLINVAR_PRIMARY_INTERPRETATION\tCLINVAR_STAR_RATING\tGENE_CONSTRAINT_LOEUF\tGENE_CONSTRAINT_LOEUF_LOWER\tGENE_CONSTRAINT_LOEUF_UPPER\tMAX_FREQ_SOURCE\tMAX_FREQ\tALL_FREQ\tMAX_PATH_SOURCE\tMAX_PATH\tALL_PATH" \
> "$OUTPUT_ALL"

###############################################
# Merge Lirical position in Exomiser variants #
###############################################

TMP_LIRICAL=$(mktemp)

for ALL in $(cut -f2 "$EXOMISER_FILE" | tail -n +2 | \
    sed 's/_AD//g; s/_AR//g; s/_XR//g; s/_XD//g')
do

    VAR=$(echo "$ALL" | \
        sed 's/-/:/1; s/-//1; s/-/>/1')

    LIR=$(grep -w "$VAR" "$LIRICAL_FILE" | wc -l)

    if [ "$LIR" -gt 0 ]
    then
        grep -w "$VAR" "$LIRICAL_FILE" | \
        cut -f1,2,8 | \
        head -n1 >> "$TMP_LIRICAL"
    else
        echo -e ".\t.\t." >> "$TMP_LIRICAL"
    fi

done

################
# Merged table #
################

TMP_EXOMISER=$(mktemp)
TMP_EXOMISER1=$(mktemp)
TMP_EXOMISER2=$(mktemp)

sed \
's/\t$/\t.\t/g;
 s/\t\t/\t.\t/g;
 s/\t\t/\t.\t/g' \
"$EXOMISER_FILE" \
> "$TMP_EXOMISER"

awk -F"\t" '
{
OFS="\t"
if(NR>1)
print $1,"chr"$15,$16,$17,$18,$19,$3
}
' "$TMP_EXOMISER" > "$TMP_EXOMISER1"

awk -F"\t" '
{
OFS="\t"
if(NR>1)
print $6,$7,$8,$9,$10,$5,$2,$4,$14,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41
}
' "$TMP_EXOMISER" > "$TMP_EXOMISER2"

paste \
"$TMP_EXOMISER1" \
"$TMP_LIRICAL" \
"$TMP_EXOMISER2" \
>> "$OUTPUT_ALL"

rm -f \
"$TMP_EXOMISER1" \
"$TMP_EXOMISER2" \
"$TMP_LIRICAL" \
"$TMP_EXOMISER"

echo "[INFO] Integration completed"
echo "[INFO] Output: ${OUTPUT_ALL}"
