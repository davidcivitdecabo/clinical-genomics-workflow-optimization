#!/usr/bin/env python3

import json
import os
import requests
import urllib3

urllib3.disable_warnings(
    urllib3.exceptions.InsecureRequestWarning
)

url = os.environ["AMELIE_VCF_API"]

sample = os.environ["SAMPLE"]
hpos = os.environ["HPOS"]
vcf_file = os.environ["VCF_FILE"]
output_file = os.environ["OUTPUT_FILE"]

if not os.path.isfile(vcf_file):

    raise FileNotFoundError(
        f"VCF file not found: {vcf_file}"
    )

if not hpos.strip():

    raise ValueError(
        "Empty phenotype list"
    )

with open(vcf_file, "rb") as vcf:

    response = requests.post(
        url,
        verify=False,
        timeout=300,
        files={
            "vcfFile": vcf
        },
        data={
            "dominantAlfqCutoff": 0.1,
            "alfqCutoff": 0.5,
            "filterByCount": False,
            "hmctCutoff": 1,
            "alctCutoff": 3,
            "patientName": sample,
            "patientSex": None,
            "onlyPassVariants": True,
            "filterRelativesOnlyHom": False,
            "phenotypes": hpos
        }
    )

response.raise_for_status()

try:

    result = response.json()

except Exception:

    raise RuntimeError(
        f"AMELIE returned a non-JSON response:\n"
        f"{response.text[:500]}"
    )

with open(output_file, "w") as out:

    json.dump(
        result,
        out,
        indent=4
    )

print(
    f"[INFO] AMELIE results written to {output_file}"
)
