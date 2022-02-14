extends Resource
class_name SpeechRes

export(String) var code = ""
export(String) var text = ""
# CharacterRes
export(Resource) var from = null
export(Resource) var to = null

# link to code
export(String) var link = ""
# ChoiceRes
export(Array, Resource) var choice_list = []
