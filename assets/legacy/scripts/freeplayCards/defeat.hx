import funkin.states.substates.MissCounterSubstate;

function onAccept() {
    openSubState(new MissCounterSubstate(function(misses:Int) FlxG.state.loadSong(meta[0])));
    FlxG.state.persistentUpdate = false;
    return Function_Stop;
}
