#!/usr/bin/env bash

###############################################################################
# manta.sh
#
# Structural Variant (SV) calling using Manta.
#
# This module is included as a workflow proposal and is not part of the
# benchmarking analyses described in this repository.
#
# Requirements:
#   - configManta.py
#   - runWorkflow.py
#   - BAM file
#   - Reference genome FASTA
#
###############################################################################

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage:"
    echo "  manta.sh <sample>"
    exit 1
fi

SAMPLE=$1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/../config/system.conf"

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

if [[ ! -d "$SAMPLE_DIR" ]]; then
    echo "[ERROR] Sample directory not found:"
    echo "        $SAMPLE_DIR"
    exit 1
fi

BAM_FILE="${SAMPLE_DIR}/${SAMPLE}.bam"

if [[ ! -f "$BAM_FILE" ]]; then
    echo "[ERROR] BAM file not found:"
    echo "        $BAM_FILE"
    exit 1
fi

if [[ ! -f "$REFERENCE_FASTA" ]]; then
    echo "[ERROR] Reference FASTA not found:"
    echo "        $REFERENCE_FASTA"
    exit 1
fi

RUN_DIR="${SAMPLE_DIR}/manta_run"

echo "[INFO] Running Manta"
echo "[INFO] Sample: ${SAMPLE}"

configManta.py \
    --bam "$BAM_FILE" \
    --referenceFasta "$REFERENCE_FASTA" \
    --runDir "$RUN_DIR"

"${RUN_DIR}/runWorkflow.py" \
    -m local \
    -j "${THREADS:-8}"

echo "[INFO] Finished"
echo "[INFO] Results:"
echo "${RUN_DIR}/results/variants"
