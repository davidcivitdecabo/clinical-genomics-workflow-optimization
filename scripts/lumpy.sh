#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage:"
    echo "  lumpy.sh <sample>"
    exit 1
fi

SAMPLE=$1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

source "${ROOT_DIR}/config/system.conf"

SAMPLE_DIR="${SAMPLES_DIR}/${SAMPLE}"

echo "[INFO] Running LUMPY"
echo "[INFO] Sample: ${SAMPLE}"

BAM="${SAMPLE_DIR}/${SAMPLE}.bam"
SPLITTERS="${SAMPLE_DIR}/${SAMPLE}.splitters.bam"
DISCORDANTS="${SAMPLE_DIR}/${SAMPLE}.discordants.bam"

[[ -f "$BAM" ]] || {
    echo "[ERROR] Missing BAM:"
    echo "        $BAM"
    exit 1
}

[[ -f "$SPLITTERS" ]] || {
    echo "[ERROR] Missing splitters BAM:"
    echo "        $SPLITTERS"
    exit 1
}

[[ -f "$DISCORDANTS" ]] || {
    echo "[ERROR] Missing discordants BAM:"
    echo "        $DISCORDANTS"
    exit 1
}

OUTPUT_DIR="${RESULTS_DIR}/lumpy"

mkdir -p "$OUTPUT_DIR"

OUTPUT_VCF="${OUTPUT_DIR}/${SAMPLE}_lumpy.vcf"

lumpyexpress \
    -B "$BAM" \
    -S "$SPLITTERS" \
    -D "$DISCORDANTS" \
    -o "$OUTPUT_VCF"

echo "[INFO] Finished"
echo "[INFO] Output:"
echo "        $OUTPUT_VCF"
