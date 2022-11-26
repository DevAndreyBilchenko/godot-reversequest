extends Resource


export(int) var code = -1
export(String) var text = ""
# CharacterRes
export(Resource) var from = null
export(Resource) var to = null

# link to code
export(int) var link = -1
# ChoiceRes
export(Array, Resource) var choice_list
