application test

define page root() {
}

test jsonarrayput{
  var a := JSONArray();
  a.put("asdfgh");
  assert(a.getString(0) == "asdfgh");
  var b := JSONObject("{abc:'123'}");
  a.put(b);
  assert(a.getJSONObject(1).getString("abc") == "123");
}
