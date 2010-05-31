﻿package 
{
	import flash.display.JointStyle;
	import flash.utils.Timer;
	public class Game
	{
		public var width : Number;
		public var height : Number;
		public var fieldSize : Number;
		public var balls : Array;
		public var joints : Array;
		public var pointer : Vektor;
		public var menu : Menu;

		private var refreshInterval:Number = 50;
		private var spammer:Spammer;

		private var physics : Physics;
		var enablePhysics:Boolean = true;
		var useGenerateTimer:Boolean  = false;

		private var points:Number = 0;
		private var antipoints:Number = 0;

	
		function initFields() {
			width = 600;
			height = 400;
			fieldSize = 160;
			balls = [];
			joints = [];
			pointer = center;
			spammer = new Spammer(this);
			physics = new Physics(this);
			menu = new Menu();
		}
		
		function Game() {
			initFields();
		}
		
		function createBall(v:Vektor):Ball {
			var b : Ball = new Ball(v);
			b.color = Color.random();
			balls.push(b);
			return b;
		}
		
		// balls below here

		public function createPair(v:Vektor):void {
			var pair:Vektor = Vektor.polar(Math.random() * Math.PI * 2, Joint.defaultLength * 0.6);
			var pos1:Vektor = v.add(pair);
			var pos2:Vektor = v.sub(pair);
			var ball2:Ball = createBall(pos2);
			var ball1:Ball = createBall(pos1);
			joints.push(join(ball1, ball2));
		}

		/* nur benutzen wenn zwei neue Baelle gejoint werden */
		public function join(a:Ball, b:Ball):Joint {
			var joint:Joint  = new Joint(a, b);
			a.addJoint(joint);
			b.addJoint(joint);
			return joint;
		}
	
		/* game logic below here */
		public function refresh() {
			if (enablePhysics)
				physics.physik();
			antipoints = countingJoints();
			if (antipoints > 30) {
				restart();
				useGenerateTimer = false;
			}
		}

		public function restart() {
			balls.clear();
			joints.clear();
		}

		private function countingJoints():Number {
			var adistance:Number;
			var bdistance:Number;
			var count:Number = 0;
			var fieldRadius:Number = fieldSize / 2;
			var forfunc = function (j:Joint, i, _) {
				adistance = j.a.position.sub(center).length;
				bdistance = j.b.position.sub(center).length;
				if (adistance < fieldRadius || bdistance < fieldRadius)
					count++;
			}
			joints.forEach(forfunc);
			return count;
		}

		/* balls below here */
		protected function unJoin(a:Ball, b:Ball):void {
			var forfunc = function (j:Joint, i, _){
				joints.remove(j);
				a.removeJoint(j);
				b.removeJoint(j);
			}
			a.jointsWith(b).forEach(forfunc);
		}

		public function attachBalls(c:Collision):void {
			var a:GameBall = c.a;
			var b:GameBall = c.b;
			if ((a.active || b.active) && c.overlap > 4) {
				if (a.joints.length > 0 && b.joints.length > 0) {
					if (a.match(b)) {
						replaceBall(a, b);
						handleCycles();
					}
				} else {
					joints.push(join(a, b));
				}
			}
		}

		private function replaceBall(a:Ball, b:Ball) {
			var shareJointBall:Boolean = false;
			var forfunc = function (jp:Ball, i, _) {
				if (jp.isJointWith(b))
					shareJointBall = true;
			}
			a.jointBalls().forEach(forfunc);
			
			if (!shareJointBall && !a.isJointWith(b)) {
				var forfunc2 = function (jb:Ball, i, _) {
					if (!a.isJointWith(jb)) {
						joints.push(join(a, jb));
					}
				}
				b.jointBalls().forEach(forfunc2);
				removeBall(b);
			}
		}

		private function handleCycles():void {
			var b:Ball;
			var cycle:Array;
			var cycles:Array = CycleTest.cycleTest(balls);
			for (var i = 0; i < cycles.length; i++) {
				cycle = cycles[i];
				for (var j = 0; j < cycle.length; j++) {
					b = cycle[j];
					removeBall(b);
					incPoints();
				}
			}
		}

		private function collidingBall(v:Vektor):Ball  {
			for (var i = 0; i < balls.length; i++) {
				var b:Ball = balls[i];
				if (b.isHit(v))
					return b;
			}
			return null;
		}

		private function removeAll(a:Array, b:Array):void {
			for (var i = 0; i < b.length; i++) {
				var j:Joint = b[i];
				a.splice(a.indexOf(j),1);
			}
		}
		
		private function removeBall(b:Ball):void {
			removeAll(joints, b.joints);
			var jointballs = b.jointBalls();
			for (var i = 0; i < jointballs.length; i++) {
				var jp:Ball = jointballs[i];
				removeAll(jp.joints, jp.jointsWith(b));
			}
			balls.splice(balls.indexOf(b), 1);
		}

		///* interaction below here */
		//public void keyPressed(int key) {
			//switch (key) {
			//case 0:
				//spammer.randomPair();
				//break;
			//case 1:
				//restart();
				//break;
			//case 2:
				//
			//case 3:
				//enablePhysics = !enablePhysics;
				//break;
			//case 4:
				//useGenerateTimer = !useGenerateTimer;
				//break;
			//}
		//}
	//
		public function pointerMoved(v:Vektor) {
			pointer = v;
		}

		public function pointerPressedLeft(v:Vektor) {
			var b:Ball = collidingBall(v);
			if (b != null)
				b.action();
		}

		public function pointerPressedRight(v:Vektor) {
			createPair(v);
		}

		public function pointerReleasedLeft(v:Vektor) {
			for (var i = 0; i < balls.length; i++)
				balls[i].active = false;
		}

		public function pointerReleasedRight(v:Vektor):void {
		}

		public function get center():Vektor {
			return new Vektor(width / 2, height / 2);
		}
		
		public function incPoints():void {
			points++;
		}

	}
	
}