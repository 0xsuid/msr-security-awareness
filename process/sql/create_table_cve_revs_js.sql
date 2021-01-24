CREATE TABLE cve_revs_py AS
select encode(unnested_revs.message, 'escape') as msg,
       encode(unnested_revs.id, 'hex')         as git_hash,
       min(unnested_revs.committer_date)       as commit_date
from (
         select limited_revs.id,
                limited_revs.message,
                limited_revs.committer_date,
                unnest(directory.file_entries) as filename
         from cve_revs as limited_revs
                  LEFT JOIN directory ON directory.id = limited_revs.directory
     ) unnested_revs
         LEFT JOIN directory_entry_file dfe ON unnested_revs.filename = dfe.id
WHERE encode(dfe.name, 'escape') IN ('index.js', 'app.js', 'server.js', 'package.json')
GROUP BY unnested_revs.id, msg
ORDER BY commit_date;