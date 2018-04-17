# tag-modelid-to-item 
## This is more than just model id stuff. Should of named it something a bit more general.
### Update/Create model tree id FK on iten table,
- Transferator uses the model ids from the item table. The LC211 syncs stores these ids as tags, One function of this project is to keep these model ids in sync between the item table model_tree_id FK and modelId tag in item_tag table. The tag is manaegd by users of LC.
### Keep model tree table in eleven in sync with ultegra
- The model tree table is genrated/updated via periodic process on ultgera which reads in a csv model tree file managed by Landrys users. This function will read the model_tree entries from ultegra and sync them up with duraAce's model_tree table. 
### How executed
- These perl scripts will be run in the cron process on nator before we run transferator.
 
