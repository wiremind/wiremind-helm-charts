#!/usr/bin/python3
import datetime
import socket
import time
from typing import List

import click
import requests
import yaml


def generate_silence_cr(*, name: str, cluster: str, provider: str, owner: str, matchers: List[dict]) -> dict:
    return {
        "apiVersion": "monitoring.giantswarm.io/v1alpha1",
        "kind": "Silence",
        "metadata": {
            "name": name
        },
        "spec": {
            "targetTags": [
                {
                    "name": "cluster",
                    "value": cluster
                },
                {
                    "name": "provider",
                    "value": provider
                },
            ],
            "owner": owner,
            "matchers": matchers
        }
    }


@click.command()
@click.option('--alertmanager-api-url', default="http://alertmanager-operated.monitoring:9093/api/v2", show_default=True)
@click.option('--alertmanager-cluster-name', default="kind", show_default=True)
@click.option('--alertmanager-provider-name', default="local", show_default=True)
def run(alertmanager_api_url: str, alertmanager_cluster_name: str, alertmanager_provider_name: str):
    res = requests.get(f"{alertmanager_api_url}/silences")

    res.raise_for_status()
    silences = res.json()

    for silence in silences:
        if silence["status"]["state"] == "active":
            silence_cr = generate_silence_cr(name=silence["id"], cluster=alertmanager_cluster_name, provider=alertmanager_provider_name, owner=silence["createdBy"], matchers=silence["matchers"])
            silence_cr_yaml = yaml.dump(silence_cr, sort_keys=True)
            print(f"# Owner: {silence['createdBy']}")
            print(f"# Comment: {silence['comment']}")
            print(silence_cr_yaml)
            print("---")

if __name__ == "__main__":
    run()
