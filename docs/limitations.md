# Methodological Limitations

The workflow presented in this repository is intended as a methodological and benchmarking framework. While it reflects analytical strategies relevant to clinical genomics, several limitations should be considered when interpreting the results and proposed workflow components.

---

## Structural Variant and mtDNA Modules as Conceptual Workflow Components

The structural variant (Manta and LUMPY) and mitochondrial DNA (eKLIPse) modules were included as workflow optimization proposals inspired by challenges identified in clinical genomics practice.

However:

* No benchmarking was performed using real patient datasets.
* No comparative evaluation between alternative SV or mtDNA tools was conducted.
* No clinical validation was performed for structural variant or mitochondrial DNA detection performance.

Consequently, these modules should be interpreted as conceptual workflow components rather than validated analytical implementations.

---

## Variant Prioritization Study Based on Previously Diagnosed Cases

The only workflow component evaluated using real clinical datasets was the variant prioritization module.

The benchmarking study used previously diagnosed cases for which the causal variant was already known. This design enabled:

* Execution of Exomiser and LIRICAL under multiple configurations.
* Application of alternative filtering strategies.
* Assessment of how different configurations affected the ranking of known pathogenic variants.

The resulting analyses therefore focused on:

* Ranking positions assigned to known causal variants.
* Ranking stability across prioritization configurations.
* Effects of filtering strategies on candidate prioritization.

Although this approach provides a controlled framework for benchmarking prioritization strategies, it may not fully reflect the complexity of unresolved diagnostic cases encountered in routine clinical practice.

---

## Historical Nature of the Benchmarking Results

The benchmarking analyses were performed using tool versions, annotation resources, and databases available at the time of the original study.

Since then:

* Software versions have evolved.
* Reference databases have been updated.
* New gene-disease associations have become available.

Consequently, the results presented in this repository should be interpreted primarily as methodological and historical observations rather than as indicators of current tool performance.

---

## AMELIE Integration Constraints

Integration of AMELIE into the prioritization workflow was limited by privacy considerations associated with the use of an external platform.

As a result:

* Full phenotype-driven prioritization using patient-level variant and phenotype data was not performed.
* AMELIE analyses were restricted to gene-level evaluation.
* Validation was conducted only on a subset of cases.

This limitation prevented direct comparison between AMELIE, Exomiser, and LIRICAL under identical analytical conditions and excluded AMELIE from the final integrated prioritization workflow.

---

## Limited Benchmarking Scope

The benchmarking study was intentionally focused on prioritization behavior and configuration assessment.

The analyses do not include:

* Large-scale cohort validation.
* Precision, recall, sensitivity, or specificity metrics.
* Runtime or computational resource benchmarking.
* Prospective diagnostic evaluation.
* Integration with downstream clinical interpretation workflows.

The primary objective was to assess ranking behavior under different prioritization and filtering strategies.

---

## Data Availability and Privacy Considerations

Although real clinical datasets were used during the internal evaluation:

* No patient data are included in this repository.
* No phenotype-level information is provided.
* No variant-level clinical information is shared.
* Only aggregated methodological observations and benchmarking results are reported.

These measures ensure compliance with privacy, confidentiality, and data protection requirements.

---

## Scope of Interpretation

The results presented in this repository should be interpreted as an evaluation of workflow behavior and methodological choices rather than as a definitive assessment of tool performance.

The primary objective was to explore how different analytical configurations influence prioritization outcomes and workflow design decisions within a clinical genomics setting.

Accordingly, the repository should be viewed as a framework for workflow evaluation, benchmarking, and optimization rather than as a fully validated clinical diagnostic pipeline.
