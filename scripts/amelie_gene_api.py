#!/usr/bin/env python3

import json
import os
import requests

URL = "https://amelie.stanford.edu/api/gene_list_api/"

sample = os.environ["SAMPLE"]
hpos = os.environ["HPOS"]
gene_file = os.environ["GENE_FILE"]
output_file = os.environ["OUTPUT_FILE"]

with open(gene_file) as f:
    genes = ",".join(
        line.strip()
        for line in f
        if line.strip()
    )

response = requests.post(
    URL,
    verify=False,
    data={
        "patientName": sample,
        "phenotypes": hpos,
        "genes": genes
    }
)

with open(output_file, "w") as out:
    json.dump(
        response.json(),
        out,
        indent=4
    )
