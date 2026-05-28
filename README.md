# Clinical Genomics Workflow Optimization

Improving clinical genomics workflows by evaluating and optimizing tools for structural variant analysis, mitochondrial DNA analysis, and diagnostic variant prioritization.

---

## 1. Overview

This repository presents a modular and reproducible workflow for evaluating key components of clinical genomics pipelines in the context of rare disease diagnosis.

It integrates tools for structural variant detection (Manta, LUMPY), mitochondrial DNA analysis (eKLIPse), and exome variant prioritization (Exomiser, LIRICAL, AMELIE) to compare different strategies for improving diagnostic interpretation.

The project is based on professional experience within a clinical genomics service at a reference hospital, where several workflow optimizations were proposed to enhance diagnostic efficiency, reproducibility, and scalability.

Although no real patient data is included, the workflow design and evaluation framework are grounded in real-world clinical genomics practice.

## 2. Clinical Motivation

Clinical genomics laboratories face increasing pressure to deliver accurate and interpretable results within tight diagnostic timelines.
Rare disease diagnostics remains one of the major challenges in this field due to the extreme heterogeneity of genomic variants and the limitations of standard analysis pipelines.

Accurate structural variant detection, precise breakpoint characterization, identification of mitochondrial DNA rearrangements, and effective phenotype-driven variant prioritization represent critical components for improving diagnostic yield and clinical interpretation. These challenges make it necessary to optimize workflows and select the most appropriate bioinformatics tools for each analytical step.

During my work in a hospital genomics environment, I identified several opportunities to improve:
- Integration of complementary structural variant callers
- Detection and interpretation of mitochondrial DNA alterations
- Phenotype-driven genomic variant prioritization
- Reproducibility and scalability of diagnostic workflows

This project reflects the evaluation of these components as part of a proposed strategy to improve workflow efficiency and clinical diagnostic

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

This scripts enable:

- Integration of candidate rankings across prioritization tools
- Application of customizable filtering thresholds
- Comparative benchmarking under different parameter configurations
- Evaluation of reproducibility and prioritization consistency

The modular design of the workflow facilitates adaptation to different clinical scenarios, analytical requirements, and diagnostic strategies.

## 4. Tools and Methods



## 5. Repository Structure

## 6. Example Outputs

## 7. Proposed Improvements

## 8. Limitations

## 9. Future Work

## 10. Author
