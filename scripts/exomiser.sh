#!/usr/bin/env bash

###############################################################################
# exomiser.sh
#
# Launches Exomiser using sample-specific HPO terms and a predefined
# analysis template.
#
# Requirements:
#   - Exomiser installed
#   - analysis-exome.yml template
#   - HPO_terms.txt inside sample directory
#
###############################################################################

set -euo pipefail

#################
# Configuration #
#################

SAMPLE="$1"

SAMPLE_DIR="/media/DataPC/DATA/Genomes/${SAMPLE}/"
EXOMISER_DIR="/media/DataPC/Desktop/software/Exomiser/exomiser-cli-14.1.0"

##############
# Validation #
##############

if [[ ! -d "$SAMPLE_DIR" ]]; then
    echo "[ERROR] Sample directory not found: $SAMPLE_DIR"
    exit 1
fi

if [[ ! -f "$SAMPLE_DIR/HPO_terms.txt" ]]; then
    echo "[ERROR] HPO_terms.txt not found"
    exit 1
fi

#####################
# Generate HPO list #
#####################

echo "[INFO] Preparing HPO terms for sample ${SAMPLE}"

HPO_LIST=$(
    cat "$SAMPLE_DIR/HPO_terms.txt" \
    | tr '\n' ',' \
    | sed "s/,/\', \'/g" \
    | sed "s/^/\'/g" \
    | sed 's/$/\n/g' \
    | sed "s/', '$/'/g"
)

#################################################
# Create sample-specific Exomiser configuration #
#################################################

echo "[INFO] Generating Exomiser YAML configuration"

cd "$EXOMISER_DIR"

sed "s/X_Sample/${SAMPLE}/g" ./test/analysis-exome.yml \
    | sed "s/hpoIds: \[\]/hpoIds: \[${HPO_LIST}\]/g" \
    > "./test/analysis-${SAMPLE}-exome.yml"

################
# Run Exomiser #
################

echo "[INFO] Running Exomiser"

java -jar exomiser-cli-14.1.0.jar \
    --analysis "test/analysis-${SAMPLE}-exome.yml" \
    --exomiser.data-directory="$EXOMISER_DIR"

echo "[INFO] Exomiser completed successfully"
