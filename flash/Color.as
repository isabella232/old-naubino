package {
	public class Color {
		public var r : int;
		public var g : int;
		public var b : int;
		public var name : String;

		public function Color(red:Number, green:Number, blue:Number, n:String = "unnamed") {
			r = red;
			g = green;
			b = blue;
			name = n;
		}

		public function equals(other:Color):Boolean {
			return name == other.name;
		}

		/* gibt eine zuf�llige Farbe aus dem OUTPUT farbschema zur�ck */
		private static var colors:Array;

		public static function get random():Color {
			if (colors == null) {
				colors = [red, green, pink, blue, yellow, purple];
			}
			var randIndex:uint = Math.ceil(Math.random() * colors.length) - 1; //TODO find nicer replacement for rand.nextInt() in as3.0
			return colors[randIndex];
		}

		public static const red   :Color = new Color(229,  53,  23, "red");
		public static const pink  :Color = new Color(226,   0, 122, "pink");
		public static const green :Color = new Color(151, 190,  13, "green");
		public static const blue  :Color = new Color(  0, 139, 208, "blue");
		public static const purple:Color = new Color(100,  31, 128, "purple");
		public static const yellow:Color = new Color(255, 204,   0, "yellow");
		public static const black :Color = new Color(  0,   0,   0, "black");
		public static const grey  :Color = new Color(160,160,160, "grey");
		public static const white :Color = new Color(255, 255, 255, "white");

		public function toString():String {
			return name;
		}

		public function toUInt():uint {
						return 0x010000 * r + 0x000100 * g + 0x000001 * b;
		}
	}
}
