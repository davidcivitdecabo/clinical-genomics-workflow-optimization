#!/bin/bash

set -euo pipefail

#############################################
# run_lirical.sh
#
# Execute LIRICAL prioritization for one sample
#############################################

sample=$1
sample_dir=$2
af_filter=$3
pathogenicity_threshold=$4
validation_policy=$5

source config/config.sh

echo "======================================="
echo "Running LIRICAL"
echo "Sample: $sample"
echo "AF filter: $af_filter"
echo "Pathogenicity threshold: $pathogenicity_threshold"
echo "Validation policy: $validation_policy"
echo "======================================="

cd "$sample_dir"

#############################################
# Generate filtered VCF
#############################################

grep "^#" \
    "${sample}_filtered_sorted_hg38.vcf" \
    > "${sample}_filtered_PASS${af_filter}_variants_hg38.vcf"

grep -v "^#" \
    "${sample}_filtered_sorted_hg38.vcf" \
    | awk -F"\t" '{
        OFS="\t"
        if($0 ~ /1\/2/)
            printf $0"\n"$0"\n"
        else
            printf $0"\n"
    }' \
    > "${sample}_inter.txt"

tail -n +2 "${sample}_gnomad_values_hg38.txt" \
    | paste "${sample}_inter.txt" - \
    | cut -f1-10,21 \
    | awk -F"\t" -v af="$af_filter" '$11<=af' \
    | cut -f1-10 \
    > "${sample}_filtered_${af_filter}_variants_hg38.txt"

awk -F"\t" '$7=="PASS"' \
    "${sample}_filtered_${af_filter}_variants_hg38.txt" \
    >> "${sample}_filtered_PASS${af_filter}_variants_hg38.vcf"

#############################################
# Read HPO terms
#############################################

hpo_terms=$(tr '\n' ',' < "$sample_dir/HPO_terms.txt" | sed 's/,$//')

#############################################
# Run LIRICAL
#############################################

cd "$LIRICAL_DIR"

java -jar "$LIRICAL_JAR" prioritize \
    --exomiser-hg38 "$LIRICAL_DATABASE" \
    -p "$hpo_terms" \
    --vcf "$sample_dir/${sample}_filtered_PASS${af_filter}_variants_hg38.vcf" \
    --prefix "lirical_${sample}_${validation_policy}_${af_filter}" \
    --validation-policy="$validation_policy" \
    --pathogenicity-threshold="$pathogenicity_threshold" \
    -o "$LIRICAL_RESULTS_DIR" \
    -f tsv

echo "LIRICAL completed successfully"
