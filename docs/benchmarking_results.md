# Benchmarking Results

## Overview

The benchmarking study evaluated the ability of different prioritization strategies to recover previously validated pathogenic variants in a cohort of rare disease patients.

A total of 232 pathogenic variants from 214 patients were included in the final analysis.

The study compared multiple configurations of Exomiser, LIRICAL, and AMELIE, as well as a combined Exomiser-LIRICAL filtering strategy designed to reduce manual review burden.

---

## Best Performing Configurations

The configurations shown below correspond to the profile files available in `config/exomiser_profiles/` and `config/lirical_profiles/`.

| Tool            | Profile | Description               | Top-1 (%)                 | Top-10 (%) | Ranked Variants (%) |
| --------------- | --------------- | --------------------------- | ---------------------- | ------ | --------------- |
| Exomiser        | q200_af005 | Quality ≥200, AF ≤0.05      | 56.03%                    | 81.90%    | 95.26%             |
| Exomiser        | q200_mvp_af005 | Quality ≥200, MVP, AF ≤0.05 | 55.17%                    | 82.33%    | 95.26%             |
| LIRICAL         | af005 | AF ≤0.05                    | 27.16%                     | 68.10%    | 91.81%             |
| AMELIE          | gene_list_filtered | AF-filtered gene list       | 5.17%                     | 18.53%     | 89.66%             |
| Combined Strategy | `integration.sh` | Exomiser + LIRICAL          | - | -      | 85.78%             |



---

## Comparative Performance

![Prioritization Benchmarking](../figures/prioritization_comparison.png)

The comparison demonstrates substantial differences in prioritization behavior across tools.

Exomiser consistently achieved the highest recovery of causal variants, particularly within the Top-10 ranked candidates.

LIRICAL showed lower Top-1 performance but maintained stable results across all allele-frequency configurations.

AMELIE exhibited limited ranking performance when using gene lists but generated high confidence scores when the causal variant was directly queried.

---

## Ranking Consistency

![Ranking Heatmap](../figures/ranking_heatmap.png)

The heatmap summarizes ranking positions obtained across patients and prioritization configurations.

This visualization highlights:

* Configuration stability
* Tool-specific ranking behavior
* Consistency of causal variant recovery
* Effects of filtering strategies

---

## Combined Filtering Strategy

One of the main objectives of the study was to evaluate whether complementary prioritization tools could be combined to reduce the number of variants requiring manual review.

The selected strategy combined:

* Top 10 variants from the best-performing Exomiser configuration
* Top 5 variants from the best-performing LIRICAL configuration

This generated a candidate list of only 15 variants per patient.

Despite this substantial reduction in review burden, the combined strategy recovered:

* 199 of 232 pathogenic variants
* Approximately 85.8% recovery

This result suggests that complementary prioritization approaches can significantly improve diagnostic efficiency while maintaining high recovery of clinically relevant variants.

---

## Key Findings

### Exomiser

* Best overall prioritization performance.
* Strong Top-1 and Top-10 recovery.
* Higher allele-frequency thresholds improved overall recovery.
* MVP produced only modest effects on performance.

### LIRICAL

* Stable performance across filtering configurations.
* Strong phenotype-driven prioritization.
* Useful as a complementary prioritization strategy.

### AMELIE

* Limited performance when using gene lists alone.
* High confidence scores when evaluating known causal variants.
* Potentially useful as an evidence-support tool rather than a primary prioritizer.

### Combined Strategy

* Highest practical value for diagnostic workflows.
* Reduced candidate review to 15 variants per patient.
* Recovered approximately 86% of causal variants.
* Demonstrated the benefit of integrating complementary prioritization approaches.

---

## Clinical Interpretation

The main objective of the benchmarking study was to identify prioritization strategies capable of reducing interpretation burden while maintaining recovery of clinically relevant variants.

The combined Exomiser-LIRICAL strategy was particularly notable because it reduced the review space to only 15 candidate variants per patient while retaining approximately 86% of known pathogenic variants.

This result suggests that prioritization strategies can substantially improve diagnostic efficiency in rare disease genomics workflows.
