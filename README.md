# MSR Security Awareness

A reproduction of research paper focusing on security perception of Python & JS open source communities.

##  Metadata 

A reproduction of a following Mining Software Repository(MSR) research paper as part of the MSR course 2020/21 at UniKo, CS department, SoftLang Team:  

"Exploring the Security Awareness of the Python and JavaScript Open Source Communities"[1][2] by Gábor Antal, Márton Keleti & Péter Hegedűs.

The Code[7] & Dataset[4][5] were licensed as [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/legalcode) by research paper authors.

This project is licensed under the [GNU GPLv3](LICENSE.md).

## Requirements 

- Hardware
    - Minimum Requirements:  
        - **OS**: Windows / Linux
        - **Processor**: Intel Core i5-3570K 3.4GHz / AMD FX-8310
        - **Memory**: 4 GB RAM
        - **Storage**: 70 GB Hard drive space

    - **Recommended Requirements**:  
        - **OS**: Windows / Linux
        - **Processor**:  Intel Core i7-4790 4-Core 3.6GHz / AMD Ryzen 3 3200G
        - **Memory**: 8/16 GB RAM
        - **Storage**: 70 GB **SSD** space

- Software
    - [Python 3.x](https://www.python.org/downloads/)
    - Gzip & wget(recommended) / curl
        - For Windows OS use [Git For Windows](https://git-scm.com/download/win)
    - [PostgreSQL 13](https://www.postgresql.org/download/) - [Direct Download](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)


## Process

- Steps:
    - Please Check [INSTALLATION.md](doc/INSTALLATION.md)

## Data

- Input data:
    - Software Heritage Graph Dataset - **[Popular 4k](data/popular-4k)**
    - NIST NVD
- Temporary data:
    - CVE related problems
- Output data:
    - CVE (Common Vulnerabilities and Exposures)
    - CWE (Common Weakness Enumeration)
- Schema:
    - [Relational schema](https://docs.softwareheritage.org/devel/swh-dataset/graph/schema.html)


## Delta

- Process delta:

- Data delta:

## References

1. [DBLP:conf/msr/AntalKH20](https://dblp.org/rec/conf/msr/AntalKH20.html?view=bibtex)
2. [arXiv:2006.13652 [cs.SE]](https://arxiv.org/abs/2006.13652)
3. https://2020.msrconf.org/details/msr-2020-mining-challenge/3/Exploring-the-Security-Awareness-of-the-Python-and-JavaScript-Open-Source-Communities
4. [Software Heritage Graph Dataset](https://annex.softwareheritage.org/public/dataset/)
5. [Software Heritage Graph Dataset](https://zenodo.org/record/2583978)
6. [Software Heritage Graph Dataset Documentation](https://docs.softwareheritage.org/devel/swh-dataset/graph/dataset.html)
7. [Code](https://zenodo.org/record/3699486)
8. [CVE manager](https://github.com/aatlasis/cve_manager)