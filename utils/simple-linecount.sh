# note: does not strip multi-line comments

function cleanup {
  # remove empty lines or lines with only whitespace
  sed -i -e '/^[[:space:]]*$/d' $1
  # remove module headers
  sed -i -e '/^[[:space:]]*module /d' $1
  # remove section headers
  sed -i -e '/^[[:space:]]*section /d' $1
  # remove import statements
  sed -i -e '/^[[:space:]]*imports /d' $1
  # remove access control rules headers
  sed -i -e '/^[[:space:]]*access control rules/d' $1
  # remove commented out single lines
  sed -i -e '/^[[:space:]]*\/\//d' $1
  # remove lines with only { or }
  sed -i -e '/^[[:space:]]*[{}][[:space:]]*$/d' $1
}

function countlines {
  find . -name "*.app" | xargs cat > $1
  cleanup $1
  wc -l $1
}

function countlinesnobuiltin {
  find . -name "*.app" -not -path "*/.servletapp*" | xargs cat > $1
  cleanup $1
  wc -l $1
}

countlines merged-app.stats
countlinesnobuiltin merged-app-no-builtin.stats