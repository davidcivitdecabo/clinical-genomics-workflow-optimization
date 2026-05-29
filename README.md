# Clinical Genomics Workflow Optimization

Improving clinical genomics workflows by evaluating and optimizing tools for structural variant analysis, mitochondrial DNA analysis, and diagnostic variant prioritization.

---

## 1. Overview

This repository presents a modular and reproducible workflow for evaluating key components of clinical genomics pipelines in the context of rare disease diagnosis.

It integrates tools for structural variant detection (Manta, LUMPY), mitochondrial DNA analysis (eKLIPse), and exome variant prioritization (Exomiser, LIRICAL, AMELIE) to compare different strategies for improving diagnostic interpretation.

The project is based on professional experience within a clinical genomics service at a reference hospital, where several workflow optimizations were proposed to enhance diagnostic efficiency, reproducibility, and scalability.

Although no real patient data is included, the workflow design and evaluation framework are grounded in real-world clinical genomics practice.

### Key Features

- Modular workflow design for rare disease genomics
- Comparative benchmarking of variant prioritization strategies
- Structural variant and mtDNA workflow integration proposals
- Reproducible organization of analytical components
- Real clinical benchmarking context using previously diagnosed cases
- Privacy-conscious workflow evaluation

## 2. Clinical Motivation

Clinical genomics laboratories face increasing pressure to deliver accurate and interpretable results within tight diagnostic timelines.
Rare disease diagnostics remains one of the major challenges in this field due to the extreme heterogeneity of genomic variants and the limitations of standard analysis pipelines.

Accurate structural variant detection, precise breakpoint characterization, identification of mitochondrial DNA rearrangements, and effective phenotype-driven variant prioritization represent critical components for improving diagnostic yield and clinical interpretation. These challenges make it necessary to optimize workflows and select the most appropriate bioinformatics tools for each analytical step.

During my work in a hospital genomics environment, I identified several opportunities to improve:
- Integration of complementary structural variant callers
- Detection and interpretation of mitochondrial DNA alterations
- Phenotype-driven genomic variant prioritization
- Reproducibility and scalability of diagnostic workflows

This project reflects the evaluation of these components as part of a proposed strategy to improve workflow efficiency and clinical diagnostics

## 3. Workflow Design and Components

The repository is organized as a modular clinical genomics workflow designed to evaluate different analytical strategies relevant to rare disease diagnostics. Each module operates independently and can be executed, benchmarked, or replaced without affecting the rest of the workflow, enabling transparent comparison of alternative approaches.

The workflow is structured into three main analytical blocks:

### 3.1 Structural Variant Analysis
Structural variant (SV) detection was explored using two complementary callers:

- **Manta**: optimized for germline and somatic SV detection, providing high sensitivity for deletions, duplications, and inversions.
- **LUMPY**: a probabilistic framework that integrates split‑read and paired‑end evidence to improve structural variant detection and breakpoint resolution.

Both tools are executed independently, allowing their outputs to be compared or integrated to assess concordance, breakpoint precision, and potential diagnostic relevance

The objective of this module is to evaluate complementary approaches for identifying large genomic rearrangements, breakpoint‑associated events, and complex structural alterations that may be missed by conventional small variant pipelines.

### 3.2 Mitochondrial DNA Analysis
Mitochondrial DNA (mtDNA) alterations were evaluated using:

- **eKLIPse**: a tool designed to detect mtDNA deletions, quantify rearrangements, and estimate heteroplasmy levels from next-generation sequencing data.

Although no real mtDNA datasets are included in this repository, the workflow documents how eKLIPse could be integrated into a clinical genomics pipeline and how its outputs may contribute to mitochondrial disorder diagnostics and variant interpretation.

### 3.3 Variant Prioritization
Exome variant prioritization was performed using three complementary tools:

- **Exomiser**: integrates variant pathogenicity scoring with phenotype similarity analysis using Human Phenotype Ontology (HPO) terms.
- **LIRICAL**: a likelihood‑ratio–based approach for phenotype‑driven prioritization.
- **AMELIE**: a literature-based prioritization system that associates patient phenotypes with gene-disease relationships extracted from scientific publications.

Different filtering strategies and parameter configurations were explored to evaluate their impact on ranking performance, reproducibility, and interpretability in a clinical context.

#### Integration and Filtering
A set of integration and filtering scripts was developed to combine and compare variant prioritization results across different tools and filtering conditions.

These scripts enable:

- Integration of candidate rankings across prioritization tools
- Application of customizable filtering thresholds
- Comparative benchmarking under different parameter configurations
- Evaluation of reproducibility and prioritization consistency

The modular design of the workflow facilitates adaptation to different clinical scenarios, analytical requirements, and diagnostic strategies.

## 4. Tools and Methods

This workflow integrates several widely used bioinformatics tools that address complementary aspects of clinical genomics analysis. Each tool was selected based on its relevance to rare disease diagnostics, its methodological strengths, and its ability to contribute meaningful evidence for variant interpretation.

### 4.1 Structural Variant Callers
Structural variant analysis was evaluated using complementary callers with different methodological approaches:

| Tool | Methodology | Main strength | Main limitation |
|------|------|------|------|
| Manta | Local assembly and discordant pair analysis | Speed ​​and accuracy in detecting complex structural variants | Sensitivity to alignment quality and limitations in repetitive regions |
| LUMPY | Multimodal probabilistic model | High sensitivity thanks to the integration of multiple alignment signals | Dependence on high-quality and complex data preparation |

These tools were chosen to explore concordance, complementary detection capabilities, and potential improvements in structural variant interpretation.

### 4.2 Mitochondrial DNA Analysis

| Tool | Methodology | Strengths | Limitations |
|------|------|------|------|
| eKLIPse | mtDNA deletion and rearrangement analysis from NGS data | Detection of mtDNA rearrangements and heteroplasmy estimation | Requires high-quality sequencing coverage |

Although no real mtDNA data is included, the workflow documents how eKLIPse would be integrated into a clinical pipeline and how its outputs contribute to diagnostic interpretation.

### 4.3 Variant Prioritization Tools

| Tool | Methodology | Strengths | Limitations |
|------|------|------|------|
| Exomiser | Phenotype + genotype, HPO similarity score and variant pathogenicity | Strong phenotype-genotype integration and combined algorithm ranking | Performance depends on phenotype annotation quality and on updated databases|
| LIRICAL | Phenotype-genotype, Likelihood ratio–based phenotype-driven prioritization | Transparent probabilistic framework and interpretable scoring | Sensitive to incomplete or imprecise HPO annotations |
| AMELIE | Literature-based prioritization using automated publication mining | Strong exploitation of published variant-disease associations | Potential literature bias toward well-characterized genes and dependent on the updating of the literature |

A set of custom scripts was developed to integrate and analyze the outputs generated by the prioritization tools.

The results obtained through variant prioritization were evaluated using real clinical cases during my work in a hospital genomics service. Only results comparing different filtering strategies and prioritization settings are included here, without specific patient information.

## 5. Repository Structure

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

## 6. Example Outputs

The `examples/` directory contains anonymized example outputs generated using the variant prioritization tools evaluated in this workflow. These files do not contain real patient data and are provided exclusively to illustrate the expected structure and format of tool outputs.

### Included Example Files

| File | Description |
|------|------|
| `exomiser_output_example.tsv` | Example candidate ranking generated using Exomiser |
| `lirical_output_example.tsv` | Example phenotype-driven prioritization output generated using LIRICAL |
| `amelie_output_example.tsv` | Example literature-based variant prioritization generated using AMELIE |

These examples are intended to support:

- Understanding of the output structure generated by each prioritization tool  
- Testing and validation of the integration and filtering scripts  
- Demonstration of the workflow without requiring clinical datasets  

The example outputs also serve as reference files for extending, benchmarking, or adapting the prioritization workflow to additional tools, datasets, or filtering strategies.

The real patient datasets used during the internal prioritization study are not included in this repository for privacy and confidentiality reasons.  

All examples provided here are synthetic and intended only to demonstrate workflow execution.


## 7. Proposed Improvements

The workflow and benchmarking strategies presented in this repository were inspired by a series of proposed improvements aimed at optimizing key components of genomic analysis within a clinical genomics service. These proposals focus on enhancing diagnostic efficiency, reproducibility, and interpretability across analytical steps that are critical for rare disease diagnostics.

The proposed improvements focused on three main areas:

### 7.1 Structural Variant Analysis
Structural variant (SV) analysis remains one of the major challenges in clinical genomics due to the complexity of detecting and interpreting large genomic rearrangements. Optimization of SV analysis strategies may significantly contribute to improving diagnostic yield in both newly analyzed cases and unresolved patients with inconclusive previous results.

The integration of complementary SV callers such as Manta and LUMPY was proposed to:

- **Benchmark complementary SV callers** to improve sensitivity for deletions, duplications, inversions, and complex rearrangements.
- **Improve breakpoint resolution accuracy** through the combined use of split-read and paired-end evidence.
- **Standardize output formats** to facilitate downstream comparison, integration, and reproducibility.
- 
### 7.2 Mitochondrial DNA Analysis
Mitochondrial DNA (mtDNA) analysis is not systematically incorporated into many standard genomic workflows despite its relevance in rare disease diagnostics. Interpretation of heteroplasmy levels and mtDNA rearrangements can be essential for achieving accurate diagnosis in mitochondrial disorders.

The integration of eKLIPse was proposed to:
- **Incorporate mtDNA structural analysis** into the routine genomic workflow.
- **Quantify mtDNA rearrangements and heteroplasmy levels** to support clinical interpretation of mitochondrial disorders.
- **Standardize and document mtDNA analytical steps** to improve reproducibility, transparency, and workflow traceability.

### 7.3 Variant Prioritization
Variant prioritization is one of the most critical and time‑consuming stages of genomic diagnostics, particularly in phenotype‑driven rare disease analysis.

The comparative evaluation of Exomiser, LIRICAL, and AMELIE was proposed to:
- **Evaluate complementary prioritization strategies** to assess ranking consistency, phenotype-genotype correlation, and diagnostic relevance.
- **Optimize prioritization and filtering configurations** to maximize ranking of potentially causal variants while minimizing the risk of excluding clinically relevant candidates.
- **Reduce manual interpretation burden** by improving ranking interpretability and prioritization consistency across tools.

#### Workflow‑Level Improvements

The modular organization proposed in this repository aims to:
- **Modularize analytical components** to facilitate independent benchmarking, reproducibility, and replacement of individual tools.
- **Maintain clear separation between configuration files, scripts, documentation, and results** to improve maintainability and workflow organization.
- **Provide example outputs and technical documentation** to support reproducibility, training, benchmarking, and future workflow extensions.

Overall, these proposed improvements aim to support the development of more transparent, scalable, reproducible, and clinically meaningful workflows for rare disease genomics diagnostics.

## 8. Limitations

The workflow presented in this repository is designed as a methodological and benchmarking framework. While it reflects real analytical strategies used in clinical genomics, several limitations must be acknowledged to contextualize its scope and applicability.

### 8.1 Structural Variant and mtDNA Modules Not Benchmark‑Tested
The modules for structural variant detection (Manta, LUMPY) and mitochondrial DNA analysis (eKLIPse) are included as proposed workflow improvements.  
However:

- No benchmarking was performed using real patient data.
- No comparative evaluation between tools was conducted.
- No clinical cases were used to validate SV or mtDNA detection performance.

These modules therefore represent **methodological proposals**, not validated analytical results.

### 8.2 Variant Prioritization Study Based on Previously Diagnosed Cases
The only component evaluated with real clinical data was the **variant prioritization module**.

The study was performed using real patient datasets for which the causal variants were already known.  
This allowed:

- Execution of Exomiser and LIRICAL under multiple configurations.
- Application of different filtering strategies.
- Comparison of how each configuration ranked the known pathogenic variant.

The final benchmarking results therefore consist of:

- The ranking positions assigned to the known causal variants.
- The effect of different configurations and filters on ranking stability.

### 8.3 Tool Versions and Databases Have Since Been Updated
The prioritization study was performed using unas versiones concretas (Exomiser v14.1.0 y Lirical v2.0.4):

- Exomiser and LIRICAL have since updated their versions.
- Underlying databases have changed.
- Ranking behavior may differ in current versions.

As a result, the benchmarking results included here should be interpreted as **historical and methodological**, not reflective of current tool performance.

### 8.4 Limitations in the Use of AMELIE Due to Privacy Constraints
Integration of AMELIE into the combined prioritization workflow was limited due to clinical data privacy considerations associated with the use of an external API.

For this reason:

- Full prioritization using patient variants and phenotypes could not be performed.
- AMELIE was executed only using:
  - the list of genes containing variants in each patient, and  
  - the known causal variant (tested in a subset of 10 patients).

This restricted the ability to compare AMELIE directly with Exomiser and LIRICAL or include it on the final combined prioritization workflow.

### 8.5 Limited Scope of Benchmarking
The prioritization benchmarking does **not** include:

- large‑scale cohort evaluation,
- possible case bias due to the data selection methodology when using data from patients with a confirmed diagnosis,
- precision/recall metrics,
- runtime or resource profiling,
- or integration with clinical interpretation workflows.

The study focuses exclusively on **ranking behavior** under different configurations.

### 8.6 No Real Patient Data Included in the Repository
Although real patient data were used during the internal evaluation:

- No clinical data are included in this repository.
- Only aggregated, anonymized, and methodological insights are provided.
- No variant‑level or phenotype‑level information from real cases is shared.

This ensures compliance with privacy and confidentiality requirements.

---

Overall, these limitations reflect the methodological and educational nature of the repository.  

Despite these limitations, the project reflects practical challenges, benchmarking strategies, and workflow optimization approaches commonly encountered in rare disease clinical genomics environments.

The workflow is intended as a **framework for evaluating analytical strategies**, not as a fully validated clinical pipeline.

## 9. Future Work

Several extensions and methodological improvements could be incorporated into this workflow in future developments.

### 9.1 Structural Variant and mtDNA Analysis
Although the SV and mtDNA modules are currently included as methodological proposals, future work could involve:

- **Benchmarking SV callers** using real or publicly available datasets.
- **Evaluating mtDNA detection performance** using synthetic or simulated datasets that model heteroplasmy and rearrangements.
- **Integrating additional SV tools** to broaden comparative analysis.
- **Incorporating QC metrics** for coverage, read support, and breakpoint confidence.

These steps would help transition the modules from conceptual proposals to validated analytical components.

### 9.2 Expanded Variant Prioritization Benchmarking
The prioritization study could be extended by:

- **Including larger cohorts** to evaluate ranking stability across diverse phenotypes.
- **Testing updated versions** to assess changes in performance due to database updates.
- **Exploring ensemble prioritization strategies**, combining evidence from multiple tools.
- **Incorporating phenotype simulation frameworks** to systematically evaluate prioritization robustness.

These extensions would strengthen the benchmarking framework while maintaining patient confidentiality.

### 9.3 Workflow Automation and Reproducibility
To improve scalability and reproducibility, future versions of the workflow could include:

- **Migration to workflow managers** such as Nextflow or Snakemake.
- **Containerization** using Docker or Singularity to ensure environment consistency.
- **Automated logging and error handling** for more robust execution.
- **Version‑controlled resource management**, including reference genomes and annotation databases.

These improvements would facilitate deployment in research or clinical‑adjacent environments.


### 9.4 Integration of Additional Interpretation Layers
Future enhancements could incorporate:

- **ACMG rule‑based classification frameworks**.
- **Gene‑level constraint metrics**.
- **Phenotype refinement tools** to improve HPO term selection.
- **Automated report‑ready summaries** for downstream interpretation.

These additions would help bridge the gap between variant ranking and clinical interpretation.

---

Overall, these future directions aim to evolve the workflow into a more comprehensive, scalable, and clinically aligned framework while maintaining strict privacy and reproducibility standards.

## 10. Author

This project was developed as part of a personal and professional portfolio focused on clinical bioinformatics, rare disease genomics, and workflow optimization.

The repository reflects experience in:

* Clinical genomics workflows
* Rare disease variant interpretation
* Bioinformatics benchmarking and workflow evaluation
* Variant prioritization strategies
* Molecular laboratory and diagnostic environments

Author background:

* BSc in Biology
* MSc in Bioinformatics and Biostatistics
* Professional experience in bioinformatics and molecular laboratory environments

The objective of this repository is to document practical workflow evaluation strategies and contribute to reproducible and transparent approaches in clinical genomics analysis.
