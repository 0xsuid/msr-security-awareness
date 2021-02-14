# Installation

**NOTE**: You must have minimum available storage space of 70GB.
## Software Requirements

1. [Python 3.x](https://www.python.org/downloads/)
2. Gzip & Wget/cURL
    - For Windows OS install [Git For Windows](https://git-scm.com/download/win)
3. [PostgreSQL 13](https://www.postgresql.org/download/) - [Direct Download](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)


## Database optimization (Recommended)

1. Find Location of Postgresql.conf:
    ```
    psql -U postgres
    ```
    ```
    SHOW config_file;
    ```

2. Optimize Postgresql.conf:

    - Configuration for systems having 16GB RAM & SSD.
        ```
        max_connections = 40
        shared_buffers = 4GB
        huge_pages = try
        effective_cache_size = 12GB
        maintenance_work_mem = 1GB
        checkpoint_completion_target = 0.9
        default_statistics_target = 500
        random_page_cost = 1.0
        temp_buffers = 12000MB
        work_mem = 1024MB
        checkpoint_timeout = 10min
        wal_compression = on
        max_wal_size = 16GB
        min_wal_size = 4GB
        ```

    - Configuration For 8GB RAM & SSD.
        ```
        max_connections = 40
        shared_buffers = 2GB
        huge_pages = try
        effective_cache_size = 6GB
        maintenance_work_mem = 1GB
        checkpoint_completion_target = 0.9
        default_statistics_target = 500
        random_page_cost = 1.1
        min_wal_size = 2GB
        max_wal_size = 6GB
        ```

## Automated Installation

Download "popular-4k" Dataset, Load Dataset into Database & Create Tables(cve_revs,cve_revs_js,cve_revs_py) with the following scripts:

Database optimization is Recommended before executing scripts.

Note: Select options one by one (in scripts) in following order:  
    1. Download Dataset(Size ~22.5GB **compressed**)  
    2. Load Dataset into Database 
    3. Create Tables (cve_revs,cve_revs_js,cve_revs_py)  
    4. Download NVD & Get CVE related issues

After completing above steps you should continue with Generate Statistics/Result section given below.

- **For Windows**:

    ```
    process/install/download_windows.bat
    ```

- **For Linux / Mac OS**:  

    Note: If you issues with wget then try downloading with curl.
    ```
    chmod +x ./process/install/download_linux.sh
    ./process/install/download_linux.sh
    ```

## Manual Installation

1. Install PostgreSQL 13.

2. Download Dataset - [Link](https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/) (Size ~22.5GB **compressed**) 

3. Create Database & Load Dataset:

    **NOTE**: Execution of below script may take **a lot of time**, if you don't have extra time then you might want to continue without creating indexes (which may take little bit more execution time for SQL queries).

    1. Using Indexed Database - Execution time is **~3-4 HOURS**.

    ```
    createdb -U postgres swhgd-popular-4k
    cd data/popular-4k/
    psql -U postgres swhgd-popular-4k < load.sql
    ```

    2. Using NON INDEXD DB - Execution time is **~30-40 MINS**.

    ```
    createdb -U postgres swhgd-popular-4k
    cp process/sql/load_no_index.sql data/popular-4k/
    cd data/popular-4k/
    psql -U postgres swhgd-popular-4k < load_no_index.sql
    ```

    If you just want to explore then I would like to recommend that you should go with 2nd option - non indexed db.

4. Create Tables (cve_revs,cve_revs_js,cve_revs_py):

    1. Create cve_revs table
        ```
        psql -U postgres swhgd-popular-4k < process/sql/create_table_cve_revs.sql
        ```

    2. Create cve_revs_js table
        ```
        psql -U postgres swhgd-popular-4k < process/sql/create_table_cve_revs_js.sql
        ```

    3. Create cve_revs_py table
        ```
        psql -U postgres swhgd-popular-4k < process/sql/create_table_cve_revs_py.sql
        ```
5. Download NVD & Get CVE related issues

    - Download [CVE Manager](https://github.com/aatlasis/cve_manager)
        - For Windows - [CVE Manager](https://github.com/0xsuid/cve_manager)
    - Execute following:
    ```
    python code/cve_manager.py -d -p -csv -i data/nvd -o data/cve_parsed
    ```
6. After completing above steps you should continue with Generate Statistics/Result section given below.
## Generate Statistics/Result:

**INFO**: Original code is available under process/code/original Folder.

1. Edit Jupyter notebook [process/code/update_cve](process/code/update_cve.ipynb)  
2. Add database and user details  
3. Run [update_cve](process/code/update_cve.ipynb)