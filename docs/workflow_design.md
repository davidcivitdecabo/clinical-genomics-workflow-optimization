## Workflow Design and Components

This repository is organized as a modular clinical genomics workflow designed to explore, benchmark, and document analytical strategies relevant to rare disease diagnostics.

The workflow is structured into independent analytical modules that can be executed, evaluated, or replaced separately. This modular design facilitates reproducibility, comparative benchmarking, and future integration of alternative tools without affecting the overall workflow architecture.

The project encompasses three complementary analytical areas:

### Structural Variant Analysis

Structural variants (SVs) represent an important source of genetic variation associated with rare diseases, but their detection remains challenging due to the diversity of event types, genomic contexts, and breakpoint complexities.

To address these challenges, the workflow proposes the integration of two complementary SV callers:

- **Manta** — a structural variant caller based on local assembly and paired-read evidence, optimized for detecting deletions, duplications, inversions, and other complex rearrangements.
- **LUMPY** — a probabilistic framework that integrates split-read and paired-end signals to improve sensitivity and breakpoint resolution.

The objective of this module is to explore how complementary SV detection strategies could improve the identification and interpretation of genomic rearrangements that may be missed by conventional small-variant analysis pipelines.

This component is included as a workflow design proposal and was not benchmarked using clinical datasets within the scope of this repository.

### Mitochondrial DNA Analysis

Mitochondrial disorders represent an important subset of rare diseases, yet mitochondrial DNA (mtDNA) analysis is not systematically incorporated into many standard genomic workflows.

To address this gap, the workflow proposes the integration of:

- **eKLIPse** — a tool designed for the detection of mtDNA deletions, rearrangements, and heteroplasmy estimation from next-generation sequencing data.

The inclusion of mtDNA analysis aims to extend diagnostic coverage beyond nuclear genomic variation and provide additional evidence for the interpretation of mitochondrial disorders.

This module documents how mtDNA analysis could be incorporated into a clinical genomics workflow, including expected inputs, outputs, and interpretation considerations.

As with the SV module, no benchmarking using real clinical datasets was performed for this component.

### Variant Prioritization

Variant prioritization is one of the most critical and time-consuming stages of rare disease genomic diagnostics, requiring the integration of phenotypic and genomic evidence to identify clinically relevant candidate variants.

The variant prioritization module is implemented through a set of modular Bash scripts that automate three complementary prioritization approaches and result integration workflows:

- **Exomiser** — combines variant pathogenicity predictions with phenotype similarity analysis using Human Phenotype Ontology (HPO) annotations.
- **LIRICAL** — applies a likelihood-ratio framework to rank candidate diagnoses and associated variants based on phenotype-genotype evidence.
- **AMELIE** — uses automated literature mining to identify phenotype-relevant gene-disease associations. The workflow supports both gene-list prioritization and an experimental VCF-based mode.

The main execution scripts are:

- `run_analysis.sh` — execution of selected prioritization profiles on user-defined samples.
- `run_benchmark.sh` — systematic benchmarking of all predefined prioritization profiles.
- `integration.sh` — integration and filtering of Exomiser and LIRICAL results.

Different filtering strategies and parameter configurations were explored to identify prioritization approaches capable of reducing the number of variants requiring manual review while maintaining recovery of known pathogenic variants.

#### Integration and Filtering Strategy

Custom Bash scripts were developed to facilitate systematic comparison of prioritization outputs generated under different configurations.

These scripts support:

- Integration of Exomiser and LIRICAL candidate rankings
- Generation of merged prioritization tables
- Construction of reduced candidate lists for manual review
- Application of configurable filtering criteria
- Generation standardized outputs that facilitate downstream benchmarking and comparative evaluation of prioritization strategies.

The primary objective was to determine which configurations most effectively prioritized previously validated disease-causing variants while minimizing the risk of excluding clinically relevant candidates during filtering.

#### Clinical Benchmarking

Unlike the SV and mtDNA modules, the variant prioritization component was evaluated using real clinical datasets from previously diagnosed rare disease cases.

The benchmarking strategy focused on:

- Assessing the ranking position of known pathogenic variants
- Comparing prioritization performance across multiple configurations
- Evaluating the impact of filtering strategies on variant ranking
- Identifying approaches that consistently retained causal variants among top-ranked candidates

To preserve patient confidentiality, no clinical datasets, phenotypic records, or variant-level information are included in this repository.

#### Modular Workflow Architecture

The workflow was intentionally designed as a collection of independent analytical modules rather than a monolithic pipeline.

This architecture enables:

- Independent benchmarking of analytical components
- Replacement or addition of alternative tools
- Reproducible evaluation of different strategies
- Clear separation between workflow design, benchmarking, and documentation

The resulting framework serves both as a workflow optimization proposal and as a practical benchmarking environment for evaluating analytical approaches relevant to rare disease genomics.

This modular architecture also allows independent execution of benchmarking (`run_benchmark.sh`) and targeted analysis (`run_analysis.sh`) workflows using the same configuration framework.

