import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Game {

	private static final Game instance = new Game();
	private List<Ball> balls;
	private List<Joint> joints;
	private float fieldSize;
	public Ball active;
	private float ballsize = 30;

	 /*
	 * TODO Paare automatisch generieren
	 * TODO Driften von Paaren
	 * TODO Zylensuche
	 * TODO auf Graph abbilden -> zB um unnoetige Joints zu entfernen
	 * TODO State fuer Pairs {drifting, resting} TODO MVC Model fehlt noch
	 */

	private Game() {
		balls = new ArrayList<Ball>();
		joints = new ArrayList<Joint>();
		setFieldSize(320f);

	}

	public static Game instance() {
		return instance;
	}

	public void refresh(){
		/* TODO refresh wird die Position von sich selbst bewegenden Objekten aktuallisieren
		 * im prinzip main loop der Spiellogik*/

	}
	
	public void setFieldSize(float fieldSize) {
		this.fieldSize = fieldSize;
	}

	public float getFieldSize() {
		return fieldSize;
	}

	public List<Ball> getBalls() {
		return balls;
	}

	public List<Joint> getJoints() {
		return joints;
	}

	public Ball getBall(int index) {
		return balls.get(index);
	}

	private Ball createBall(float x, float y) {
		Ball ball = new Ball(x, y, ballsize);
		ball.color = randomColor();
		balls.add(ball);
		return ball;
	}

	public void createPair(float x, float y) {
		join(createBall(x - 20, y - 20), createBall(x + 20, y + 20));
	}

	public void createTriple(float x, float y) {
		Ball a = createBall(x + 20, y - 20);
		Ball b = createBall(x - 20, y - 20);
		Ball c = createBall(x, y + 20);
		join(a, b);
		join(b, c);
		//join(c, a);
	}

	private void join(Ball a, Ball b) {
		Joint joint = new Joint(a, b);
		a.addJoint(joint);
		b.addJoint(joint);
		joints.add(joint);
	}


	private Color randomColor() {
		List<Color> list = new ArrayList<Color>();
		Color red = new Color(255, 100, 100, "red");
		Color green = new Color(100, 255, 100, "green");
		Color blue = new Color(100, 100, 255, "blue");
		Color purple = new Color(255, 100, 255, "purple");
		Color yellow = new Color(255, 255, 100, "yellow");

		list.add(red);
		list.add(green);
		list.add(blue);
		list.add(purple);
		list.add(yellow);

		Random rand = new Random();

		return list.get(rand.nextInt(list.size()));
	}

	public Ball clickedBall(float x, float y) {
		for (Ball b : balls) {
			if (b.isHit(new Coordinate(x, y))) {
				this.active = b;
				return b;
			}
		}
		return null;
	}

	public void checkForHits(float x, float y) {
		for (Ball b : balls) {
			if (b.isHit(new Coordinate(x, y))) {
				b.color = new Color(0, 0, 255);
			}
		}
	}

	public Ball checkForCollisions(Ball active) {
		for (Ball b : balls) {
			float distance = (float) Math.sqrt(Math.pow(b.getX()
					- active.getX(), 2)
					+ Math.pow(b.getY() - active.getY(), 2));

			/* TODO Collisionen mit sich selbst schoener vermeiden */
			if (distance > 0 && distance <= ballsize
					&& b.color.name == active.color.name) {
				return b;
			}
		}
		return null;
	}

	/* deletes all balls */
	public void resetBalls() {
		balls = new ArrayList<Ball>();
	}

	/* deletes all joints */
	public void resetJoints() {
		joints = new ArrayList<Joint>();
	}

	/* deletes orphaned joints */
	public void cleanUpJoints() {
		for (Joint j : joints) {
			if (j.a == null || j.b == null)
				joints.remove(j);
		}
	}

	

	/* anstaendige Move funktion einfuegen */
	public void dragActive(float x, float y) {
		
		active = clickedBall(x, y);
		if (active != null) {
			active.move(x, y);
			Ball collidor = checkForCollisions(active);

			if (collidor != null) {
				active.resetJoints();
				balls.remove(active);
				// removeBall(active);
				// join(taily, collidor);
			}
		}
	}

}
