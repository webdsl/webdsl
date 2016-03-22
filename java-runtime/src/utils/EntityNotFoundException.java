package utils;

public class EntityNotFoundException extends RuntimeException {
	public EntityNotFoundException(String entID){
		super("No entity with this identity found: "+ entID);
	}
}
