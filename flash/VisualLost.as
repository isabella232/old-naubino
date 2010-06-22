package {

	import flash.display.*;
	import flash.text.*;

	public class VisualLost extends VisualModule {

		public var lost:Sprite;
		private var message:TextField;
		private var input:TextField;
		private var submit:Button;
		private var format:TextFormat;

		public function VisualLost(visual:Visual) {
			super(visual);

			lost = new Sprite();
			visual.overlays.addChild(lost);
			visual.hide(lost);
			
			initMessage();
			initForm();
		}

		public function show():void {
			resetInput();
			visual.show(visual.fog, 2);
			visual.show(lost, 2);
		}

		public function hide():void {
			visual.hide(visual.fog, 2);
			visual.hide(lost, 2);
		}

		private function resetInput():void {
			input.text = "Anony Mous";
			input.setTextFormat(format);
		}

		private function initForm():void{
			format = new TextFormat();
			format.font = "Verdana";
			format.size = 20;
			format.align = TextFormatAlign.CENTER;

			input = new TextField();
			input.maxChars = 15;
			input.type = TextFieldType.INPUT;
			input.border = true;

			resetInput();
			input.autoSize = TextFieldAutoSize.CENTER;
			input.x = game.center.x - input.width/2;
			input.y = message.y + message.height;

			submit = new Button();
			submit.color = Color.random;
			submit.setAction(function():void{ trace(input.text);});
			submit.x = input.x + input.width + 20;
			submit.y = input.y + input.height/2;
			submit.type = "ok";
			drawButton (submit);
			//objs.push(submit);

			lost.addChild(input);
		}
		
		private function drawButton(b:Button):void{
			var bs:Sprite = new Sprite();
			bs.graphics.clear();
			//bs.graphics.lineStyle(2, utils.colorToUInt(Color.black));
			bs.graphics.lineStyle();
			bs.graphics.beginFill(utils.colorToUInt(b.color));
			bs.graphics.drawCircle(0, 0, b.visibleRadius);
			bs.graphics.endFill();
			bs.x = b.position.x;
			bs.y = b.position.y;
			bs = Icons.submit(b, bs);
			lost.addChild(bs);
			
		}

		private function initMessage():void {
			var text:String = "Naub Overflow";
			var format:TextFormat = new TextFormat();
			message = new TextField();
						
			format.bold = true;
			format.font = "Verdana";
			format.size = 45;
			format.align = TextFormatAlign.CENTER ;
			
			message.mouseEnabled = false;
			message.textColor = utils.colorToUInt(Color.red);
			message.text = text;
			message.setTextFormat(format);
			message.autoSize = TextFieldAutoSize.CENTER;
			message.x = game.center.x-message.width/2;
			message.y = game.center.y-message.height/2;

			lost.addChild(message);
		}
	}
}
