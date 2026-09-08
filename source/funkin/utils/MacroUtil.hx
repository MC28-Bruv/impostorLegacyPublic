package funkin.utils;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.Tools;

using Lambda;
#end

class MacroUtil
{
	/**
	 * enforces the use of haxe 4.3.4
	 */
	public static macro function haxeVersionEnforcement()
	{
		#if (haxe_ver < "4.3.4")
		Context.fatalError('use haxe 4.3.4 or newer thx', (macro null).pos);
		#end
		
		return macro $v{0};
	}
	
	/**
	 * Gets the content from a file before compilation.
	 * 
	 * You must provide the full path to file
	 */
	public static macro function getPrecompliedContent(path:String)
	{
		#if !display
		if (!sys.FileSystem.exists(path))
		{
			Context.fatalError('could not find content at $path', Context.currentPos());
		}
		
		final ret = sys.io.File.getContent(path);
		
		return macro $v{ret};
		#end
	}
}
