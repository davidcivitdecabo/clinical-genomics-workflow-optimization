#!/usr/bin/env python3

import json
import os
import requests

URL = "https://amelie.stanford.edu/api/vcf_api/"

sample = os.environ["SAMPLE"]
hpos = os.environ["HPOS"]
vcf_file = os.environ["VCF_FILE"]
output_file = os.environ["OUTPUT_FILE"]

response = requests.post(
    URL,
    verify=False,
    files={
        "vcfFile": open(vcf_file, "rb")
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

with open(output_file, "w") as out:
    json.dump(
        response.json(),
        out,
        indent=4
    )
