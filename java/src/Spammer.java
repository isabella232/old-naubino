import java.util.Random;

class Spammer {

	private Game game;
	private Random rand = new Random();

	public Spammer(Game game) {
		this.game = game;
	}

	private double randomAngle() {
		return rand.nextDouble() * Math.PI * 2;
	}

	public void randomPair() {
		// TODO create pair just outside of visible frame
		double field_size = game.getFieldSize();
		Vektor v = Vektor.polar(randomAngle(), (field_size));
		v = game.getCenter().add(v);
		game.createPair(v);
	}
}
