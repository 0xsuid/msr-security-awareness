CREATE TABLE cve_revs AS
(
    select * from revision
        WHERE encode(revision.message, 'escape') ILIKE '%CVE-%'
        OR encode(revision.message, 'escape') ILIKE '%CWE-%'
        OR encode(revision.message, 'escape') ILIKE '%NVD-%'
        OR encode(revision.message, 'escape') ILIKE '%SQL injection%'
        OR encode(revision.message, 'escape') ILIKE '%SQLinjection%'
);