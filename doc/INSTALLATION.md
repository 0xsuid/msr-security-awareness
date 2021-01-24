# Installation

**NOTE**: You must have minimum available storage space of 70GB.
## Software

1. [Python 3.x](https://www.python.org/downloads/)
2. Gzip & wget/curl
    - For Windows OS install [Git For Windows](https://git-scm.com/download/win)
3. [PostgreSQL 13](https://www.postgresql.org/download/) - [Direct Download](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)

## Dataset

Download "popular-4k" Dataset with the script:

For Windows:
```
process/install/download_windows.bat
```

For Linux / Mac OS:  

Note: If you have issue with wget then try with curl script.
```
./process/install/download_wget.sh
```
```
./process/install/download_curl.sh
```

## Database

1. Install PostgreSQL 13.

2. Optimization (optional):

    1. Find Location of Postgresql.conf:
        ```
        psql -U postgres
        ```
        ```
        SHOW config_file;
        ```

    2. Optimize Postgresql.conf:

        Configuration for systems having 16GB RAM & SSD.
        ```
        max_connections = 40
        shared_buffers = 4096MB
        effective_cache_size = 12GB
        maintenance_work_mem = 1024MB
        checkpoint_completion_target = 0.9
        default_statistics_target = 500
        random_page_cost = 1.1
        temp_buffers = 4096MB
        work_mem = 26214kB
        max_wal_size = 16GB
        min_wal_size = 4GB
        ```

        Configuration For 8GB RAM & SSD.
        ```
        max_connections = 40
        shared_buffers = 512MB
        effective_cache_size = 6GB
        maintenance_work_mem = 1GB
        checkpoint_completion_target = 0.9
        wal_buffers = 16MB
        default_statistics_target = 500
        random_page_cost = 1.1
        work_mem = 16MB
        min_wal_size = 4GB
        max_wal_size = 16GB
        ```

3. Create Database & Load Dataset:

    **NOTE**: Execution of below script may take **a lot of time**, if you don't have extra time then you might want to continue without creating indexes - which may speedup execution of SQL queries.

    1. Using Indexed Database - Execution time is **~3-4 HOURS**.

    ```
    createdb swhgd-popular-4k
    psql swhgd-popular-4k < data/popular-4k/load.sql
    ```

    2. Using NON INDEXD DB - Execution time is **~30-40 MINS**.

    ```
    createdb swhgd-popular-4k
    psql swhgd-popular-4k < process/sql/load_no_index.sql
    ```

    If you just want to explore then I would like to recommend that you should go with 2nd option - non indexed db.