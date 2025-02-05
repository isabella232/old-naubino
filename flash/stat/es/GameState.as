﻿package stat.es
{ 
	public class GameState
	{
		protected var game:Game;

		public function GameState(game:Game) {
			this.game = game;
		}
		
		public function refresh():void {}

		public function enter():void {}

		public function leave():void {}

		public function changeState(state:GameState):void {
			game.state.leave();
			game.state = state;
			game.state.enter();
		}
		
		protected function get start():Start{
			return game.states.start;
		}
		
		protected function get play():Play{
			return game.states.play;
		}
		
		protected function get pause():Pause{
			return game.states.pause;
		}
		
		protected function get lost():Lost{
			return game.states.lost;
		}
		
		protected function get highscore():Highscore{
			return game.states.highscore;
		}
		
		protected function get credits():Credits{
			return game.states.credits;
		}

		public function showPlayButton():void {
			game.menu.playbtn.type = "play";
			game.menu.playbtn.setAction(function():void { changeState(play);});
		}
		
		public function showPauseButton(): void{
			game.menu.playbtn.type = "pause";
			game.menu.playbtn.setAction(function():void { changeState(pause); });
		}
	}
	
}
