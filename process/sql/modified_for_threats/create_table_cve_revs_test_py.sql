CREATE TABLE cve_revs_test_py AS
SELECT encode(unnested_revs.message, 'escape') AS msg,
       encode(unnested_revs.id, 'hex')         AS git_hash,
       min(unnested_revs.committer_date)       AS commit_date,
	string_agg(encode(dfe.name, 'escape'), ',') AS filename_list
FROM (
       SELECT limited_revs.id,
              limited_revs.message,
              limited_revs.committer_date,
              unnest(directory.file_entries) AS filename
       FROM cve_revs AS limited_revs
              LEFT JOIN directory ON directory.id = limited_revs.directory
) unnested_revs
LEFT JOIN directory_entry_file dfe ON unnested_revs.filename = dfe.id
GROUP BY unnested_revs.id, msg
HAVING exists (select * 
              from ( select string_agg(encode(dfe.name, 'escape'), ',') x ) q1 
                     WHERE x ~* '(__init__\.py|setup\.py)' 
                     AND x ~* '\.(\yh\y|\yc\y|\yphp\y|\yrb\y|\ycpp\y|\yperl\y|\yjs\y)|(Gemfile\.lock|Rakefile|gemspec|Gemfile)'
              ) 
ORDER BY commit_date;