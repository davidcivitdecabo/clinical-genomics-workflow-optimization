# Clinical Genomics Workflow Optimization
![Field](https://img.shields.io/badge/field-clinical_genomics-blue)
![Focus](https://img.shields.io/badge/focus-rare_disease_genomics-purple)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?logo=gnubash&logoColor=fff)](#)

Improving clinical genomics workflows by evaluating and optimizing tools for structural variant analysis, mitochondrial DNA analysis, and diagnostic variant prioritization.

---

## 1. Overview

This repository presents a modular clinical genomics workflow focused on benchmarking and optimization of analytical strategies for rare disease diagnostics.

The project combines:

* Structural variant workflow proposals using Manta and LUMPY
* Mitochondrial DNA analysis integration using eKLIPse
* Real-data benchmarking of phenotype-driven variant prioritization using Exomiser, LIRICAL, and AMELIE

![Workflow Overview](figures/workflow_overview.png)

The repository was inspired by workflow optimization proposals developed in a clinical genomics environment to improve reproducibility, interpretability, and diagnostic efficiency.

## 2. Quick Navigation

* Workflow design: `docs/workflow_design.md`
* Structural variant analysis: `docs/sv_analysis.md`
* mtDNA analysis: `docs/mitochondrial_analysis.md`
* Variant prioritization benchmarking: `docs/variant_prioritization_study.md`
* Proposed improvements: `docs/proposed_improvements.md`
* Future developments: `docs/future_work.md`

## 3. Clinical Motivation

Clinical genomics laboratories face increasing pressure to deliver accurate and interpretable results within limited diagnostic timelines.

Rare disease diagnostics remains especially challenging due to genomic heterogeneity, complex structural alterations, mitochondrial variants, and the difficulty of phenotype-driven interpretation.

This repository reflects workflow optimization strategies proposed in a hospital genomics environment to improve:

* Structural variant analysis
* mtDNA interpretation
* Variant prioritization
* Workflow reproducibility and scalability

## 4. Workflow Design and Components

The workflow is organized into three analytical modules:

- **Structural Variant Analysis**: evaluation of complementary SV callers (Manta and LUMPY).
- **Mitochondrial DNA Analysis**: proposed integration of eKLIPse for mtDNA rearrangement detection.
- **Variant Prioritization**: benchmarking of Exomiser, LIRICAL, and AMELIE under multiple configurations.

Only the variant prioritization module was evaluated using real clinical cases.

## 5. Tools and Methods

This workflow integrates several widely used bioinformatics tools that address complementary aspects of clinical genomics analysis. Each tool was selected based on its relevance to rare disease diagnostics, its methodological strengths, and its ability to contribute meaningful evidence for variant interpretation.

| Module                      | Tools                     |
| --------------------------- | ------------------------- |
| Structural Variant Analysis | Manta, LUMPY              |
| mtDNA Analysis              | eKLIPse                   |
| Variant Prioritization      | Exomiser, LIRICAL, AMELIE |
| Integration & Filtering     | Custom Bash scripts       |

The results obtained through variant prioritization were evaluated using real clinical cases during my work in a hospital genomics service. Only results comparing different filtering strategies and prioritization settings are included here, without specific patient information.

## 6. Repository Structure

The repository is organized to maintain modularity, reproducibility, and clear separation between workflow components, documentation, and benchmarking results.

```text
clinical-genomics-workflow-optimization/
│
├── README.md
│
├── config/
│   ├── config.sh
│   └── paths.example.conf
│
├── scripts/
│   ├── manta.sh
│   ├── lumpy.sh
│   ├── exomiser.sh
│   ├── lirical.sh
│   ├── amelie.sh
│   ├── filtering.sh
│   └── integration.sh
│
├── docs/
│   ├── clinical_context.md
│   ├── variant_prioritization.md
│   ├── variant_prioritization_study.md
│   ├── sv_analysis.md
│   ├── mitochondrial_analysis.md
│   └── benchmarking_strategy.md
│
├── results/
│   ├── comparative_tables/
│   └── prioritization_results/
│
├── examples/
│   ├── exomiser_output_example.tsv
│   ├── lirical_output_example.tsv
│   └── amelie_output_example.tsv
│
└── figures/
    ├── workflow_overview.png
    ├── sv_strategy.png
    └── prioritization_comparison.png
```
### Directory Description

| Directory | Description |
|----------|-------------|
| `config/` | Configuration files and example paths required to run the workflow. |
| `scripts/` | Modular scripts implementing SV detection, mtDNA analysis, variant prioritization, and custom integration/filtering logic. |
| `docs/` | Technical documentation describing workflow design, clinical context, benchmarking methodology, and analytical modules. |
| `results/` | Output directories containing benchmarking results and comparative analyses (no real patient data). |
| `examples/` | Example anonymized outputs illustrating expected tool formats. |
| `figures/` | Workflow diagrams and visual summaries of analytical strategies. |

The repository structure was designed to facilitate workflow readability, modular benchmarking, and future extensibility of the analytical framework.

## 7. Installation

This repository was designed as a modular benchmarking and workflow evaluation framework.

Main requirements:

* Bash
* Java (required for Exomiser and LIRICAL)
* Python 3

Clone the repository:

```bash
git clone https://github.com/your-username/clinical-genomics-workflow-optimization.git
cd clinical-genomics-workflow-optimization
```

Configuration examples are available in:
`config/paths.example.conf`

## 8. Example Outputs

The `examples/` directory contains fully synthetic outputs illustrating the expected structure of Exomiser, LIRICAL, and AMELIE results. These files allow users to test the workflow without requiring clinical datasets.

All example files contain synthetic data only.

## 9. Benchmarking Highlights

- Comparative evaluation of Exomiser and LIRICAL under multiple filtering configurations
- Analysis of ranking stability for previously validated pathogenic variants
- Evaluation of filtering impact on candidate prioritization
- Comparison of phenotype-driven prioritization behavior across tools

![Prioritization Benchmarking](figures/prioritization_comparison.png)

## 10. Proposed Improvements

A detailed description of proposed workflow optimizations for SV analysis, mtDNA analysis, and variant prioritization is available in `docs/proposed_improvements.md`.

## 11. Limitations

Main limitations should be considered when interpreting this repository:

* Real clinical benchmarking was limited to variant prioritization analyses using previously diagnosed cases.
* Benchmarking results reflect tool versions and annotation databases available at the time of analysis.
* AMELIE integration was limited by privacy constraints.

Additional methodological details are available in:
`docs/variant_prioritization_study.md`

## 12. Future Work

Potential future developments include:

* Benchmarking of structural variant and mtDNA workflows
* Expansion of prioritization benchmarking cohorts
* Workflow automation and containerization
* Integration of additional interpretation and annotation layers

Planned extensions and workflow improvements are described in `docs/future_work.md`.

## 13. Author

## 11. Author

Developed by David Civit Decabo.

Background:

* BSc in Biology
* MSc in Bioinformatics and Biostatistics
* Experience in clinical genomics, rare disease analysis, and molecular laboratory environments

Main interests:

* Rare disease genomics
* Variant prioritization
* Clinical bioinformatics workflows
* Benchmarking and reproducibility
