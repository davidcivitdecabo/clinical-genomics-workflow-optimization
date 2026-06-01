# Project Summary

This repository presents a modular clinical genomics workflow focused on rare disease diagnostics and workflow optimization.

The project combines:

* Structural variant analysis proposals using Manta and LUMPY
* Mitochondrial DNA analysis integration using eKLIPse
* Optimization of phenotype-driven variant prioritization strategies to improve diagnostic efficiency in rare disease genomics

A major challenge in rare disease genomics is the large number of candidate variants that require manual review after sequencing.

This project explored whether phenotype-driven prioritization tools could be combined and optimized to reduce interpretation burden while maintaining diagnostic performance.

The prioritization benchmarking study evaluated 232 pathogenic variants from 214 previously diagnosed patients.

Key findings include:

* Recovery of up to 221 pathogenic variants using optimized Exomiser configurations.
* Stable prioritization performance across LIRICAL filtering strategies.
* Evaluation of literature-based prioritization using AMELIE.
* Development of a combined Exomiser-LIRICAL filtering strategy recovering 199 (85.78%) causal variants while limiting manual review to only 15 candidate variants per case.

The repository emphasizes reproducibility, benchmarking methodology, workflow modularity, and practical challenges encountered in clinical rare disease genomics.
