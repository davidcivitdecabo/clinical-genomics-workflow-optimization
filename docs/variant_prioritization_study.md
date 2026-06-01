# Variant Prioritization Study

## Overview

Variant prioritization represents one of the most critical stages of rare disease genomic diagnostics. Even after standard filtering procedures, clinical exome analyses typically generate hundreds of candidate variants requiring manual review and interpretation.

This study was designed to evaluate how different phenotype-driven prioritization tools and filtering strategies affect the ranking of previously validated pathogenic variants. The objective was to identify configurations capable of maximizing recovery of causal variants while reducing the burden of manual variant review.

The benchmarking focused on three widely used prioritization tools:

* Exomiser
* LIRICAL
* AMELIE

Only previously diagnosed clinical exome cases were included, allowing objective evaluation based on the known position of the causal variant.

---

## Study Cohort

A total of 221 diagnosed exome cases were randomly selected from a cohort of previously solved rare disease patients.

Some patients carried more than one pathogenic variant contributing to diagnosis, resulting in a total of 240 diagnostic variants initially considered.

Prior to benchmarking, variants were excluded according to predefined criteria:

| Exclusion Criterion                      | Variants Excluded |
| ---------------------------------------- | ----------------- |
| Diagnosed using array-based technologies | 6                 |
| Missing patient HPO annotations          | 1                 |
| Total excluded                           | 7                 |

The final benchmarking dataset consisted of:

* 214 patients
* 232 confirmed causal variants

This dataset was used for all comparative analyses presented in this repository.

---

## Benchmarking Objectives

The study aimed to evaluate:

* Ranking performance of different prioritization tools.
* Impact of filtering strategies on prioritization results.
* Effect of variant quality thresholds.
* Influence of allele-frequency filtering.
* Utility of additional pathogenicity predictors.
* Feasibility of combining prioritization tools to reduce review burden.

An additional exploratory analysis compared exomes diagnosed during the initial analysis with exomes requiring subsequent reanalysis, under the hypothesis that reanalyzed cases may represent more challenging diagnostic scenarios.

---

## Evaluation Metrics

For each configuration, the ranking position assigned to the known causal variant was recorded.

Results were summarized using the following metrics:

| Metric     | Description                                        |
| ---------- | -------------------------------------------------- |
| Top 1      | Causal variant ranked first                        |
| Top 3      | Causal variant ranked within first three positions |
| Top 5      | Causal variant ranked within first five positions  |
| Top 10     | Causal variant ranked within first ten positions   |
| Top 50     | Causal variant ranked within first fifty positions |
| Ranked     | Variant present in tool output                     |
| Not Ranked | Variant absent from output                         |

These metrics were selected to reflect both diagnostic usefulness and practical review effort.

---

## Exomiser Evaluation

### Tested Parameters

The following parameters were systematically evaluated:

| Parameter                   | Tested Values       |
| --------------------------- | ------------------- |
| Variant Quality             | ≥100, ≥200          |
| Allele Frequency            | ≤0.01, ≤0.02, ≤0.05 |
| MVP Pathogenicity Predictor | Enabled / Disabled  |

This resulted in twelve Exomiser configurations.

### Rationale

Allele-frequency thresholds were evaluated to assess the balance between sensitivity and reduction of candidate variants.

Quality thresholds were tested to determine whether more stringent variant confidence requirements improved prioritization performance.

The MVP pathogenicity predictor was evaluated to determine whether incorporating additional pathogenicity evidence improved ranking accuracy.

---

## LIRICAL Evaluation

### Tested Parameters

| Parameter        | Tested Values                  |
| ---------------- | ------------------------------ |
| Allele Frequency | No filter, ≤0.05, ≤0.02, ≤0.01 |

### Rationale

Because LIRICAL relies primarily on phenotype likelihood ratios rather than pathogenicity prediction scores, the evaluation focused on the impact of allele-frequency filtering on prioritization performance.

---

## AMELIE Evaluation

Due to clinical privacy constraints associated with the use of external APIs, AMELIE could not be evaluated under identical conditions to Exomiser and LIRICAL.

Three complementary approaches were therefore explored:

### Complete Gene List

AMELIE was provided with the complete list of genes containing candidate variants for each patient.

### Filtered Gene List

A second analysis used allele-frequency filtered candidate genes:

* Homozygous variants: AF ≤ 0.005
* Heterozygous variants: AF ≤ 0.001

### Known Causal Variant Validation

For a subset of ten patients, only the known causal variant was submitted.

This analysis aimed to assess whether AMELIE could recognize variants already known to be responsible for disease.

---

## Combined Prioritization Strategy

A practical filtering strategy was developed to evaluate whether combining prioritization tools could reduce manual review burden while maintaining diagnostic sensitivity.

The strategy combined:

* Top 10 variants ranked by Exomiser
* Top 5 variants ranked by LIRICAL

This produced a final candidate list of at most 15 variants per patient.

### Study Objectives

The primary objective of this study was to evaluate prioritization strategies capable of improving the efficiency of rare disease diagnostics.

More specifically, the study aimed to:

- Assess the ability of different prioritization configurations to recover previously validated pathogenic variants.
- Evaluate the impact of filtering strategies on candidate ranking.
- Identify prioritization settings that maximize recovery of causal variants.
- Explore whether complementary prioritization tools could be combined to reduce the number of variants requiring manual review.
- Propose a practical prioritization workflow suitable for routine clinical genomics environments.

---

## Study Scope

This benchmarking study focuses exclusively on variant prioritization performance.

Structural variant analysis and mitochondrial DNA analysis described elsewhere in this repository were not included in the benchmarking cohort and remain methodological workflow proposals.

Results obtained from this study are presented in `benchmarking_results.md`.
