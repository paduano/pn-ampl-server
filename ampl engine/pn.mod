model;

param duration;
param n_places;
param n_transitions;
param max_firing;

set TIME := 0 .. duration;

set PLACES;
param initial_tokens{PLACES};

set TRANSITIONS := 0 .. n_transitions;

set IN_TRANSITIONS within {TRANSITIONS, PLACES};
set OUT_TRANSITIONS within {PLACES, TRANSITIONS};


#vars

var fire{TIME, TRANSITIONS} binary;
var activated_places{PLACES} binary;
var tokens{TIME, PLACES} integer >= 0;


#objectives

minimize number_of_firing:
	sum{t in TIME, transition in TRANSITIONS} fire[t,transition];

minimize number_of_activated_places:
	sum{place in PLACES} activated_places[place];


#constraints

s.t. tokens_coherency{t in TIME, place in PLACES : t <> 0}:
	tokens[t, place] = tokens[t - 1, place] 
	+ (sum{transition in TRANSITIONS : (transition, place) in IN_TRANSITIONS}(fire[t, transition]))
	- (sum{transition in TRANSITIONS : (place, transition) in OUT_TRANSITIONS}(fire[t, transition]))
	;

s.t. necessary_to_fire{t in TIME, place in PLACES : t <> 0}:
	sum{transition in TRANSITIONS : (place, transition) in OUT_TRANSITIONS} fire[t, transition] <=
	tokens[t - 1, place]
	;
	
s.t. activated_places_constraint{t in TIME, place in PLACES}:
	sum{transition in TRANSITIONS : (place, transition) in OUT_TRANSITIONS} fire[t, transition] <=
	activated_places[place] * max_firing
	;
	
	
#start and end marking

s.t. start_marking{place in PLACES}:
	tokens[0, place] = initial_tokens[place];
	

	
s.t. end_marking:
	tokens[duration, 1] = 5;
	