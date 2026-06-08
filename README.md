# Clinical Genomics Workflow Optimization
![Field](https://img.shields.io/badge/field-clinical_genomics-blue)
![Focus](https://img.shields.io/badge/focus-rare_disease_genomics-purple)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?logo=gnubash&logoColor=fff)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Optimizing analytical strategies for rare disease diagnosis

---

## Project Overview

This repository presents a modular clinical genomics workflow focused on benchmarking and optimization of analytical strategies for rare disease diagnostics.

The project combines:

* Structural variant workflow proposals using Manta and LUMPY
* Mitochondrial DNA analysis integration using eKLIPse
* Optimization of phenotype-driven variant prioritization strategies to improve diagnostic efficiency in rare disease genomics

![Workflow Overview](figures/workflow_overview.png)

The repository was inspired by workflow optimization proposals developed in a clinical genomics environment to improve reproducibility, interpretability, and diagnostic efficiency.

## Clinical Context and Motivation

Clinical genomics laboratories face increasing pressure to deliver accurate and interpretable results within limited diagnostic timelines.

Rare disease diagnostics remains especially challenging due to genomic heterogeneity, complex structural alterations, mitochondrial variants, and the difficulty of phenotype-driven interpretation.

This repository reflects workflow optimization strategies proposed in a hospital genomics environment to improve:

* Structural variant analysis
* mtDNA interpretation
* Variant prioritization
* Workflow reproducibility and scalability

📄 Full documentation: [Clinical Context and Motivation](docs/clinical_motivation.md)

## Workflow Design and Components

The workflow is organized into three analytical modules:

- **Structural Variant Analysis**: evaluation of complementary SV callers (Manta and LUMPY).
- **Mitochondrial DNA Analysis**: proposed integration of eKLIPse for mtDNA rearrangement detection.
- **Variant Prioritization**: benchmarking of Exomiser, LIRICAL, and AMELIE under multiple configurations.

Only the variant prioritization module was evaluated using real clinical cases.

📄 Full documentation: [Workflow Design And Components](docs/workflow_design.md)

## Analytical Tools and Methods

This workflow integrates several widely used bioinformatics tools that address complementary aspects of clinical genomics analysis. Each tool was selected based on its relevance to rare disease diagnostics, its methodological strengths, and its ability to contribute meaningful evidence for variant interpretation.

| Module | Tools | Purpose |
|----------|----------|----------|
| Structural Variant Analysis | Manta, LUMPY | Detection of large genomic rearrangements |
| mtDNA Analysis | eKLIPse | Detection of mtDNA deletions and heteroplasmy |
| Variant Prioritization | Exomiser, LIRICAL, AMELIE | Phenotype-driven ranking of candidate variants |
| Integration & Filtering | Custom Bash scripts | Specific configuration of the variant prioritization strategy |

The results obtained through variant prioritization were evaluated using real clinical cases during my work in a hospital genomics service. Only results comparing different filtering strategies and prioritization settings are included here, without specific patient information.

📄 Full documentation: [Tools and Methods](docs/tools_and_methods.md)

## Repository Structure

The repository is organized to maintain modularity, reproducibility, and clear separation between workflow components, documentation, and benchmarking results.

```text
clinical-genomics-workflow-optimization/
│
├── .gitignore
├── LICENSE
├── README.md
│
├── config/
│   ├── amelie_profiles/
│      ├── gene_list.conf
│      ├── gene_list_filtered.conf
│      └── vcf.conf
│   ├── exomiser_profiles/
│      ├── q100_af001.conf
│      ├── q100_af002.conf
│      ├── q100_af005.conf
│      ├── q100_mvp_af001.conf
│      ├── q100_mvp_af002.conf
│      ├── q100_mvp_af005.conf
│      ├── q200_af001.conf
│      ├── q200_af002.conf
│      ├── q200_af005.conf
│      ├── q200_mvp_af001.conf
│      ├── q200_mvp_af002.conf
│      └── q200_mvp_af005.conf
│   ├── lirical_profiles/
│      ├── af001.conf
│      ├── af002.conf
│      ├── af005.conf
│      └── no_filter.conf
│   ├── system.conf
│   └── system.example.conf
│
├── docs/
│   ├── author.md
│   ├── benchmarking_results.md
│   ├── clinical_motivation.md
│   ├── example_outputs.md
│   ├── future_work.md
│   ├── limitations.md
│   ├── project_summary.md
│   ├── proposed_improvements.md
│   ├── references.md
│   ├── tools_and_methods.md
│   ├── variant_prioritization_study.md
│   └── workflow_design.md
│
├── examples/
│   ├── SAMPLE_001/
│      ├── HPO_terms.txt
│      ├── SAMPLE_001.vcf
│      ├── SAMPLE_001_filtered_sorted_hg38.vcf
│      ├── SAMPLE_001_gnomad_values_hg38.txt
│      ├── gene_list.txt
│      └── gene_list_filtered.txt
│   ├── SAMPLE_002/
│      ├── HPO_terms.txt
│      ├── SAMPLE_002.vcf
│      ├── SAMPLE_002_filtered_sorted_hg38.vcf
│      ├── SAMPLE_002_gnomad_values_hg38.txt
│      ├── gene_list.txt
│      └── gene_list_filtered.txt
│
├── figures/
│   ├── workflow_overview.png
│   ├── prioritization_comparison.png
│   └── ranking_heatmap.png
│
├── results/
│   ├── amelie/
│   ├── analysis/
│   ├── benchmark/
│   ├── exomiser/
│   ├── integration/
│   └── lirical/
│
├── scripts/
│   ├── amelie.sh
│   ├── amelie_gene_api.py
│   ├── amelie_vcf.sh
│   ├── amelie_vcf_api.py
│   ├── exomiser.sh
│   ├── manta.sh
│   ├── lumpy.sh
│   ├── integration.sh
│   ├── lirical.sh
│   ├── run_analysis.sh
│   └── run_benchmark.sh
└── templates/
    └── analysis-exome.yml
```
### Directory Description

| Directory | Description |
|----------|-------------|
| `config/` | Configuration files and example paths required to run the workflow. |
| `docs/` | Technical documentation describing workflow design, clinical context, benchmarking methodology, and analytical modules. |
| `examples/` | Example anonymized input files to execute the variant prioritization workflows included in this repository. |
| `figures/` | Workflow diagrams and visual summaries of analytical strategies. |
| `results/` | Output directories containing benchmarking results and comparative analyses (no real patient data). |
| `scripts/` | Modular scripts implementing SV detection, mtDNA analysis, variant prioritization, and custom integration/filtering logic. |
| `templates/` | Exomiser configuration templates. |

The repository structure was designed to facilitate workflow readability, modular benchmarking, and future extensibility of the analytical framework.

## Setup & Requirements

This repository was designed as a modular benchmarking and workflow evaluation framework.

- Main requirements:

    * Bash
    * Java (Exomiser, LIRICAL)
    * [Exomiser](https://github.com/exomiser/Exomiser)
    * [LIRICAL](https://github.com/TheJacksonLaboratory/LIRICAL)
    * Python 3
    * Linux environment recommended

- Included Example Files per Sample

| File                                     | Description                                                                                                       |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `HPO_terms.txt`                          | Human Phenotype Ontology (HPO) terms associated with the sample, one term per line                                |
| `(sample name).vcf`                      | Input VCF used by AMELIE VCF mode (`amelie_vcf.sh`) using hg19 coordinates                                        |
| `(sample name)_filtered_sorted_hg38.vcf` | Input VCF used by Exomiser and LIRICAL analyses (hg38 coordinates)                                                |
| `(sample name)_gnomad_values_hg38.txt`   | gnomAD allele frequency annotations corresponding to variants present in `(sample name)_filtered_sorted_hg38.vcf` |
| `gene_list.txt`                          | List of genes containing variants identified in the sample                                                        |
| `gene_list_filtered.txt`                 | Filtered version of `gene_list.txt` used by selected AMELIE configurations                                        |

Clone the repository:

```bash
git clone https://github.com/davidcivitdecabo/clinical-genomics-workflow-optimization.git
cd clinical-genomics-workflow-optimization
# Edit config/system.example.conf the file with the user paths
cp config/system.example.conf config/system.conf
```

Configuration profiles are available in:
`config/system.example.conf`

The workflow uses configuration profiles to define analysis parameters.

| Prioritizer | Path | Example | Parameters |
|----------|-------------|-------------|-------------|
| Exomiser | `config/exomiser_profiles/` | `q100_mvp_af005.conf` | quality threshold, allele frequency cutoff, pathogenicity predictors, MVP usage |
| LIRICAL | `config/lirical_profiles/` | `af001.conf` | allele frequency filtering, pathogenicity thresholds, validation policy |
| AMELIE | `config/amelie_profiles/` | `gene_list.conf` | gene list, vcf |        

## Quick start

- Run benchmark

Execute all predefined Exomiser, LIRICAL and AMELIE configurations:

```
bash scripts/run_benchmark.sh
```

This command iterates over all samples contained in `$SAMPLES_DIR` and generates for every configured profile combination:

- Exomiser results
- LIRICAL results
- AMELIE results
- Exomiser–LIRICAL integration results

- Run a custom Exomiser + LIRICAL analysis

```
bash scripts/run_analysis.sh \
    --samples samples.txt \
    --exomiser q200_af005 \
    --lirical af005
```
- Run a custom Exomiser + LIRICAL + AMELIE analysis

```
bash scripts/run_analysis.sh \
    --samples samples.txt \
    --exomiser q200_af005 \
    --lirical af005 \
    --amelie gene_list
```
 
## Example Outputs

The `examples/` directory contains fully synthetic outputs illustrating the expected structure of Exomiser, LIRICAL, and AMELIE results. These files allow users to test the workflow without requiring clinical datasets.

All example files contain synthetic data only.

📄 Full documentation: [Example Outputs](docs/example_outputs.md)

## Benchmarking Results

The variant prioritization benchmarking study evaluated 232 pathogenic variants from 214 previously diagnosed rare disease patients.

Key findings include:

- Exomiser achieved the strongest overall prioritization performance, recovering up to 221 of 232 causal variants.
- LIRICAL provided complementary phenotype-driven prioritization with highly stable performance across filtering configurations.
- AMELIE showed limited ranking performance when using gene lists alone but produced consistently high confidence scores when the causal variant was directly evaluated.
- A combined Exomiser-LIRICAL filtering strategy recovered 199 causal variants while reducing manual review to only 15 candidate variants per case.

These results illustrate how prioritization strategies and filtering configurations can substantially affect diagnostic efficiency and review burden in rare disease genomics workflows.

**Figure 1.**
Comparison of prioritization performance across filtering configurations.

![Prioritization Benchmarking](figures/prioritization_comparison.png)

**Figure 2.**
Heatmap showing ranking positions of known causal variants across patients and prioritization strategies.

![Causal Variant Ranking Heatmap](figures/ranking_heatmap.png)

## Proposed Improvements

A detailed description of proposed workflow optimizations for SV analysis, mtDNA analysis, and variant prioritization is available in [Proposed_Improvements](docs/proposed_improvements.md).

## Methodological Limitations

Main limitations should be considered when interpreting this repository:


* Structural variant and mtDNA modules are included as workflow design proposals and were not benchmarked using clinical datasets.
* Real clinical benchmarking was limited to variant prioritization analyses using previously diagnosed cases.
* Benchmarking results reflect tool versions and annotation databases available at the time of analysis.
* AMELIE integration was limited by privacy constraints.

Additional methodological details are available in: [Limitations](docs/limitations.md)

## Future Work

Potential future developments include:

* Benchmarking of structural variant and mtDNA workflows
* Expansion of prioritization benchmarking cohorts
* Workflow automation and containerization
* Integration of additional interpretation and annotation layers

Planned extensions and workflow improvements are described in [Future Work](docs/future_work.md).

## Author

Developed by David Civit Decabo, a bioinformatician with experience in clinical genomics, rare disease diagnostics, and molecular laboratory environments.

Background:

* BSc in Biology
* MSc in Bioinformatics and Biostatistics
* Experience in clinical genomics, rare disease analysis, and molecular laboratory environments

Key Skills Demonstrated:

* Clinical genomics workflow evaluation
* Rare disease variant prioritization
* Benchmarking and comparative tool assessment
* Structural variant analysis strategies
* Phenotype-driven genomic interpretation
* Reproducible bioinformatics workflow design
* Bash scripting and workflow modularization

📄 More information about the author in: [Author](docs/author.md)
