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

OUTPUT_ALL="${INTEGRATION_DIR}/${SAMPLE}_${EXOMISER_PROFILE}_${LIRICAL_PROFILE}_integration.txt"

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

MERGE_VAR=$(mktemp)
MERGE_INFO=$(mktemp)
FILTERED_FILE="${INTEGRATION_DIR}/${SAMPLE}_${EXOMISER_PROFILE}_${LIRICAL_PROFILE}_filtered_prioritation.txt"
LIR_SORT=$(mktemp)
LIR_1to6=$(mktemp)
LIR_8=$(mktemp)
LIR_COORD=$(mktemp)
LIR_GENES=$(mktemp)
# Top 10 Exomiser variants
tail -n +2 "$EXOMISER_FILE" | head -n10 | cut -f2 | sed 's/_AD//g; s/_AR//g; s/_XR//g; s/_XD//g' > "$MERGE_VAR"
# Top 5 Lirical variants
for alpo in `grep -v "!" "$LIRICAL_FILE" | tail -n +2 | head -n5 | cut -f8 | sed 's/; /\n/g; s/ /_/g'`; do
    for var in `echo $alpo | sed 's/;/\n/g; s/ /_/g'`; do
        pat=${var#*pathogenicity:}
        echo -e "$var\t${pat%%_*}" | awk -F"\t" '$2>=0.8' | cut -d"_" -f1 >> "$MERGE_VAR"
    done
done
# Combine the information from the filtered variants
for allo in `cat "$MERGE_VAR" | sed 's/-/:/1; s/-//1; s/-/>/g' | sort | uniq`; do
    ex=`grep -Eo '[[:alpha:]]+|[0-9]+' <<< "$allo" | tr '\n' '-' | sed 's/-$/\n/g'`
    ex1=`awk -F"\t" '$11==1' "$EXOMISER_FILE" | grep "$ex" | head -n1 | tr '\t' '#' | sed 's/#$//g'`
    posex1=`awk -F"\t" '$11==1' "$EXOMISER_FILE" | grep -n "$ex" | head -n1 | tr ':' '\t' | cut -f1`
    lir1=`awk -v allo=$allo -F"\t" '{OFS="\t"}{if($8 ~ allo) print $1, $2, $8}' "$LIRICAL_FILE" | head -n1 | tr '\t' '#'`
    if [[ -n $ex1 && -n $lir1 ]]; then
        echo -e "$posex1\t$ex1\t$lir1\t$ex" | tr '#' '\t' | awk -F"\t" '{OFS="\t"}{print $1,"chr"$16,$17,$18,$19,$20,$4,$43,$44,$45,$7,$8,$9,$10,$11,$6,$3,$5,$15,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$46}' >> "$MERGE_INFO"
    elif [[ -n $ex1 && -z $lir1 ]]; then
        echo -e "$posex1\t$ex1\t.\t.\t.\t$ex" | tr '#' '\t' | awk -F"\t" '{OFS="\t"}{print $1,"chr"$16,$17,$18,$19,$20,$4,$43,$44,$45,$7,$8,$9,$10,$11,$6,$3,$5,$15,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$46}' >> "$MERGE_INFO"
    elif [[ -z $ex1 && -n $lir1 ]]; then
        echo -e "$lir1\t$ex" | tr '#' '\t' | awk -F"\t" '{OFS="\t"}{print ".",".",".",".",".",".",".",$1,$2,$3,".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",$4}' >> "$MERGE_INFO"
    fi
done

# Order
echo -e "RANK\tChr\tStart\tEnd\tRef\tAlt\tGENE_SYMBOL\tRank_lirical\tDisease_lirical\tVariants_lirical\tP-VALUE\tEXOMISER_GENE_COMBINED_SCORE\tEXOMISER_GENE_PHENO_SCORE\tEXOMISER_GENE_VARIANT_SCORE\tEXOMISER_VARIANT_SCORE\tMOI\tID\tENTREZ_GENE_ID\tRS_ID\tCHANGE_LENGTH\tQUAL\tFILTER\tGENOTYPE\tFUNCTIONAL_CLASS\tHGVS\tEXOMISER_ACMG_CLASSIFICATION\tEXOMISER_ACMG_EVIDENCE\tEXOMISER_ACMG_DISEASE_ID\tEXOMISER_ACMG_DISEASE_NAME\tCLINVAR_VARIATION_ID\tCLINVAR_PRIMARY_INTERPRETATION\tCLINVAR_STAR_RATING\tGENE_CONSTRAINT_LOEUF\tGENE_CONSTRAINT_LOEUF_LOWER\tGENE_CONSTRAINT_LOEUF_UPPER\tMAX_FREQ_SOURCE\tMAX_FREQ\tALL_FREQ\tMAX_PATH_SOURCE\tMAX_PATH\tALL_PATH" > "$FILTERED_FILE"
awk -F"\t" '{OFS="\t"}{if($1!="." && $1<=10) print $0}' "$MERGE_INFO" | sort -nk1 | cut -f-41 >> "$FILTERED_FILE"

awk -F"\t" '{OFS="\t"}{if($1=="." || ($1!="." && $1>10)) print $42, $0}' "$MERGE_INFO" | sort -nk9 | sed 's/-/\t/1; s/-/\t/1; s/-/\t/1' | awk -F"\t" '{OFS="\t"}{if($5!=".") print $5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46; else print ".","chr"$1,$2,$2+length($3)-1,$3,$4,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46}' | awk -F"\t" '{OFS="\t"}{if($7 ~ /^[0-9]+$/) print $1,$2,$3,$4,$5,".",$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41; else print $0}' > "$LIR_SORT"
cut -f1-6 "$LIR_SORT" > "$LIR_1to6"
cut -f8- "$LIR_SORT" > "$LIR_8"
awk -F"\t" '{OFS="\t"}{if($1=="." || ($1!="." && $1>10)) print $42, $0}' "$MERGE_INFO" | sort -nk9 | sed 's/-/\t/1; s/-/\t/1; s/-/\t/1' | awk -F"\t" '{OFS="\t"}{if($5!=".") print $6,$7,$8; else print "chr"$1,$2,$2+length($3)-1}' | tr '\t' '_' > "$LIR_COORD"

[[ -f "$REFGENE_FILE" ]] || {
    echo "[ERROR] Missing refGene annotation file"
    exit 1
}

while read -r all; do
    crom=`echo $all | cut -d"_" -f1`
    start=`echo $all | cut -d"_" -f2`
    end=`echo $all | cut -d"_" -f3`
    pol=`awk -v crom=$crom -v start=$start -v end=$end -F"\t" '{OFS="\t"}{if($1==crom && $2<=start && $3>=end) print $4}' "$REFGENE_FILE" | sort | uniq | tr '\n' ';' | sed 's/;$/\n/g' | wc -l`
    if [ $pol -gt 0 ]; then
        awk -v crom=$crom -v start=$start -v end=$end -F"\t" '{OFS="\t"}{if($1==crom && $2<=start && $3>=end) print $4}' "$REFGENE_FILE" | sort | uniq | tr '\n' ';' | sed 's/;$/\n/g' >> "$LIR_GENES"
    else
        echo "." >> "$LIR_GENES"
    fi
done < "$LIR_COORD"

paste "$LIR_1to6" "$LIR_GENES" "$LIR_8" | cut -f1-41 >> "$FILTERED_FILE"

rm -f "$MERGE_VAR" \
"$MERGE_INFO" \
"$LIR_SORT" \
"$LIR_1to6" \
"$LIR_8" \
"$LIR_COORD" \
"$LIR_GENES" \
"$TMP_EXOMISER1" \
"$TMP_EXOMISER2" \
"$TMP_LIRICAL" \
"$TMP_EXOMISER"

echo "[INFO] Integration completed"
echo "[INFO] Output: ${OUTPUT_ALL}"
