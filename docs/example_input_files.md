# Example Input Files

The `examples/` directory contains two synthetic sample folders that illustrate the input files required to execute the variant prioritization workflows included in this repository.

These files are provided to facilitate workflow understanding, testing, and reproducibility without requiring access to clinical datasets.

## Included Example Files per Sample

| File                                     | Description                                                                                                       |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `HPO_terms.txt`                          | Human Phenotype Ontology (HPO) terms associated with the sample, one term per line                                |
| `(sample name).vcf`                      | Input VCF used by AMELIE VCF mode (`amelie_vcf.sh`) using hg19 coordinates                                        |
| `(sample name)_filtered_sorted_hg38.vcf` | Input VCF used by Exomiser and LIRICAL analyses (hg38 coordinates)                                                |
| `(sample name)_gnomad_values_hg38.txt`   | gnomAD allele frequency annotations corresponding to variants present in `(sample name)_filtered_sorted_hg38.vcf` |
| `gene_list.txt`                          | List of genes containing variants identified in the sample                                                        |
| `gene_list_filtered.txt`                 | Filtered version of `gene_list.txt` used by selected AMELIE configurations                                        |

## Intended Uses

The example files can be used to:

* Understand the input requirements of each prioritization tool
* Test workflow execution using synthetic data
* Validate integration and filtering scripts included in the repository
* Verify file formats expected by Exomiser, LIRICAL, and AMELIE
* Serve as templates when adapting the workflow to additional datasets

## Data Privacy

No real patient data are included in this repository.

The example input files were generated exclusively for demonstration purposes and contain synthetic data designed to mimic the structure of files commonly produced during a clinical exome analysis workflow while preserving patient confidentiality.

This approach allows the workflow to be shared, reproduced, and extended without exposing sensitive clinical information.
