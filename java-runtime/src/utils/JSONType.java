package utils;

import com.google.gson.*;

public class JSONType {

	public static JsonObject parseJsonObject(String s) {
		return new JsonParser().parse(s).getAsJsonObject();
	}

	public static JsonArray parseJsonArray(String s) {
		return new JsonParser().parse(s).getAsJsonArray();
	}

	public static String toString(JsonElement e) {
		return new GsonBuilder().setPrettyPrinting().create().toJson(e);
	}

	public static JsonNull nullValue() {
		return JsonNull.INSTANCE;
	}

	public static JsonObject getJSONObject(JsonObject o, String key) {
		return o.get(key).getAsJsonObject();
	}

	public static JsonObject getJSONObject(JsonArray a, int index) {
		return a.get(index).getAsJsonObject();
	}

	public static JsonArray getJSONArray(JsonObject o, String key) {
		return o.get(key).getAsJsonArray();
	}

	public static JsonArray getJSONArray(JsonArray a, int index) {
		return a.get(index).getAsJsonArray();
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

	public static void put(JsonObject o, String key, boolean value) {
		o.addProperty(key, value);
	}

	public static void put(JsonArray a, boolean value) {
		a.add(value);
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
		return o.get(key).getAsString();
	}

	public static String getString(JsonArray a, int index) {
		return a.get(index).getAsString();
	}

	public static boolean getBoolean(JsonObject o, String key) {
		return o.get(key).getAsBoolean();
	}

	public static boolean getBoolean(JsonArray a, int index) {
		return a.get(index).getAsBoolean();
	}

	public static int getInt(JsonObject o, String key) {
		return o.get(key).getAsInt();
	}

	public static int getInt(JsonArray a, int index) {
		return a.get(index).getAsInt();
	}

	public static long getLong(JsonObject o, String key) {
		return o.get(key).getAsLong();
	}

	public static long getLong(JsonArray a, int index) {
		return a.get(index).getAsLong();
	}

	public static Double getDouble(JsonObject o, String key) {
		return o.get(key).getAsDouble();
	}

	public static Double getDouble(JsonArray a, int index) {
		return a.get(index).getAsDouble();
	}

}
