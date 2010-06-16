﻿package stat.es
{
	public class Play extends GameState
	{
		
		public function Play(game:Game) 
		{
			super(game);
		}

		public override function refresh():void {			//if (game.enablePhysics)
				game.physics.physik();
			game.antipoints = game.countingJoints();
			if (game.antipoints > game.ballsTillLost) {
				changeState(Lost);
			}
		}

		public override function enter():void {
			trace("play");
			game.spammer.start();
			showPauseButton();
		}

		public override function leave():void {
			game.spammer.stop();
			showPlayButton();
		}
		
		public function showPlayButton():void {
			game.menu.playbtn.type = "play";
			game.menu.playbtn.setAction(function():void { changeState(Play);});
		}
		
		public function showPauseButton(): void{
			game.menu.playbtn.type = "pause";
			game.menu.playbtn.setAction(function():void { changeState(Pause); });
		}
	}
}
