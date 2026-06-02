#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 3 ]; then
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

EXOMISER_RESULTS="${RESULTS_DIR}/exomiser/${EXOMISER_PROFILE}"
LIRICAL_RESULTS="${RESULTS_DIR}/lirical/${LIRICAL_PROFILE}"

INTEGRATION_DIR="${RESULTS_DIR}/integration"

mkdir -p "$INTEGRATION_DIR"

EXOMISER_FILE="${EXOMISER_RESULTS}/${SAMPLE}.variants.tsv"
LIRICAL_FILE="${LIRICAL_RESULTS}/${SAMPLE}.tsv"

OUTPUT_ALL="${INTEGRATION_DIR}/${SAMPLE}_exomiser+lirical.all.txt"

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

sed -i \
's/\t$/\t.\t/g;
 s/\t\t/\t.\t/g;
 s/\t\t/\t.\t/g' \
"$EXOMISER_FILE"

awk -F"\t" '
{
OFS="\t"
if(NR>1)
print $1,"chr"$15,$16,$17,$18,$19,$3
}
' "$EXOMISER_FILE" > exomiser1.txt

awk -F"\t" '
{
OFS="\t"
if(NR>1)
print $6,$7,$8,$9,$10,$5,$2,$4,$14,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41
}
' "$EXOMISER_FILE" > exomiser2.txt

paste \
exomiser1.txt \
"$TMP_LIRICAL" \
exomiser2.txt \
>> "$OUTPUT_ALL"

tail +2 $EXOMISER_DIR/results/"$sample"_exomiser100_05.variants.tsv | head -n10 | cut -f2 | sed 's/_AD//g; s/_AR//g; s/_XR//g; s/_XD//g' > "$sample"_exomiser+lirical_10+5.txt
#Las 5 pirmeras de Lirical
for alpo in `grep -v "!" $LIRICAL_DIR/results/lirical_"$sample"_lenient_05pat1.tsv | tail +2 | head -n5 | cut -f8 | sed 's/; /\n/g; s/ /_/g'`; do
    for var in `echo $alpo | sed 's/;/\n/g; s/ /_/g'`; do
        pat=${var#*pathogenicity:}
        echo -e "$var\t${pat%%_*}" | awk -F"\t" '$2>=0.8' | cut -d"_" -f1 >> "$sample"_exomiser+lirical_10+5.txt
    done
done
#Juntar la información de las variantes filtradas
for allo in `cat "$sample"_exomiser+lirical_10+5.txt | sed 's/-/:/1; s/-//1; s/-/>/g' | sort | uniq`; do
    ex=`grep -Eo '[[:alpha:]]+|[0-9]+' <<< "$allo" | tr '\n' '-' | sed 's/-$/\n/g'`
    ex1=`awk -F"\t" '$11==1' $EXOMISER_DIR/results/"$sample"_exomiser100_05.variants.tsv | grep "$ex" | head -n1 | tr '\t' '#' | sed 's/#$//g'`
    posex1=`awk -F"\t" '$11==1' $EXOMISER_DIR/results/"$sample"_exomiser100_05.variants.tsv | grep -n "$ex" | head -n1 | tr ':' '\t' | cut -f1`
    lir1=`awk -v allo=$allo -F"\t" '{OFS="\t"}{if($8 ~ allo) print $1, $2, $8}' $LIRICAL_DIR/results/lirical_"$sample"_lenient_05pat1.tsv | head -n1 | tr '\t' '#'`
    if [[ -n $ex1 && -n $lir1 ]]; then
        echo -e "$posex1\t$ex1\t$lir1\t$ex" | tr '#' '\t' | awk -F"\t" '{OFS="\t"}{print $1,"chr"$16,$17,$18,$19,$20,$4,$43,$44,$45,$7,$8,$9,$10,$11,$6,$3,$5,$15,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$46}' >> "$sample"_exomiser+lirical_info_10+5.txt
    elif [[ -n $ex1 && -z $lir1 ]]; then
        echo -e "$posex1\t$ex1\t.\t.\t.\t$ex" | tr '#' '\t' | awk -F"\t" '{OFS="\t"}{print $1,"chr"$16,$17,$18,$19,$20,$4,$43,$44,$45,$7,$8,$9,$10,$11,$6,$3,$5,$15,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$46}' >> "$sample"_exomiser+lirical_info_10+5.txt
    elif [[ -z $ex1 && -n $lir1 ]]; then
        echo -e "$lir1\t$ex" | tr '#' '\t' | awk -F"\t" '{OFS="\t"}{print ".",".",".",".",".",".",".",$1,$2,$3,".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",$4}' >> "$sample"_exomiser+lirical_info_10+5.txt
    fi
done

#Ordenar
echo -e "RANK\tChr\tStart\tEnd\tRef\tAlt\tGENE_SYMBOL\tRank_lirical\tDisease_lirical\tVariants_lirical\tP-VALUE\tEXOMISER_GENE_COMBINED_SCORE\tEXOMISER_GENE_PHENO_SCORE\tEXOMISER_GENE_VARIANT_SCORE\tEXOMISER_VARIANT_SCORE\tMOI\tID\tENTREZ_GENE_ID\tRS_ID\tCHANGE_LENGTH\tQUAL\tFILTER\tGENOTYPE\tFUNCTIONAL_CLASS\tHGVS\tEXOMISER_ACMG_CLASSIFICATION\tEXOMISER_ACMG_EVIDENCE\tEXOMISER_ACMG_DISEASE_ID\tEXOMISER_ACMG_DISEASE_NAME\tCLINVAR_VARIATION_ID\tCLINVAR_PRIMARY_INTERPRETATION\tCLINVAR_STAR_RATING\tGENE_CONSTRAINT_LOEUF\tGENE_CONSTRAINT_LOEUF_LOWER\tGENE_CONSTRAINT_LOEUF_UPPER\tMAX_FREQ_SOURCE\tMAX_FREQ\tALL_FREQ\tMAX_PATH_SOURCE\tMAX_PATH\tALL_PATH" > "$sample"_exomiser+lirical_filtrado.txt
awk -F"\t" '{OFS="\t"}{if($1!="." && $1<=10) print $0}' "$sample"_exomiser+lirical_info_10+5.txt | sort -nk1 | cut -f-41 >> "$sample"_exomiser+lirical_filtrado.txt

awk -F"\t" '{OFS="\t"}{if($1=="." || ($1!="." && $1>10)) print $42, $0}' "$sample"_exomiser+lirical_info_10+5.txt | sort -nk9 | sed 's/-/\t/1; s/-/\t/1; s/-/\t/1' | awk -F"\t" '{OFS="\t"}{if($5!=".") print $5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46; else print ".","chr"$1,$2,$2+length($3)-1,$3,$4,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46}' | awk -F"\t" '{OFS="\t"}{if($7 ~ /^[0-9]+$/) print $1,$2,$3,$4,$5,".",$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41; else print $0}' > lirical_sorted.txt
cut -f1-6 lirical_sorted.txt > lir_1.txt
cut -f8- lirical_sorted.txt > lir_2.txt
awk -F"\t" '{OFS="\t"}{if($1=="." || ($1!="." && $1>10)) print $42, $0}' "$sample"_exomiser+lirical_info_10+5.txt | sort -nk9 | sed 's/-/\t/1; s/-/\t/1; s/-/\t/1' | awk -F"\t" '{OFS="\t"}{if($5!=".") print $6,$7,$8; else print "chr"$1,$2,$2+length($3)-1}' | tr '\t' '_' > lirical_coord_genes.txt


for all in `cat lirical_coord_genes.txt`; do
    crom=`echo $all | cut -d"_" -f1`
    start=`echo $all | cut -d"_" -f2`
    end=`echo $all | cut -d"_" -f3`
    pol=`awk -v crom=$crom -v start=$start -v end=$end -F"\t" '{OFS="\t"}{if($1==crom && $2<=start && $3>=end) print $4}' $refGene_DIR/refGene_hg38_chrOK.txt | sort | uniq | tr '\n' ';' | sed 's/;$/\n/g' | wc -l`
    if [ $pol -gt 0 ]; then
        awk -v crom=$crom -v start=$start -v end=$end -F"\t" '{OFS="\t"}{if($1==crom && $2<=start && $3>=end) print $4}' $refGene_DIR/refGene_hg38_chrOK.txt | sort | uniq | tr '\n' ';' | sed 's/;$/\n/g' >> lirical_genes.txt
    else
        echo "." >> lirical_genes.txt
    fi
done
paste lir_1.txt lirical_genes.txt lir_2.txt | cut -f1-41 >> "$sample"_exomiser+lirical_filtrado.txt

rm -f \
exomiser1.txt \
exomiser2.txt \
"$TMP_LIRICAL"
