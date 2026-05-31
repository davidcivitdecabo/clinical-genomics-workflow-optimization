# Analytical Tools and Methods

This repository integrates a set of open-source bioinformatics tools that address complementary challenges in rare disease genomics, including structural variant detection, mitochondrial DNA analysis, and phenotype-driven variant prioritization.

Tool selection was guided by several practical and methodological criteria relevant to clinical genomics workflow design:

* Open-source availability, enabling transparency, reproducibility, and independent evaluation.
* Strong performance reported in published benchmarking and comparative studies.
* Broad adoption within the clinical and research genomics communities.
* Complementary methodological approaches that provide different sources of diagnostic evidence.
* Compatibility with a modular workflow architecture, facilitating benchmarking and future tool replacement or extension.

Rather than selecting a single tool for each analytical task, the workflow was designed to evaluate complementary approaches whose strengths and limitations may provide different diagnostic insights.

---

## Structural Variant Analysis

Structural variant detection was explored through the integration of two complementary callers representing different methodological approaches.

| Tool  | Methodology                                                          | Main Strengths                                                                           | Main Limitations                                                                      |
| ----- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Manta | Local assembly combined with discordant pair and split-read evidence | Fast detection of a broad range of structural variants, including complex rearrangements | Reduced performance in repetitive genomic regions and dependence on alignment quality |
| LUMPY | Probabilistic integration of multiple alignment signals              | Improved sensitivity and breakpoint resolution through multi-signal evidence integration | More complex preprocessing requirements and dependence on high-quality alignments     |

Manta and LUMPY were selected because they are widely used open-source structural variant callers and have consistently been included in comparative evaluations of short-read SV detection approaches. Their methodological complementarity makes them suitable candidates for exploring concordance, breakpoint resolution, and complementary variant discovery strategies.

The objective of this module is to explore how complementary SV detection approaches could improve the identification and interpretation of genomic rearrangements relevant to rare disease diagnostics.

No benchmarking using clinical datasets was performed for this module. The implementation is included as a workflow optimization proposal for future evaluation.

---

## Mitochondrial DNA Analysis

Mitochondrial DNA analysis was incorporated through the proposed integration of eKLIPse.

| Tool    | Methodology                                                                  | Main Strengths                                                                           | Main Limitations                                        |
| ------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| eKLIPse | Detection of mtDNA deletions, rearrangements, and heteroplasmy from NGS data | Specialized analysis of mitochondrial structural alterations and heteroplasmy estimation | Requires sufficient sequencing depth and mtDNA coverage |

eKLIPse was selected because it provides a dedicated framework for detecting and quantifying large mitochondrial DNA rearrangements and heteroplasmy, two aspects that are often underrepresented in standard rare disease pipelines. The original publication demonstrated high sensitivity for mtDNA deletion detection and highlighted its utility for mitochondrial disease diagnostics.

The objective of this module is to demonstrate how mtDNA analysis could be incorporated into a clinical genomics workflow and contribute additional evidence for the diagnosis of mitochondrial disorders.

No benchmarking using real clinical datasets was performed for this component.

---

## Variant Prioritization

The variant prioritization study focused on three complementary approaches for phenotype-driven candidate ranking.

| Tool     | Methodology                                                                              | Main Strengths                                                                              | Main Limitations                                                              |
| -------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Exomiser | Combined genotype-phenotype prioritization using pathogenicity scores and HPO similarity | Strong integration of variant-level and phenotype-level evidence                            | Sensitive to phenotype quality and database updates                           |
| LIRICAL  | Likelihood ratio–based phenotype-driven prioritization                                   | Transparent and interpretable probabilistic framework                                       | Performance can be affected by incomplete HPO annotation                      |
| AMELIE   | Literature-based prioritization using automated publication mining                       | Exploits published gene-disease relationships and continuously growing literature resources | Potential bias toward well-studied genes and literature-dependent performance |

These tools were selected because they represent complementary prioritization paradigms that have demonstrated strong performance in rare disease genomics and are widely used within the clinical genomics community.

Together they cover three major sources of diagnostic evidence:

* Phenotype-genotype integration (Exomiser)
* Probabilistic phenotype matching (LIRICAL)
* Literature-driven prioritization (AMELIE)

This combination enables comparison of different prioritization philosophies while maintaining methodological diversity within the benchmarking framework.

---

## Integration and Filtering Strategy

Beyond the execution of individual prioritization tools, a set of custom Bash scripts was developed to support systematic benchmarking and comparison of prioritization strategies.

These scripts enable:

* Integration of candidate rankings across tools
* Application of configurable filtering criteria
* Comparative benchmarking under multiple configurations
* Evaluation of ranking stability and reproducibility

The objective was to identify configurations that consistently ranked previously validated disease-causing variants as highly as possible while minimizing the risk of excluding clinically relevant candidates during filtering.

---

## Technical Contributions

This project involved:

* Workflow architecture design
* Selection and evaluation of complementary bioinformatics tools
* Development of Bash-based integration and filtering scripts
* Design of benchmarking methodologies for variant prioritization
* Comparative analysis of prioritization strategies
* Documentation of reproducible clinical genomics workflows

---

## Software Resources

* Manta: https://github.com/Illumina/manta
* LUMPY: https://github.com/arq5x/lumpy-sv
* eKLIPse: https://github.com/dooguypapua/eKLIPse
* Exomiser: https://github.com/exomiser/Exomiser
* LIRICAL: https://github.com/TheJacksonLaboratory/LIRICAL
* AMELIE: https://amelie.stanford.edu
