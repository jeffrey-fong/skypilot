"""Runpod configuration bootstrapping."""

from sky.provision import common


def bootstrap_instances(
        region: str, cluster_name: str,
        config: common.ProvisionConfig) -> common.ProvisionConfig:
    """Bootstraps instances for the given cluster."""
    del region, cluster_name  # unused
    if config.protocol is None:  # default to tcp
        config.protocol = 'tcp'
    return config
