package funkin.scripts;

import insanity.backend.Expr;
import insanity.backend.types.Scripted;

@:access(insanity.backend.Parser)
@:access(insanity.backend.Interp)
class FunkinModule extends insanity.Module implements IFunkinModule
{
	public var hash:String;
	
	public override function parse(string:String):Array<ModuleDecl>
	{
		hash = haxe.crypto.Sha256.encode(string);
		
		return super.parse(string);
	}
	
	public override function start(?environment:insanity.Environment):Void {
		if (decls.length == 0) return;
		
		return super.start(environment);
	}
	
	public override function startType(?environment:insanity.Environment, type:IInsanityType):IInsanityType
	{
		if (type is InsanityScriptedClass) {
			var cls:InsanityScriptedClass = cast type;
			
			cls.safe = true;
			cls.onExpressionError = function(e:Dynamic, field:String, ?expr:Expr)
			{
				FunkinScript.log(Std.string(e), interp.posInfos(), ERROR);
			}
			cls.onInstanceError = function(e:Dynamic, fun:String, ?instance:IInsanityScripted)
			{
				FunkinScript.log(Std.string(e), interp.posInfos(), ERROR);
			}
		}
		
		return super.startType(environment, type);
	}
	
	public override dynamic function onProgramError(exception:haxe.Exception):Void
	{
		FunkinScript.log(exception, interp.posInfos(), FATAL);
	}
	public override dynamic function onParsingError(exception:haxe.Exception):Void
	{
		if (exception is insanity.backend.Exception.ParserException) {
			FunkinScript.log(exception, cast {fileName: path, lineNumber: parser.line}, FATAL);
		} else {
			FunkinScript.log(exception.details(), cast {fileName: path, lineNumber: parser.line}, FATAL);
		}
	}
	public override dynamic function onTypeError(exception:haxe.Exception, type:IInsanityType):Void
	{
		FunkinScript.log(exception, cast {fileName: type.path, lineNumber: -1}, FATAL);
	}
	
	public override function setDefaults():Void
	{
		super.setDefaults();
		
		// lol
	}
}

@:access(insanity.backend.Parser)
@:access(insanity.backend.Interp)
class FunkinImportModule extends insanity.ImportModule implements IFunkinModule
{
	public var hash:String;
	
	public override function parse(string:String):Array<ModuleDecl>
	{
		hash = haxe.crypto.Sha256.encode(string);
		
		return super.parse(string);
	}
	
	public override dynamic function onProgramError(e:haxe.Exception):Void
	{
		FunkinScript.log(Std.string(e), interp.posInfos(), ERROR);
	}
	public override dynamic function onParsingError(e:haxe.Exception):Void
	{
		FunkinScript.log(Std.string(e), cast {fileName: name, lineNumber: parser.line}, ERROR);
	}
}

interface IFunkinModule
{
	public var hash:String;
}
