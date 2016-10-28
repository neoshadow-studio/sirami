
extends Reference


const SCORE_100 = 100
const SCORE_50 = 50
const SCORE_10 = 10
const SCORE_MISS = 0

const DT_100 = 0.02
const DT_50 = 0.03
const DT_10 = 0.06
const DT_MISS = 0.08

const ACC_100 = 1
const ACC_50 = 0.67
const ACC_10 = 0.33
const ACC_MISS = 0


var factor = 1

var score = 0 
var combo = 0
var accuracy = 1


var note_played = 0

var note_100_played = 0
var note_50_played = 0
var note_10_played = 0
var note_missed = 0

var max_combo = 0


var playfield




func _init( pf ):
	
	playfield = pf
	
	factor = playfield.track.difficulty.timing_factor




func can_be_played( note ):
	
	var dt = abs( playfield.get_time( ) - note.time )
	
	if dt <= DT_MISS:
		
		return true
	
	return false




func get_score( note ):
	
	var dt = abs( playfield.get_time( ) - note.time )
	
	
	if dt <= DT_100 * factor:
		
		return SCORE_100
	
	if dt <= DT_50 * factor:
		
		return SCORE_50
	
	if dt <= DT_10 * factor:
		
		return SCORE_10
		
	
	return SCORE_MISS




func add_score( score, inc_notes = true ):
	
	if combo == 0:
		
		self.score += score
	
	else:
		
		self.score += score * ( 1 + combo * 0.1 )
	
	
	if inc_notes:
		note_played += 1
	
	
	if score == SCORE_100:
		
		accuracy = ( note_played - 1 ) * accuracy + ACC_100
		accuracy /= note_played
		
		combo += 1
		
		if inc_notes:
			note_100_played += 1
	
	if score == SCORE_50:
		
		accuracy = ( note_played - 1 ) * accuracy + ACC_50
		accuracy /= note_played
		
		combo += 1
		
		if inc_notes:
			note_50_played += 1
	
	if score == SCORE_10:
		
		accuracy = ( note_played - 1 ) * accuracy + ACC_10
		accuracy /= note_played
		
		combo += 1
		
		if inc_notes:
			note_10_played += 1
	
	if score == SCORE_MISS:
		
		accuracy = ( note_played - 1 ) * accuracy + ACC_MISS
		accuracy /= note_played
		
		combo = 0
		
		if inc_notes:
			note_missed += 1
	
	
	max_combo = max( combo, max_combo )
	
	playfield.high_gui.update_score( )
