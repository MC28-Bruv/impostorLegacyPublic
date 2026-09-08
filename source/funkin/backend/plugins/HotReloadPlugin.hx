package funkin.backend.plugins;

import flixel.addons.transition.FlxTransitionableState;

/**
 * Plugin that allows easy state reloading
 * 
 * 
 * press F5 to reload the state
 * 
 * press F6 to reload and refresh memory
 */
@:nullSafety
class HotReloadPlugin extends FlxBasic
{
	static var instance:Null<HotReloadPlugin> = null;
	
	public static var hardReloading:Bool = false;
	
	public static function init()
	{
		if (instance == null) FlxG.plugins.addPlugin(instance = new HotReloadPlugin());
	}
	
	public function new()
	{
		super();
		this.visible = false;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		#if !debug
		if (!ClientPrefs.inDevMode) return;
		#end
		
		if (FlxG.keys.justPressed.F5)
		{
			Logger.log('Reloading modules...', NOTICE);
			
			quickResetState();
		}
		
		if (FlxG.keys.justPressed.F6)
		{
			Logger.log('Reloading assets...', NOTICE);
			
			FlxG.signals.preStateCreate.addOnce((state) -> {
				FunkinAssets.cache.clearStoredMemory();
				FunkinAssets.cache.clearUnusedMemory();
			});
			
			funkin.Mods.currentModConfig = funkin.Mods.loadTopModConfig();
			
			hardReload();
			quickResetState();
		}
		
		if (FlxG.keys.justPressed.F7)
		{
			Logger.log('Reloading modules...', NOTICE);
			
			hardReload();
			quickResetState();
		}
	}
	
	inline function hardReload():Void {
		hardReloading = true;
		
		funkin.scripting.PluginsManager.clear();
		
		FlxG.signals.preStateCreate.addOnce((state) -> {
			funkin.scripting.PluginsManager.populate();
			funkin.data.GameFlags.getAwards(true);
			funkin.data.Lang.reloadLangFile();
			
			hardReloading = false;
		});
	}
	
	inline function quickResetState():Void {
		FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
		FlxG.resetState();
	}
}
