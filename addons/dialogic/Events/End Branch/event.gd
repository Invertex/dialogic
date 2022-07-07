tool
extends DialogicEvent
class_name DialogicEndBranchEvent

var this_is_an_end_event
var parent_event = null

func _execute() -> void:
	dialogic.current_event_idx = find_next_index()-1
	finish()

func find_next_index():
	var idx = dialogic.current_event_idx
	
	# In case the next event is not a choice or ELIF/ELSE event, just go to the next one
	# excuse this, checking like normally creates a FUCKING CYCLIC DEPENDENCY....
	if not (dialogic.current_timeline.get_event(idx+1) and 'ConditionType' in dialogic.current_timeline.get_event(idx+1) and dialogic.current_timeline.get_event(idx+1).ConditionType != 0):
		if not dialogic.current_timeline.get_event(idx+1) is DialogicChoiceEvent:
			return idx+1
			
	
	var ignore = 1
	# this will go through the next events, until 
	# there is a event that's ONE INDENT LESS and NOT A CHOICE and NOT an ELIF or ELSE event
	while true:
		idx += 1
		var event = dialogic.current_timeline.get_event(idx)
		if not event:
			idx -= 1
			break
		if event is DialogicChoiceEvent:
			ignore += 1
		# if we get to a condition that is of type elif or else
		elif 'ConditionType' in event and event.ConditionType != 0:
			pass
		elif ignore == 1:
			break
		# excuse this, checking like above creates a FUCKING CYCLIC DEPENDENCY....
		if 'ConditionType' in dialogic.current_timeline.get_event(idx):
			ignore += 1
		# excuse this, checking like above creates a FUCKING CYCLIC DEPENDENCY....
		elif 'this_is_an_end_event' in dialogic.current_timeline.get_event(idx):
			ignore -= 1
		
	return idx

################################################################################
## 						INITIALIZE
################################################################################

# SET ALL VALUES THAT SHOULD NEVER CHANGE HERE
func _init() -> void:
	event_name = "End Branch"
	event_color = Color.white
	event_category = Category.LOGIC
	event_sorting_index = 0
	disable_editor_button = true
	continue_at_end = true


################################################################################
## 						SAVING/LOADING
################################################################################

## THIS RETURNS A READABLE REPRESENTATION, BUT HAS TO CONTAIN ALL DATA (This is how it's stored)
func get_as_string_to_store() -> String:
	
	return "<<END BRANCH>>"


## THIS HAS TO READ ALL THE DATA FROM THE SAVED STRING (see above) 
func load_from_string_to_store(string:String):
	
	# fill your properies by interpreting the string
	
	pass


# RETURN TRUE IF THE GIVEN LINE SHOULD BE LOADED AS THIS EVENT
func is_valid_event_string(string:String):
	
	if string.strip_edges().begins_with("<<END BRANCH>>"):
		return true
	return false