package utils;

public class InvalidArgumentsException extends RuntimeException {

  public InvalidArgumentsException(int expected, int actual) {
    super(String.format("Expected %d arguments, but received %d", expected, actual));
  }
  
}
