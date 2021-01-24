create extension if not exists btree_gist;
create extension if not exists pgcrypto;
create type revision_type as enum ('git', 'tar', 'dsc', 'svn', 'hg');
comment on type revision_type is 'Possible revision types';

create type object_type as enum ('content', 'directory', 'revision', 'release', 'snapshot');
comment on type object_type is 'Data object types stored in data model';

create type snapshot_target as enum ('content', 'directory', 'revision', 'release', 'snapshot', 'alias');
comment on type snapshot_target is 'Types of targets for snapshot branches';

create type origin_visit_status as enum (
  'ongoing',
  'full',
  'partial'
);
comment on type origin_visit_status IS 'Possible visit status';
create domain sha1 as bytea check (length(value) = 20);
create domain sha1_git as bytea check (length(value) = 20);
create domain unix_path as bytea;
create domain file_perms as int;

create table content
(
  sha1       sha1 not null,
  sha1_git   sha1_git not null,
  length     bigint not null
);

create table skipped_content
(
  sha1       sha1,
  sha1_git   sha1_git,
  length     bigint not null
);

create table directory
(
  id            sha1_git,
  dir_entries   bigint[],  -- sub-directories, reference directory_entry_dir
  file_entries  bigint[],  -- contained files, reference directory_entry_file
  rev_entries   bigint[]  -- mounted revisions, reference directory_entry_rev
);

create table directory_entry_dir
(
  id      bigserial,
  target  sha1_git,   -- id of target directory
  name    unix_path,  -- path name, relative to containing dir
  perms   file_perms  -- unix-like permissions
);

create table directory_entry_file
(
  id      bigserial,
  target  sha1_git,   -- id of target file
  name    unix_path,  -- path name, relative to containing dir
  perms   file_perms  -- unix-like permissions
);

create table directory_entry_rev
(
  id      bigserial,
  target  sha1_git,   -- id of target revision
  name    unix_path,  -- path name, relative to containing dir
  perms   file_perms  -- unix-like permissions
);

create table person
(
  id        bigserial
);

create table revision
(
  id                    sha1_git,
  date                  timestamptz,
  date_offset           smallint,
  committer_date        timestamptz,
  committer_date_offset smallint,
  type                  revision_type not null,
  directory             sha1_git,  -- source code "root" directory
  message               bytea,
  author                bigint,
  committer             bigint
);

create table revision_history
(
  id           sha1_git,
  parent_id    sha1_git,
  parent_rank  int not null default 0
);

create table release
(
  id          sha1_git not null,
  target      sha1_git,
  date        timestamptz,
  date_offset smallint,
  name        bytea,
  comment     bytea,
  author      bigint
);

create table snapshot
(
  object_id  bigserial not null,  -- PK internal object identifier
  id         sha1_git             -- snapshot intrinsic identifier
);

create table snapshot_branch
(
  object_id    bigserial not null,  -- PK internal object identifier
  name         bytea not null,      -- branch name, e.g., "master" or "feature/drag-n-drop"
  target       bytea,               -- target object identifier, e.g., a revision identifier
  target_type  snapshot_target      -- target object type, e.g., "revision"
);

create table snapshot_branches
(
  snapshot_id  bigint not null,  -- snapshot identifier, ref. snapshot.object_id
  branch_id    bigint not null   -- branch identifier, ref. snapshot_branch.object_id
);

create table origin
(
  id       bigserial not null,
  type     text,
  url      text not null,
  lister   integer,
  project  integer
);

create table origin_visit
(
  origin       bigint not null,
  visit        bigint not null,
  date         timestamptz not null,
  status       origin_visit_status not null,
  metadata     jsonb,
  snapshot_id  bigint
);
\copy origin_visit (origin, visit, date, status, metadata, snapshot_id) from program 'gzip -cd origin_visit.csv.gz' (format csv);
\copy origin (id, type, url, lister, project) from program 'gzip -cd origin.csv.gz' (format csv);

\copy snapshot_branches (snapshot_id, branch_id) from program 'gzip -cd snapshot_branches.csv.gz' (format csv);
\copy snapshot_branch (object_id, name, target, target_type) from program 'gzip -cd snapshot_branch.csv.gz' (format csv);
\copy snapshot (object_id, id) from program 'gzip -cd snapshot.csv.gz' (format csv);

\copy release (id, target, date, date_offset, name, comment, author) from program 'gzip -cd release.csv.gz' (format csv);

\copy revision_history (id, parent_id, parent_rank) from program 'gzip -cd revision_history.csv.gz' (format csv);
\copy revision (id, date, date_offset, committer_date, committer_date_offset, type, directory, message, author, committer) from program 'gzip -cd revision.csv.gz' (format csv);

\copy person (id) from program 'gzip -cd person.csv.gz' (format csv);

\copy directory_entry_rev (id, target, name, perms) from program 'gzip -cd directory_entry_rev.csv.gz' (format csv);
\copy directory_entry_dir (id, target, name, perms) from program 'gzip -cd directory_entry_dir.csv.gz' (format csv);
\copy directory_entry_file (id, target, name, perms) from program 'gzip -cd directory_entry_file.csv.gz' (format csv);
\copy directory (id, dir_entries, file_entries, rev_entries) from program 'gzip -cd directory.csv.gz' (format csv);

\copy skipped_content (sha1, sha1_git, length) from program 'gzip -cd skipped_content.csv.gz' (format csv);
\copy content (sha1, sha1_git, length) from program 'gzip -cd content.csv.gz' (format csv);