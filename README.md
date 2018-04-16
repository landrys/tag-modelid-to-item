# tag-modelid-to-item 
## This is more than just model id stuff. Should of named it something a bit more general.
### Update/Create model tree id FK on iten table,
- Transferator uses the model ids from the item table. The LC211 syncs stores these ids as tags, On function of this script is to keep these mode ids in sync between the item table model_tree_id FK and tag. The tag is manaegd by users of LC.
### Keep model tree table in eleven in sync with ultegra
- The model tree table is genrated/updated via periodic process on ultgera which reads in a csv model tree file managed by Landrys users. This script will be run as a cron process or maybe run when transferator runs so the model tree table on dura-ace is in sync with model tree table in ultegra.
