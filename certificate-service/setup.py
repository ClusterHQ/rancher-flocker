from setuptools import setup

setup(
    name="FlockerCertificateServer",
    version="0.1",
    description=("""
    Server for transforming data from Catalog Agents and passing it on
    to the ClusterHQ SaaS Volume Catalog's search database.
    """),
    author="ClusterHQ, Inc.",
    author_email="flocker-users@clusterhq.com",
    url="https://github.com/ClusterHQ/volume-catalog",
    entry_points={
        "console_scripts": [
            "flocker-certificate-service = flocker_certificate_service:api.main",
        ],
    },
    install_requires=[
        "Twisted>=14",
        "treq>=14",
        "pyasn1>=0.1",
        "pyrsistent>=0.11.9",
        "eliot>=0.9.0",
        "streql",
    ],
)
