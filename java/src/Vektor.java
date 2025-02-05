/* relativer Vektor
 * ja ich habe es eingesehen
 * schön simpel ist er*/
public class Vektor {
	private double x;
	private double y;

	/* this used to be simple - now it just has tones of constructors */

	public void setX(double x) {
		this.x = x;
	}

	public double getX() {
		return x;
	}

	public void setY(double y) {
		this.y = y;
	}

	public double getY() {
		return y;
	}

	public double getLength() {
		return Math.sqrt(x*x + y*y);
	}

	public double getAngle() {
		return Math.atan2(y, x);

	}

	public Vektor setAngle(double a) {
		x = Math.cos(a) * this.getLength();
		y = Math.sin(a) * this.getLength();
		return this;
	}

	public Vektor add(Vektor v) {
		return new Vektor(x + v.getX(), y + v.getY());
	}

	public Vektor sub(Vektor v) {
		return new Vektor(x - v.getX(), y - v.getY());
	}

	public Vektor mul(double n) {
		double angle  = getAngle();
		double length = getLength();
		double x = Math.cos(angle) * length * n;
		double y = Math.sin(angle) * length * n;
		return new Vektor(x, y);
	}
	
	public Vektor norm() {
		double angle  = getAngle();
		double x = Math.cos(angle);
		double y = Math.sin(angle);
		return new Vektor(x, y);
	}

	public Vektor dump() {
		return new Vektor(this.x, this.x);
	}

	public Vektor(double nx, double ny) {
		x = nx;
		y = ny;
	}

	public Vektor() {
		x = 0;
		y = 0;
	}
	
	public static Vektor polar(double angle, double length) {
		double x = Math.cos(angle) * length;
		double y = Math.sin(angle) * length;
		return new Vektor(x, y);
	}
	
	public boolean equals(Object other) {
		if (other instanceof Vektor)
			return equals((Vektor)other);
		return super.equals(other);
	}
	
	public boolean equals(Vektor other) {
		return x == other.x && y == other.y;
	}
	
	public String toString() {
		return "{"+ x +", "+ y +"}";
	}
}
