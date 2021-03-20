# MSR Security Awareness

A reproduction of research paper focusing on security perception of Python & JS open source communities.


# BaseLine:
##  Metadata 

A reproduction of a following Mining Software Repository(MSR) research paper as part of the MSR course 2020/21 at UniKo, CS department, SoftLang Team:  

**"Exploring the Security Awareness of the Python and JavaScript Open Source Communities"**[1][2] by **Gábor Antal**, **Márton Keleti** & **Péter Hegedűs**.

The Code[7] & Dataset[4][5] were licensed as [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/legalcode) by research paper authors.

This project is licensed under the [GNU GPLv3](LICENSE.md).

# Research Questions:

- **RQ1**- Typical Security Issue Types
- **RQ2**- Reaction Times to Security Issues 

## Requirements 

- **Hardware**
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

- **Software**
    - [Python 3.x](https://www.python.org/downloads/)
    - Gzip & wget(recommended) / curl
        - For Windows OS use [Git For Windows](https://git-scm.com/download/win)
    - [PostgreSQL 13](https://www.postgresql.org/download/) - [Direct Download](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)


## Process

- **Steps**:
    - Please Check [INSTALLATION.md](doc/INSTALLATION.md)

- **Validation**:
    - Output files are generated in csv containing self explaining tiltes in "data/results" folder.
    - Please Check Graphs, Outputs and comments in Jupyter Notebook - [process/code/update_cve.ipynb](process/code/update_cve.ipynb)
        - Statistics 1 to 5 is Highly recommended to check to get idea what is output and compare answers of Research Questions 1 & 2.

## Data

- **Terms**:
    - CVE (Common Vulnerabilities and Exposures) - In simple terms, it is an ID given to security issue/Vulnerability
    - CWE (Common Weakness Enumeration) - Group of CVE
    - Delta - Average number of days between mitigation commit date and CVE publish date

- **Input data**:
    - Software Heritage Graph Dataset - **[Popular 4k](https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/)**

- **Temporary data**:
    - [NIST NVD](data/nvd)(National Vulnerability Database) - Vulnerablity information - Published Date, Impact Score, CVE, CWE
    - [cve_related_problems.csv](data/cve_parsed/cve_related_problems.csv) - CVE and its related CWE list
    - [cve_cvss_scores.csv](data/cve_parsed/cve_cvss_scores.csv) - Contains CVE, Attack Complexity, Attack Vector, Exploitability Score, Impact Score, severity, Description, Published Date, Last Modified Date etc.

- **Output data**:
    - **Graphs & Statistics** -> Please check [update_cve.ipynb](process/code/update_cve.ipynb)
    - data/results folder -> Contains CSV with self explanatory titles
    - [result_js.csv](data/results/result_js.csv) & [result_py.csv](data/results/result_py.csv) - contains git_hash,commit_date,cve_data,cwe_group,published_date,severity & impact_score for Python and Javascript Projects
    - [count_cwe_groups_js.csv](data/results/count_cwe_groups_js.csv) & [count_cwe_groups_py.csv](data/results/count_cwe_groups_py.csv) - contains CWE & its counts for Python and Javascript Projects
    - [count_cwe_groups_by_year_js.csv](data/results/count_cwe_groups_by_year_js.csv) & [count_cwe_groups_by_year_py.csv](data/results/count_cwe_groups_by_year_py.csv) - contains CWE, counts(of Vulneablity Under CWE) and Years for Python and Javascript Projects
    - [yearly_commits_js.csv](data/results/yearly_commits_js.csv) & [yearly_commits_py.csv](data/results/yearly_commits_py.csv) - contains Vulnerability Counts Per year (summerized version of count_cwe_groups_by_year_js.csv)

- **Schema**:
    - The Dataset have little bit complex [Relational schema](https://docs.softwareheritage.org/devel/swh-dataset/graph/schema.html), So it is recommended to learn more about it on offical documentation.


## Delta

- **Process delta**:

    The methods used in original and re-production work are similar. Due to bugs in the code I had to make several modifications in the implementation and execution of the proccess. The changes and issues are listed below:

    The Original Dataset can't be used due to it's size ~1.2TB, I had to search in docs[6] and I found smaller dataset named 'popular-4k' which was sized around ~30GB compressed.

    The Original SQL import script(data/popular-4k/load.sql) was using zcat which isn't very popular tool so I changed it with gzip. The script was taking too much time for execution(~4-5 Hours) because it was creating a gin index(database indexes which can make search faster) which in my opinion was not very useful as I was already using smaller dataset so I created additional loading script which does not create gin indexes. I searched for several ways to speed up the execution and I tried changing several databse configrations and eventually I found one that fits best.

    Then I have to use cve_manager which can download NIST NVD and parse data from it and create `cve_related_problems.csv` (CVE to CWE list) which had issues while writing output, so I modified the code and also sent a PR fixing it. 

    Now comes using original code(process/code/original) which had several bugs and code can not be executed without fixing them - few of them were listed in file update_cve.ipynb as "# Bug Fixed". It was interesting that there were bugs while creating statistics 1-5.


- **Data delta**:

    1. **Input data** - I used smaller dataset as Original Dataset can't be used due to it's size ~1.2TB.
    2. **Temporary Data** - Downloading & Parsing NIST NVD created similar result.
    3. **Output Data** - As I used smaller dataset it is very obvious that results will be not same, I have answered RQ1 & RQ2 in process/code/update_cve.ipynb  
    For Research Question 1 - I found nearly similar result and CWE-200 & CWE-185 were common among both Python and Javascript.  
    For Research Question 2 - Results were opposite, it takes average 89 days for python and 21 days for JavaScript comminities to fix a vulnerablity.

# Experiment:

## Threat:

Some project may have been wrongly identified or might have neglected some projects due the fact that type of project's programming language(JavaScript & Python) is only identified with only one filename.


## Traces:

From the paper itself - Section 5 "THREATS TO VALIDITY"

We had to apply heuristics to determine the language of the projects (as the exact solution would have been practically infeasible due to
the database structure). Due to this, we might have omitted some projects as well as identified some projects wrongly. However, as our heuristics are based on widely established guidelines and best practices that most of the projects follow, the number of these projects should be minimal.

## Example(From Database):

- Ruby Project with JS Frontend identified as JS poject due to file "package.json" & Commit Fixes SQL injection in Ruby Language but it is identified as JS CVE in our case.
- https://github.com/discourse/discourse/pull/6199/commits/f7cf5797a080cbf7ff6acfc0dcfac64918026c83

- Python project identified as JS project due to file "package.json"
    - I found many similar results
    - https://github.com/django/django/commit/3d805aeaf8ca1af039d6467fd848d364ec085f66

## Theory:

I believe that here we should identify project with code which are built using only one language otherwise it can mislead many results. We can identify the project with only one language using files like 'index.js' or 'package.json' but we should also check if project contains files of different language.

 

## Feasibility:

The focus of the theory I am suggesting for experiment is to get better number of possibly best identified projects based on programming language. I need to optimize query so it can aggregate all files from base/home directory into one row so we can check if it contains files like 'index.js' or 'package.json' and doesn't contain files of other languages.

## Implementation

Below are the steps that I followed to implement the mentioned Theory.

1. Study [Relational schema](https://docs.softwareheritage.org/devel/swh-dataset/graph/schema.html)

2. Find File extensions for each data in table "cve_revs" and aggregate it so I can optimize query better.

3. Used Following queries:
    ```
    CREATE TABLE cve_revs_sample AS
    select encode(unnested_revs.message, 'escape') as msg,
        encode(unnested_revs.id, 'hex')         as git_hash,
        min(unnested_revs.committer_date)       as commit_date,
        encode(dfe.name, 'escape') as filenames
    from (
            select limited_revs.id,
                    limited_revs.message,
                    limited_revs.committer_date,
                    unnest(directory.file_entries) as filename
            from cve_revs as limited_revs
                    LEFT JOIN directory ON directory.id = limited_revs.directory
        ) unnested_revs
            LEFT JOIN directory_entry_file dfe ON unnested_revs.filename = dfe.id
    GROUP BY unnested_revs.id, msg, encode(dfe.name, 'escape')
    ORDER BY commit_date;
    ```
    ```
    select reverse(substring(reverse(filenames) from 1 for strpos(reverse(filenames),'.')-1)), count(*) as counts
    FROM cve_revs_sample
    where filenames ~ '\.'
    GROUP BY reverse(substring(reverse(filenames) from 1 for strpos(reverse(filenames),'.')-1))
    ORDER BY counts DESC
    ```

4. Got result as following:
    ```
    h
    c
    php
    rb
    gemspec
    cpp
    py
    PHP
    perl
    python
    ```

5. I used function "string_agg()" to aggregate the results so I can get all files of base/home dir into row per git_hash.

6. I used two regex to filter data (Example is for JS query):
    - ```x ~* '(index\.js|app\.js|server\.js|package\.json')```
        - Above regex checks if project contains filename(case insensitive) index.js OR app.js OR server.js OR package.json
	- ```x !~* '\.(\yh\y|\yc\y|\yphp\y|\yrb\y|\ycpp\y|\yperl\y|\ypython\y|\ypy\y)|(Gemfile.lock|Rakefile|gemspec|Gemfile)'```
        - Above regex checks if project contains file extension/filename(case insensitive) of other languages and returns negeation of boolean value.
    So here I only taking row if it contains only programming language and rejecting row if it container other languages even if it contains JS extensions.

7. Run [process/code/update_cve_test.ipynb](process/code/update_cve_test.ipynb)

## Results

- **RQ1** - Typical Security Issue Types:

    The CWEs having at least 10 references in either of the analyzed languages are as follows:  
    - 'CWE-119'
    - 'CWE-189' 
    - 'CWE-20'
    - 'CWE-399'
    - 'CWE-601'

    Interestingly, except for CWE-399 & (CWE-254, CWE-79)(not found 10 references of both) that is the type of the vulnerabilities mitigated in both languages, each of the CWE groups can be attributed to either JavaScript or Python projects.

    We observe different result comparing to research paper's result. 


- **RQ2** - Reaction Times to Security Issues:

    Here we can observe that it takes average 128 days for python and 49 days for JavaScript comminities to fix a vulnerablity.  
    We observe opposit result comparing to research paper's result.

## Process:

- Here 2 new tables named "**cve_revs_test_js.sql**" & "**cve_revs_test_py.sql**" are created with SQL query from files:
    - ""**process/sql/modified_for_threats/create_table_cve_revs_test_js.sql**""
    - ""**process/sql/modified_for_threats/create_table_cve_revs_test_js.sql**""
- It can be automatically created - Follow "Automated Installation" Section from INSTALLATION.md.
- File [process/code/update_cve_test.ipynb](process/code/update_cve_test.ipynb) needs to be exected to get updated results.

## Data:

- Here 2 new tables named "**cve_revs_test_js.sql**" & "**cve_revs_test_py.sql**" are created.
- "**cve_revs_test_js.sql**" - contains commit message, git hash, commit date & list of filenames(string of comma seperated values) for JS projects
- "**cve_revs_test_py.sql**" - contains commit message, git hash, commit date & list of filenames(string of comma seperated values) for Python projects


## References

1. [DBLP:conf/msr/AntalKH20](https://dblp.org/rec/conf/msr/AntalKH20.html?view=bibtex)
2. [arXiv:2006.13652 [cs.SE]](https://arxiv.org/abs/2006.13652)
3. https://2020.msrconf.org/details/msr-2020-mining-challenge/3/Exploring-the-Security-Awareness-of-the-Python-and-JavaScript-Open-Source-Communities
4. [Software Heritage Graph Dataset](https://annex.softwareheritage.org/public/dataset/)
5. [Software Heritage Graph Dataset](https://zenodo.org/record/2583978)
6. [Software Heritage Graph Dataset Documentation](https://docs.softwareheritage.org/devel/swh-dataset/graph/dataset.html)
7. [Code](https://zenodo.org/record/3699486)
8. [CVE manager](https://github.com/aatlasis/cve_manager)