import funkin.states.substates.MissCounterSubstate;

function onAccept() {
    openSubState(new MissCounterSubstate(function(misses:Int) FlxG.state.loadSong(FlxG.state.week_songs[FlxG.state.curSelect][0])));
    FlxG.state.persistentUpdate = false;
    return Function_Stop;
}