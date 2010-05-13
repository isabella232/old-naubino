import java.util.*;
import java.util.concurrent.*;

public class Game {

	private static final Game instance = new Game();
	protected List<Ball> balls;
	protected List<Joint> joints;
	private double fieldSize;
	private double jointLength = 40;
	private double jointStrength = 0.1;
	private Vektor pointer;
	private Physics physics;
	
	public Ball active;
	public int width = 600;
	public int height = 400;
	
	private float ballsize = 15;
	private int refreshInterval = 50;

	public Vektor getCenter() {
		return new Vektor(width / 2, height / 2);
	}

	public void setPointer(Vektor pointer) {
		this.pointer = pointer;
	}
	
	public int getNumberOfJoints() {
		return joints.size();
	}

	private Timer timer;
	private TimerTask task = new TimerTask() {
		public void run() {
			refresh();
		}
	};

	private Game() {
		balls = new CopyOnWriteArrayList<Ball>();
		joints = new CopyOnWriteArrayList<Joint>();
		setFieldSize(320);
		pointer = getCenter();
		physics = new Physics(this);
		
		timer = new Timer();
		timer.schedule(task, 0, refreshInterval);
	}

	public static Game instance() {
		return instance;
	}

	public void refresh() {
		physik();
	}

	@SuppressWarnings("unused")
	private void gravity(Ball b) {
		b.acceleration.add(new Vektor(b.position, getCenter(), 
			4 / b.distanceTo(getCenter()).getLength()));
	}
	
	private void indirectGravity(Ball b) {
		//Vektor v = new Vektor(b.position, getCenter(),
		//		b.distanceTo(getCenter()).getLength() * 0.0001 + 0.2);
		Vektor difference = b.position.sub(getCenter());
		double length = difference.getLength();
		difference.setLength(length * 0.0001 + 0.2);
		b.accelerate(difference);
	}
	
	/* Federkraefte zwischen gejointen Baellen */
	private void swingBalls(Joint j) {
		Vektor real_diff   = j.a.position.sub(j.b.position);
		double real_length = real_diff.getLength();
		double wish_length = j.getLength(); 
		Vektor wish_diff   = Vektor.polar(real_diff.getAngle(), wish_length);
		Vektor force       = wish_diff.sub(real_diff);
		force = force.mul((real_length / wish_length) * j.getStrength());
		j.a.accelerate(force);
		j.b.accelerate(force.mul(-1));
	}
	
	/* Kollisions behandlung */
	private void collide(Collision c) {
		/* farben vergleichen
		 * TODO besseres Joinen von Balls*/
//		if (c.a.color.equals(c.b.color))
//			join(c.a, c.b);
		Vektor diff2 = c.diff.mul(0.05);
		c.a.accelerate(diff2.mul(-1));
		c.b.accelerate(diff2);
	}
	
	private void moveBall(Ball b) {
		b.speed = b.speed.add(b.acceleration);
		b.position = b.position.add(b.speed);
	}
	
	private void friction(Ball b) {
		b.accelerate(b.speed.mul(-0.2));
	}
	
	private void moveActiveBall() {
		active.accelerate(active.position.sub(pointer));
	}
	
	public void physik() {
		List<Collision> collisions = new LinkedList<Collision>();
		collisions = Collections.synchronizedList(collisions);
		int balls_count = balls.size();
		if (balls_count > 1) {
			for (int i = 0; i < balls_count-1; i++) {
				for (int j = i+1; j < balls_count; j++) {
				
					Collision collision = Collision.test(balls.get(i), balls.get(j));
					if (collision != null)
						collisions.add(collision);
				}
			}
		}
		if (active != null) moveActiveBall();
		
		for (Ball b : balls) {
			b.acceleration = new Vektor();
			// gravity(b);
			indirectGravity(b);
			//repulseOtherBalls(b);
			friction(b);
		}
		for (Collision c : collisions)
			collide(c);
		for (Joint j : joints)
			swingBalls(j);
		for (Ball b : balls)
			moveBall(b);
	}

	public void setFieldSize(float fieldSize) {
		this.fieldSize = fieldSize;
	}


	public Ball getBall(int index) {
		return balls.get(index);
	}

	private Ball createBall(Vektor v) {
		Ball ball = new Ball(v, ballsize);
		ball.color = Color.random();
		balls.add(ball);
		return ball;
	}

	private void createPair(Vektor v) {
		Vektor bla = new Vektor(1, 0).mul(jointLength / 2 + 1);
		Vektor pos1 = v.add(bla);
		Vektor pos2 = bla.sub(v);
		Ball ball1 = createBall(pos1);
		Ball ball2 = createBall(pos2);
		join(ball1, ball2);
	}

	/* nur benutzen wenn zwei neue Baelle gejoint werden */
	protected void join(Ball a, Ball b) {
		Joint joint = new Joint(a, b, jointLength, jointStrength);
		a.addJoint(joint);
		b.addJoint(joint);
		joints.add(joint);
	}

	/* ersetzt einen gleichfarbigen ball im spiel und kuemmert sich um alle Joints*/
	private void replaceBall(Ball a, Ball b) {
}
	
	private Ball collidingBall(Vektor v) {
		for (Ball b : balls)
			if (b.isHit(v))
				return b; // TODO more than one ball is clicked?
		return null;
	}

	public void restart() {
		balls.clear();
		joints.clear();
	}
	
	public void mousePressedLeft(Vektor v) {
		Ball b = collidingBall(v);
		if (b != null) active = b;
	}
	
	public void mousePressedRight(Vektor v) {
		createPair(v);
	}
	
	public void mouseReleasedLeft(Vektor v) {
		active = null;
	}
	
	public void mouseReleasedRight(Vektor v) {
	}
	
	public List<Ball> getBalls() {
		return balls;
	}

	public List<Joint> getJoints() {
		return joints;
	}

	private void setFieldSize(double fieldSize) {
		this.fieldSize = fieldSize;
	}

	public double getFieldSize() {
		return fieldSize;
	}
	
	protected Vektor getPointer() {
		return pointer;
	}
}
