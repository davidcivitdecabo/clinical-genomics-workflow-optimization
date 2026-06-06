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
    --exomiser q200_af005 \
    --lirical af005 \
    [--amelie gene_list]

Required:

  --samples     File containing sample IDs

  --exomiser    Exomiser profile

  --lirical     LIRICAL profile

Optional:

  --amelie      AMELIE profile

Examples:

run_analysis.sh \
    --samples samples.txt \
    --exomiser q200_af005 \
    --lirical af005

run_analysis.sh \
    --samples samples.txt \
    --exomiser q100_mvp_af005 \
    --lirical af005 \
    --amelie gene_list

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
            [[ $# -ge 2 ]] || {
                echo "[ERROR] Missing value for --samples"
                exit 1
            }
            SAMPLE_LIST="$2"
            shift 2
            ;;

        --exomiser)
            [[ $# -ge 2 ]] || {
                echo "[ERROR] Missing value for --exomiser"
                exit 1
            }
            EXOMISER_PROFILE="$2"
            shift 2
            ;;

        --lirical)
            [[ $# -ge 2 ]] || {
                echo "[ERROR] Missing value for --lirical"
                exit 1
            }
            LIRICAL_PROFILE="$2"
            shift 2
            ;;

        --amelie)
            [[ $# -ge 2 ]] || {
                echo "[ERROR] Missing value for --amelie"
                exit 1
            }
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

[[ -n "${SAMPLE_LIST:-}" ]] || {
    echo "[ERROR] Missing --samples"
    exit 1
}

[[ -f "$SAMPLE_LIST" ]] || {
    echo "[ERROR] Sample list not found: $SAMPLE_LIST"
    exit 1
}

[[ -n "${EXOMISER_PROFILE:-}" ]] || {
    echo "[ERROR] Missing --exomiser"
    exit 1
}

[[ -f "${EXOMISER_PROFILE_DIR}/${EXOMISER_PROFILE}.conf" ]] || {
    echo "[ERROR] Exomiser profile not found: $EXOMISER_PROFILE"
    exit 1
}

[[ -n "${LIRICAL_PROFILE:-}" ]] || {
    echo "[ERROR] Missing --lirical"
    exit 1
}

[[ -f "${LIRICAL_PROFILE_DIR}/${LIRICAL_PROFILE}.conf" ]] || {
    echo "[ERROR] LIRICAL profile not found: $LIRICAL_PROFILE"
    exit 1
}

if [[ -n "$AMELIE_PROFILE" ]]
then

    [[ -f "${AMELIE_PROFILE_DIR}/${AMELIE_PROFILE}.conf" ]] || {
        echo "[ERROR] AMELIE profile not found: $AMELIE_PROFILE"
        exit 1
}

fi

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

while IFS= read -r SAMPLE
do
    SAMPLE=$(echo "$SAMPLE" | xargs)
    [[ -z "$SAMPLE" ]] && continue
    [[ "$SAMPLE" =~ ^# ]] && continue
    
    echo
    echo "---------------------------------------"
    echo "Processing ${SAMPLE}"
    echo "---------------------------------------"

    SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

    [[ ! -d "$SAMPLE_DIR" ]] && \
    {
        echo "[ERROR] Sample directory not found: $SAMPLE_DIR"
        continue
    }

    ###############################################################
    # EXOMISER
    ###############################################################

    bash "$SCRIPT_DIR/exomiser.sh" \
        "${EXOMISER_PROFILE_DIR}/${EXOMISER_PROFILE}.conf" \
        "$SAMPLE"

    ###############################################################
    # LIRICAL
    ###############################################################

    bash "$SCRIPT_DIR/lirical.sh" \
        "${LIRICAL_PROFILE_DIR}/${LIRICAL_PROFILE}.conf" \
        "$SAMPLE"

    ###############################################################
    # AMELIE
    ###############################################################

    if [[ -n "$AMELIE_PROFILE" ]]
    then

        bash "$SCRIPT_DIR/amelie.sh" \
        "$SAMPLE" \
        "$AMELIE_PROFILE"

    fi

    ###############################################################
    # INTEGRATION
    ###############################################################

    bash "${SCRIPT_DIR}/integration.sh" \
        "$SAMPLE" \
        "$EXOMISER_PROFILE" \
        "$LIRICAL_PROFILE"

done < "$SAMPLE_LIST"

###############################################################################
# FINISHED
###############################################################################

echo
echo "======================================="
echo "Processed samples from: $SAMPLE_LIST"
echo "======================================="
echo
