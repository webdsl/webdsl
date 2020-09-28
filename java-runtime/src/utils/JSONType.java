package utils;

import org.webdsl.logging.Logger;

import com.google.gson.*;

public class JSONType {

	public static JsonObject parseJsonObject(String s) {
	  JsonObject obj = null;
	  try {
	    JsonElement elem = new JsonParser().parse(s);
	    obj = elem.getAsJsonObject();
	  } catch(Exception ex) {
	    Logger.error("Something went wrong getting json object from string", ex);
	  }
		return obj;
	}

	public static JsonArray parseJsonArray(String s) {
    JsonArray arr = null;
    try {
      JsonElement elem = new JsonParser().parse(s);
      arr = elem.getAsJsonArray();
    } catch(Exception ex) {
      Logger.error("Something went wrong getting json array from string", ex);
    }
    return arr;
	}

	public static String toString(JsonElement e) {
		return new GsonBuilder().setPrettyPrinting().create().toJson(e);
	}

	public static JsonNull nullValue() {
		return JsonNull.INSTANCE;
	}
	
  public static Boolean isJSONArray(JsonElement e) {
    return e.isJsonArray();
  }
  public static Boolean isJSONObject(JsonElement e) {
    return e.isJsonObject();
  }

	public static JsonObject getJSONObject(JsonObject o, String key) {
		JsonElement e = o.get(key);
		return e.isJsonNull() ? null : e.getAsJsonObject();
	}

	public static JsonObject getJSONObject(JsonArray a, int index) {
		JsonElement e = a.get(index);
		return e.isJsonNull() ? null : e.getAsJsonObject();
	}

	public static JsonArray getJSONArray(JsonObject o, String key) {
		JsonElement e = o.get(key);
		return e.isJsonNull() ? null : e.getAsJsonArray();
	}

	public static JsonArray getJSONArray(JsonArray a, int index) {
		JsonElement e = a.get(index);
		return e.isJsonNull() ? null : e.getAsJsonArray();
	}

	public static JsonNull getJSONNull(JsonObject o, String key) {
		return o.get(key).getAsJsonNull();
	}

	public static JsonNull getJSONNull(JsonArray a, int index) {
		return a.get(index).getAsJsonNull();
	}

	public static void put(JsonObject o, String key, String value) {
		o.addProperty(key, value);
	}

	public static void put(JsonArray a, String value) {
		a.add(value);
	}

	public static void put(JsonObject o, String key, java.util.UUID value) {
		o.addProperty(key, value.toString());
	}

	public static void put(JsonArray a, java.util.UUID value) {
		a.add(value.toString());
	}

	// Boolean instead of boolean, autoboxing causes NPE when a null value of type Boolean is passed to primitive boolean argument

	public static void put(JsonArray a, Boolean value) {
		a.add(value);
	}

	public static void put(JsonObject o, String key, Boolean value) {
		o.addProperty(key, value);
	}

	public static void put(JsonObject o, String key, Number value) {
		o.addProperty(key, value);
	}

	public static void put(JsonArray a, Number value) {
		a.add(value);
	}

	public static void put(JsonObject o, String key, JsonElement value) {
		o.add(key, value);
	}

	public static void put(JsonArray a, JsonElement value) {
		a.add(value);
	}

	public static int length(JsonArray a) {
		return a.size();
	}

	public static String getString(JsonObject o, String key) {
		JsonElement e = o.get(key);
		return e.isJsonNull() ? null : e.getAsString();
	}

	public static String getString(JsonArray a, int index) {
		JsonElement e = a.get(index);
		return e.isJsonNull() ? null : e.getAsString();
	}

	public static Boolean getBoolean(JsonObject o, String key) {
		JsonElement e = o.get(key);
		return e.isJsonNull() ? null : e.getAsBoolean();
	}

	public static Boolean getBoolean(JsonArray a, int index) {
		JsonElement e = a.get(index);
		return e.isJsonNull() ? null : e.getAsBoolean();
	}

	public static Integer getInt(JsonObject o, String key) {
		JsonElement e = o.get(key);
		return e.isJsonNull() ? null : e.getAsInt();
	}

	public static Integer getInt(JsonArray a, int index) {
		JsonElement e = a.get(index);
		return e.isJsonNull() ? null : e.getAsInt();
	}

	public static Long getLong(JsonObject o, String key) {
		JsonElement e = o.get(key);
		return e.isJsonNull() ? null : e.getAsLong();
	}

	public static Long getLong(JsonArray a, int index) {
		JsonElement e = a.get(index);
		return e.isJsonNull() ? null : e.getAsLong();
	}

	public static Double getDouble(JsonObject o, String key) {
		JsonElement e = o.get(key);
		return e.isJsonNull() ? null : e.getAsDouble();
	}

	public static Double getDouble(JsonArray a, int index) {
		JsonElement e = a.get(index);
		return e.isJsonNull() ? null : e.getAsDouble();
	}

}
