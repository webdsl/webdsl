import java.io.*;
import java.util.Vector;

@Partial
class TheClass extends Bluebie implements Interface1, Interface2, Comparable {
	int a;
	int b;

	@Partial
	public void doSomething() {
		System.out.println("Hello there!");
	}
	
	public int newMethod() {
		int b = 5;
		return b;
	}
	class Test {
		
	}

}