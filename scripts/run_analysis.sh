#!/usr/bin/env bash

###############################################################################
# Clinical Genomics Workflow Optimization
#
# run_analysis.sh
#
# Execute a selected analysis configuration on one or more samples.
#
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/../config/system.conf"

###############################################################################
# HELP
###############################################################################

usage() {

cat << EOF

Usage:

run_analysis.sh \
    --samples sample_list.txt \
    --exomiser exomiser_q200_af005.conf \
    --lirical lirical_af005.conf \
    [--amelie gene_list.conf]

Required:

  --samples     File containing sample IDs

  --exomiser    Exomiser profile

  --lirical     LIRICAL profile

Optional:

  --amelie      AMELIE profile

Examples:

run_analysis.sh \
    --samples samples.txt \
    --exomiser exomiser_q200_af005.conf \
    --lirical lirical_af005.conf

run_analysis.sh \
    --samples samples.txt \
    --exomiser exomiser_q100_mvp_af005.conf \
    --lirical lirical_af005.conf \
    --amelie gene_list.conf

EOF

exit 1

}

###############################################################################
# ARGUMENTS
###############################################################################

[[ $# -eq 0 ]] && usage

AMELIE_PROFILE=""

while [[ $# -gt 0 ]]
do
    case "$1" in

        --samples)

            SAMPLE_LIST="$2"
            shift 2
            ;;

        --exomiser)

            EXOMISER_PROFILE="$2"
            shift 2
            ;;

        --lirical)

            LIRICAL_PROFILE="$2"
            shift 2
            ;;

        --amelie)

            AMELIE_PROFILE="$2"
            shift 2
            ;;

        *)

            echo "Unknown option: $1"
            usage
            ;;
    esac
done

###############################################################################
# VALIDATION
###############################################################################

[[ ! -f "$SAMPLE_LIST" ]] && \
    { echo "Sample list not found"; exit 1; }

[[ ! -f "${REPO_DIR}/config/exomiser_profiles/${EXOMISER_PROFILE}" ]] && \
    { echo "Exomiser profile not found"; exit 1; }

[[ ! -f "${REPO_DIR}/config/lirical_profiles/${LIRICAL_PROFILE}" ]] && \
    { echo "LIRICAL profile not found"; exit 1; }

if [[ -n "$AMELIE_PROFILE" ]]
then

    [[ ! -f "${REPO_DIR}/config/amelie_profiles/${AMELIE_PROFILE}" ]] && \
        { echo "AMELIE profile not found"; exit 1; }

fi

###############################################################################
# OUTPUT DIRECTORY
###############################################################################

RUN_NAME=$(date +"%Y%m%d_%H%M%S")

RUN_DIR="${ANALYSIS_DIR}/${RUN_NAME}"

mkdir -p "${RUN_DIR}"

###############################################################################
# CONFIGURATION SUMMARY
###############################################################################

echo
echo "======================================="
echo "Clinical Genomics Workflow"
echo "======================================="
echo

echo "Samples:"
echo "$SAMPLE_LIST"
echo

echo "Exomiser profile:"
echo "$EXOMISER_PROFILE"
echo

echo "LIRICAL profile:"
echo "$LIRICAL_PROFILE"
echo

if [[ -n "$AMELIE_PROFILE" ]]
then

echo "AMELIE profile:"
echo "$AMELIE_PROFILE"
echo

fi

###############################################################################
# SAMPLE LOOP
###############################################################################

while read -r SAMPLE
do

    echo
    echo "---------------------------------------"
    echo "Processing ${SAMPLE}"
    echo "---------------------------------------"

    SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

    [[ ! -d "$SAMPLE_DIR" ]] && \
    {
        echo "Sample directory not found"
        continue
    }

    ###############################################################
    # EXOMISER
    ###############################################################

    bash "${SCRIPT_DIR}/exomiser.sh" \
        "$SAMPLE" \
        "${REPO_DIR}/config/exomiser_profiles/${EXOMISER_PROFILE}"

    ###############################################################
    # LIRICAL
    ###############################################################

    bash "${SCRIPT_DIR}/lirical.sh" \
        "$SAMPLE" \
        "${REPO_DIR}/config/lirical_profiles/${LIRICAL_PROFILE}"

    ###############################################################
    # AMELIE
    ###############################################################

    if [[ -n "$AMELIE_PROFILE" ]]
    then

        bash "${SCRIPT_DIR}/amelie.sh" \
            "$SAMPLE" \
            "${REPO_DIR}/config/amelie_profiles/${AMELIE_PROFILE}"

    fi

    ###############################################################
    # INTEGRATION
    ###############################################################

    bash "${SCRIPT_DIR}/integration.sh" \
        "$SAMPLE"

done < "$SAMPLE_LIST"

###############################################################################
# FINISHED
###############################################################################

echo
echo "======================================="
echo "Analysis completed"
echo "======================================="
echo

echo "Results:"
echo "${RUN_DIR}"
echo
