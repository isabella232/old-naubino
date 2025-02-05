﻿package 
{
	import caurina.transitions.AuxFunctions;
	import caurina.transitions.Tweener;
	import stat.es.*;
	import flash.media.*;

	public class Menu
	{
		public var game:Game;
		public var objs:Array = [];
		public var folded:Boolean = true;
		public var mainbtn:Button;
		public var secondaryBtns:Array = [];
		public var playbtn:Button;
		public var mutebtn:Button;
		public var helpbtn:Button;
		public var exitbtn:Button;
		
		public function Menu(game : Game) {
			this.game = game;
			initButtons();
			utils.addAll(game.objs, objs);
		}
		
		private function tracer(str:String):Function {
			return function():void { trace(str); };
		}
		
		private function newMainButton():Button {
			var btn : Button = new Button();
			btn.color = Color.yellow;
			btn.visibleRadius = 15;
			objs.push(btn);
			return btn;
		}

		public function popDown():void {
			//game.visual.showAlert();
			for (var i:* in secondaryBtns) {
				var tween:Object = {
					x: mainbtn.x,
					y: mainbtn.y,
					alpha: 0,
					time: 0.6
				};

				var btn:Button = secondaryBtns[i];
				btn.collidable = false;
				Tweener.removeTweens(btn);
				Tweener.addTween(btn, tween);
			}
		}
		
		public function popDownNow():void {
			for (var i:* in secondaryBtns) {
				var btn:Button = secondaryBtns[i];
				btn.collidable = false;
				btn.x = mainbtn.x;
				btn.y = mainbtn.y;
				btn.alpha = 0;
			}
		}

		public function popUp():void {
			var tween:Object;
			for (var i:* in secondaryBtns) {
				var btn:Button = secondaryBtns[i];
				tween = {};
				tween.alpha = 1;
				tween.x = btn.popUpX;
				tween.y = btn.popUpY;
				tween.time = 0.6;
				tween.onComplete = function():void { for (var i:* in secondaryBtns) secondaryBtns[i].collidable = true; };
				Tweener.removeTweens(btn);
				Tweener.addTween(btn, tween);
			}
		}

		private function newButton(color:Color, str:String, action:Function=null):Button {
			var btn : Button = new Button();
			btn.color = color;
			if(action == null)
				btn.setAction(tracer(str));
			else
				btn.setAction(action);	
			btn.type = str;
			objs.push(btn);
			return btn;
		}

		public function showPlay():void {
			playbtn.type = "play";
		}

		public function showPause():void {
			playbtn.type = "pause";
		}

		public function muteAction():void{
			game.jukebox.mute();
			mutebtn.setAction(unMuteAction);
			mutebtn.type = "unmute";
		}

		public function unMuteAction():void{
			game.jukebox.unMute();
			mutebtn.setAction(muteAction);
			mutebtn.type = "mute";
		}

		public function exitAction():void{
			game.state.changeState(game.states.lost);
		}

		public function helpAction():void {
			game.state.changeState(game.states.help);
		}
		
		private function initButtons():void {
			mainbtn = newMainButton();
			mainbtn.collidable = false;
			playbtn = newButton(Color.green, "pause");
			mutebtn = newButton(Color.blue, "mute", muteAction);
			helpbtn = newButton(Color.purple, "help", helpAction);
			exitbtn = newButton(Color.red,"exit", exitAction);
			
			secondaryBtns.push(playbtn);
			secondaryBtns.push(mutebtn);
			secondaryBtns.push(helpbtn);
			secondaryBtns.push(exitbtn);

			const pi:Number = 3.14159;
			mainbtn.position = new Vektor(35, 30);
			var step:Number = 0.22;
			var x:Number = -step * 0.3;
			playbtn.position = Vektor.polar(x * pi, 60); x += step;
			mutebtn.position = Vektor.polar(x * pi, 60); x += step;
			helpbtn.position = Vektor.polar(x * pi, 55); x += step;
			exitbtn.position = Vektor.polar(x * pi, 60);

			for (var i:* in secondaryBtns) {
				var btn:Button = secondaryBtns[i];
				btn.position = btn.position.mul(0.7).add(mainbtn.position);
				btn.popUpX = btn.x;
				btn.popUpY = btn.y;
				btn.visibleRadius = 12;
				join(mainbtn, btn).menu = true;
			}
			
			popDownNow();
		}
		
		public function join(a:Button, b:Button):Joint {
			var joint:Joint  = new Joint(a, b);
			//joint.length = b.position.sub(a.position).length * 1.1;
			//joint.strength = Joint.defaultStrength;
			joint.strength = 0;
			objs.push(joint);
			return joint;
		}

	}
	
}
