#!/usr/bin/env python3

import json
import os
import requests
import urllib3

urllib3.disable_warnings(
    urllib3.exceptions.InsecureRequestWarning
)

url = os.environ["AMELIE_GENE_API"]

sample = os.environ["SAMPLE"]
hpos = os.environ["HPOS"]
gene_file = os.environ["GENE_LIST_FILE"]
output_file = os.environ["OUTPUT_FILE"]

with open(gene_file) as f:

    genes = ",".join(
        line.strip()
        for line in f
        if line.strip()
    )

if not genes:

    raise ValueError(
        f"No genes found in {gene_file}"
    )

response = requests.post(
    url,
    verify=False,
    timeout=300,
    data={
        "patientName": sample,
        "phenotypes": hpos,
        "genes": genes
    }
)

response.raise_for_status()

with open(output_file, "w") as out:

    json.dump(
        response.json(),
        out,
        indent=4
    )

print(
    f"[INFO] AMELIE results written to {output_file}"
)
