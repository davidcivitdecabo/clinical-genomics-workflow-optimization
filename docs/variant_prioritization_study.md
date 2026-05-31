# Variant Prioritization Benchmarking Study

## Overview

This study evaluates the performance of phenotype-driven variant prioritization tools under multiple filtering and configuration strategies within a rare disease diagnostic context.

The objective was to assess how different prioritization approaches influence the ranking of previously identified causal variants and to explore whether optimized filtering strategies could improve prioritization efficiency while reducing the burden of manual variant interpretation.

The benchmarking focused on three widely used prioritization tools:

* Exomiser
* LIRICAL
* AMELIE

Only previously diagnosed exome cases were included, enabling direct evaluation of how each prioritization strategy ranked known disease-causing variants.

---

## Study Workflow

The benchmarking study followed the workflow below:

1. Selection of previously diagnosed exome cases.
2. Eligibility assessment and exclusion of unsuitable variants.
3. Execution of Exomiser, LIRICAL, and AMELIE under multiple configurations.
4. Evaluation of filtering strategies and ranking behavior.
5. Comparison of prioritization performance across tools.
6. Assessment of combined prioritization approaches.
7. Analysis of ranking performance in reanalyzed versus initially diagnosed cases.

---

## Cohort Selection

A total of 221 randomly selected diagnosed exome cases were included from a clinical genomics service.

Because some patients carried more than one disease-causing variant, the initial dataset contained 243 diagnostic variants.

### Exclusion Criteria

A total of 11 variants were excluded from the analysis:

| Exclusion Criterion                                            | Number Excluded |
| -------------------------------------------------------------- | --------------- |
| Missing patient HPO information                                | 1               |
| Variants originally detected by array-based methods            | 6               |
| Variants classified as VUS (Variant of Uncertain Significance) | 4               |

### Final Benchmarking Dataset

| Metric                      | Value |
| --------------------------- | ----- |
| Patients included           | 221   |
| Initial diagnostic variants | 243   |
| Excluded variants           | 11    |
| Final variants evaluated    | 232   |

The resulting dataset consisted exclusively of previously validated pathogenic or likely pathogenic variants with available phenotype information.

---

## Exomiser Evaluation

Exomiser was evaluated under multiple filtering and scoring configurations to assess the impact of parameter selection on causal variant ranking.

### Parameters Evaluated

#### Variant Quality Threshold

* QUAL ≥ 100
* QUAL ≥ 200

#### Allele Frequency Threshold

* AF ≤ 1.0
* AF ≤ 0.05
* AF ≤ 0.02
* AF ≤ 0.01

#### Pathogenicity Prediction

* MVP enabled
* MVP disabled

The objective was to determine how filtering stringency and pathogenicity prediction influenced ranking performance and prioritization consistency.

---

## LIRICAL Evaluation

LIRICAL was evaluated using multiple allele frequency filtering strategies.

### Parameters Evaluated

#### Allele Frequency Threshold

* No allele frequency filtering
* AF ≤ 0.05
* AF ≤ 0.02
* AF ≤ 0.01

The analysis focused on assessing the influence of variant frequency filtering on likelihood ratio–based prioritization performance.

---

## AMELIE Evaluation

Due to clinical data privacy restrictions associated with the use of an external platform, AMELIE could not be evaluated using the complete patient variant and phenotype datasets employed for Exomiser and LIRICAL.

Three alternative evaluation strategies were explored:

### Strategy 1: Full Gene List

AMELIE was executed using the complete list of genes containing variants identified in each patient.

### Strategy 2: Frequency-Filtered Gene List

Gene lists were filtered prior to AMELIE execution using the following allele frequency thresholds:

* Homozygous variants: AF ≤ 0.005
* Heterozygous variants: AF ≤ 0.001

### Strategy 3: Causal Variant Assessment

For a subset of ten patients, AMELIE was evaluated using only the known disease-causing variant to assess the system's ability to identify the corresponding gene-disease association.

Because of these limitations, AMELIE results were interpreted separately from the primary Exomiser-LIRICAL benchmarking analysis.

---

## Reanalysis Assessment

Cases were divided into two groups:

* Diagnosed during the initial exome analysis.
* Diagnosed following exome reanalysis.

This comparison was performed to investigate whether reanalyzed cases represented more diagnostically challenging scenarios and whether prioritization performance differed between the two groups.

The rationale was that cases requiring reanalysis may reflect increased interpretation complexity, incomplete knowledge at the time of initial analysis, or variants located in genes that became clinically relevant after subsequent evidence emerged.

---

## Combined Prioritization Strategy

A combined prioritization approach was evaluated to determine whether complementary evidence from multiple tools could reduce the number of variants requiring manual review.

The strategy used the best-performing configuration identified for each prioritization tool:

* Top 10 ranked variants from Exomiser
* Top 5 ranked variants from LIRICAL

This generated a candidate list containing a maximum of 15 variants per case.

The objective was to assess whether a reduced candidate set could preserve prioritization performance while facilitating downstream clinical interpretation and reducing reviewer workload.

---

## Evaluation Criteria

The benchmarking focused on ranking behavior rather than diagnostic sensitivity or specificity.

The primary evaluation criteria included:

* Ranking position of known causal variants.
* Effect of filtering strategies on ranking performance.
* Consistency of prioritization across configurations.
* Comparison between prioritization tools.
* Performance of combined prioritization approaches.
* Differences between initial and reanalyzed diagnostic cases.

---

## Data Privacy and Ethical Considerations

All benchmarking analyses were performed using previously diagnosed clinical cases.

No patient-identifiable information is included in this repository.

Only aggregated benchmarking results, methodological descriptions, and synthetic example outputs are provided.

The repository is intended to document workflow evaluation strategies while maintaining compliance with privacy and confidentiality requirements.

---

## Relationship to Benchmarking Results

This document describes the study design, cohort selection, evaluated configurations, and methodological framework.

The benchmarking outcomes, comparative analyses, figures, and summary tables generated from this study are presented separately in:

`docs/benchmarking_results.md`

