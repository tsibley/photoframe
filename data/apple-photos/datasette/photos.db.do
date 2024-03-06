redo-ifchange ../favorites.csv
sqlite-utils insert "$3" favorites ../favorites.csv --csv --empty-null --pk uuid >&2
sqlite-utils create-index "$3" favorites uuid >&2
sqlite3 "$3" <<.
alter table favorites add column path_preferred text generated always as (coalesce(path_edited, path)) virtual;
alter table favorites add column url text generated always as ('/-/media/favorites/' || uuid || '?format=JPEG') virtual;
alter table favorites add column preview text generated always as (json_object('img_src', '/-/media/favorites/' || uuid || '?format=JPEG&h=200')) virtual;
.
