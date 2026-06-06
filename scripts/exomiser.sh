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

if [[ $# -ne 2 ]]; then
    echo "Usage:"
    echo "  exomiser.sh <profile.conf> <sample>"
    exit 1
fi

PROFILE=$1
SAMPLE=$2

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/../config/system.conf"
source "${EXOMISER_PROFILE_DIR}/$(basename "$PROFILE")"

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

echo "[INFO] Running Exomiser"
echo "[INFO] Sample: ${SAMPLE}"
echo "[INFO] Profile: ${PROFILE_NAME}"

##################################
# Build HPO list
##################################

if [[ ! -f "${SAMPLE_DIR}/HPO_terms.txt" ]]; then
    echo "[ERROR] Missing HPO_terms.txt for sample ${SAMPLE}"
    exit 1
fi

HPO_LIST=$(
    tr '\n' ',' < "${SAMPLE_DIR}/HPO_terms.txt" \
    | sed "s/,/\', \'/g" \
    | sed "s/^/\'/g" \
    | sed "s/', '$/'/g"
)

##################################
# Sample VCF
##################################

VCF_FILE="${SAMPLE_DIR}/${SAMPLE}.vcf"

if [[ ! -f "${VCF_FILE}" ]]; then
    echo "[ERROR] Missing VCF file:"
    echo "        ${VCF_FILE}"
    exit 1
fi

##################################
# MVP configuration
##################################

if [[ "${USE_MVP}" == "true" ]]; then

    PATHOGENICITY_SOURCES="REVEL, MVP, ALPHA_MISSENSE, SPLICE_AI"

else

    PATHOGENICITY_SOURCES="REVEL, ALPHA_MISSENSE, SPLICE_AI"

fi

##################################
# Generate YAML
##################################

mkdir -p "${TMP_DIR}"

TMP_YAML="${TMP_DIR}/${SAMPLE}_${PROFILE_NAME}.yml"

sed \
    -e "s|vcf: examples/sampleX.vcf|vcf: ${VCF_FILE}|g" \
    -e "s|hpoIds: .*|hpoIds: [${HPO_LIST}]|g" \
    -e "s|minQuality: 200.0|minQuality: ${QUALITY_THRESHOLD}.0|g" \
    -e "s|maxFrequency: 0.05|maxFrequency: ${ALLELE_FREQUENCY}|g" \
    -e "s|pathogenicitySources: \[ REVEL, MVP, ALPHA_MISSENSE, SPLICE_AI \]|pathogenicitySources: [ ${PATHOGENICITY_SOURCES} ]|g" \
    -e "s|outputFileName: SampleX_q100_af005|outputFileName: ${SAMPLE}_${PROFILE_NAME}|g" \
    "${EXOMISER_TEMPLATE}" \
    > "${TMP_YAML}"

##################################
# Run Exomiser
##################################

${JAVA_BIN} \
    -jar "${EXOMISER_DIR}/${EXOMISER_JAR}" \
    --analysis "${TMP_YAML}" \
    --exomiser.data-directory "${EXOMISER_DATA_DIR}"

echo "[INFO] Finished ${SAMPLE}"
