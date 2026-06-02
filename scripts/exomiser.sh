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

PROFILE=$1
SAMPLE=$2
SAMPLE_DIR=$3

source config/system.conf
source "$PROFILE"

echo "[INFO] Running Exomiser for sample: $SAMPLE"

##################
# Build HPO list #
##################

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

sed "s/X_Sample/$SAMPLE/g" "$EXOMISER_TEMPLATE" \
    | sed "s/hpoIds: \[\]/hpoIds: \[$HPO_LIST\]/g" \
    > "test/analysis-${SAMPLE}.yml"

################
# Run Exomiser #
################

echo "[INFO] Running Exomiser"

java -jar "$EXOMISER_JAR" \
    --analysis "test/analysis-${SAMPLE}.yml" \
    --exomiser.data-directory="$EXOMISER_DATA"

echo "[INFO] Exomiser finished for $SAMPLE"


