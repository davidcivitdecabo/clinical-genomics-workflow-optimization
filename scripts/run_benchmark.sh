# scripts/run_benchmark.sh
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/../config/system.conf"

echo "======================================="
echo " Clinical Genomics Benchmark Workflow"
echo "======================================="

mkdir -p "$RESULTS_DIR"

#########################################################
# Exomiser profiles
#########################################################

EXOMISER_PROFILES=(
q200_af001
q200_af002
q200_af005

q200_mvp_af001
q200_mvp_af002
q200_mvp_af005

q100_af001
q100_af002
q100_af005

q100_mvp_af001
q100_mvp_af002
q100_mvp_af005
)

#########################################################
# LIRICAL profiles
#########################################################

LIRICAL_PROFILES=(
af001
af002
af005
no_filter
)

#########################################################
# AMELIE profiles
#########################################################

AMELIE_PROFILES=(
gene_list
gene_list_filtered
)

#########################################################
# Sample loop
#########################################################

for SAMPLE_DIR in "$SAMPLES_DIR"/*
do

    [ -d "$SAMPLE_DIR" ] || continue

    SAMPLE=$(basename "$SAMPLE_DIR")

    echo ""
    echo "======================================="
    echo "Processing sample: $SAMPLE"
    echo "======================================="

    #####################################################
    # Exomiser
    #####################################################

    for PROFILE in "${EXOMISER_PROFILES[@]}"
    do

        echo ""
        echo "[EXOMISER] $PROFILE"

        bash "$SCRIPT_DIR/exomiser.sh" \
            "${EXOMISER_PROFILE_DIR}/${PROFILE}.conf" \
            "$SAMPLE"

    done

    #####################################################
    # LIRICAL
    #####################################################

    for PROFILE in "${LIRICAL_PROFILES[@]}"
    do

        echo ""
        echo "[LIRICAL] $PROFILE"

        bash "$SCRIPT_DIR/lirical.sh" \
            "${LIRICAL_PROFILE_DIR}/${PROFILE}.conf" \
            "$SAMPLE"

    done

    #####################################################
    # AMELIE
    #####################################################

    for PROFILE in "${AMELIE_PROFILES[@]}"
    do

        echo ""
        echo "[AMELIE] $PROFILE"

        bash "$SCRIPT_DIR/amelie.sh" \
            "$SAMPLE" \
            "$PROFILE"

    done

done

echo ""
echo "======================================="
echo "Running Exomiser + LIRICAL integration"
echo "======================================="

for SAMPLE_DIR in "$SAMPLES_DIR"/*
do

    [ -d "$SAMPLE_DIR" ] || continue

    SAMPLE=$(basename "$SAMPLE_DIR")

    for EXOMISER_PROFILE in "${EXOMISER_PROFILES[@]}"
    do

        for LIRICAL_PROFILE in "${LIRICAL_PROFILES[@]}"
        do

            echo ""
            echo "[INTEGRATION]"
            echo "$SAMPLE"
            echo "$EXOMISER_PROFILE"
            echo "$LIRICAL_PROFILE"

            bash "$SCRIPT_DIR/integration.sh" \
                "$SAMPLE" \
                "$EXOMISER_PROFILE" \
                "$LIRICAL_PROFILE"
                
        done

    done

done

echo ""
echo "======================================="
echo "Benchmark completed"
echo "======================================="
echo ""
echo "Results generated in:"
echo ""
echo "$RESULTS_DIR"
echo ""
