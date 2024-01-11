package utils;

import java.util.Arrays;

public class Tuple {

	public Object[] data;

	public Tuple(Object[] data) {
		super();
		this.data = data;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(data);
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Tuple other = (Tuple) obj;
		if (!Arrays.equals(data, other.data))
			return false;
		return true;
	}

}
