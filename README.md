# MSR Security Awareness

A reproduction of research paper focusing on security perception of Python & JS open source communities.

##  Metadata 

A reproduction of a following Mining Software Repository(MSR) research paper as part of the MSR course 2020/21 at UniKo, CS department, SoftLang Team:  

"Exploring the Security Awareness of the Python and JavaScript Open Source Communities"[1][2] by Gábor Antal, Márton Keleti & Péter Hegedűs.

The Code[7] & Dataset[4][5] were licensed as [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/legalcode) by research paper authors.

This project is licensed under the [GNU GPLv3](LICENSE.md).

# Research Questions:

- RQ1- Typical Security Issue Types
- RQ2- Reaction Times to Security Issues 

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

- Terms:
    - CVE (Common Vulnerabilities and Exposures)
    - CWE (Common Weakness Enumeration)
    - Delta (Average number of days between mitigation commit date and CVE publish date)

- Input data:
    - Software Heritage Graph Dataset - **[Popular 4k](data/popular-4k)**
- Temporary data:
    - NIST NVD
    - CVE related problems
- Output data:
    - result_js.csv - contains git_hash,commit_date,cve_data,cwe_group,published_date,severity,impact_score for Javascript
    - result_py.csv - contains git_hash,commit_date,cve_data,cwe_group,published_date,severity,impact_score for Python
    - count_cwe_groups_js.csv - contains CWE & its counts for Javascript
    - count_cwe_groups_js.csv - contains CWE & its counts for Python
    - CVE (Common Vulnerabilities and Exposures)
    - CWE (Common Weakness Enumeration)
- Schema:
    - [Relational schema](https://docs.softwareheritage.org/devel/swh-dataset/graph/schema.html)


## Delta

- Process delta:

The methods used in original and re-production work are similar. Due to bugs in the code I had to make several modifications in the implementation and execution of the proccess. The changes and issues are listed below:

The Original Dataset can't be used due to it's size ~1.2TB, I had to search in docs[6] and I found smaller dataset named 'popular-4k' which was sized around ~30GB compressed.

The Original SQL import script(data/popular-4k/load.sql) was using zcat which isn't very popular tool so I changed it with gzip. The script was taking too much time for execution(~4-5 Hours) because it was creating a gin index(database indexes which can make search faster) which in my opinion was not very useful as I was already using smaller dataset so I created additional loading script which does not create gin indexes. I searched for several ways to speed up the execution and I tried changing several databse configrations and eventually I found one that fits best.

Then I have to use cve_manager which can download NIST NVD and parse data from it and create `cve_related_problems.csv` (CVE to CWE list) which had issues while writing down output, so I modified the code and also sent a PR fixing it. 

Now comes using original code(process/code/original) which had several bugs and code can not be executed without fixing them - few of them were listed in file update_cve.ipynb as "# Bug Fixed". It was interesting that there were bugs while creating statistics 1-5.


- Data delta:

1. Input data - I used smaller dataset as Original Dataset can't be used due to it's size ~1.2TB.
2. Temp Data - Downloading & Parsing NIST NVD created similar result.
3. Output Data -
As I used smaller dataset it is very obvious that results will be not same, I have answered RQ1 & RQ2 in process/code/update_cve.ipynb
For Research Question 1 - I found nearly similar result and CWE-200 & CWE-185 were common among both Python and Javascript.
For Research Question 2 - Results were opposite, it takes average 89 days for python and 21 days for JavaScript comminities to fix a vulnerablity.


## References

1. [DBLP:conf/msr/AntalKH20](https://dblp.org/rec/conf/msr/AntalKH20.html?view=bibtex)
2. [arXiv:2006.13652 [cs.SE]](https://arxiv.org/abs/2006.13652)
3. https://2020.msrconf.org/details/msr-2020-mining-challenge/3/Exploring-the-Security-Awareness-of-the-Python-and-JavaScript-Open-Source-Communities
4. [Software Heritage Graph Dataset](https://annex.softwareheritage.org/public/dataset/)
5. [Software Heritage Graph Dataset](https://zenodo.org/record/2583978)
6. [Software Heritage Graph Dataset Documentation](https://docs.softwareheritage.org/devel/swh-dataset/graph/dataset.html)
7. [Code](https://zenodo.org/record/3699486)
8. [CVE manager](https://github.com/aatlasis/cve_manager)