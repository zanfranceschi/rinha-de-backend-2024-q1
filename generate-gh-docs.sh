#!/usr/bin/env bash

cd resultados || true

RESULT_LINE=""
HTML_FILES="$(ls ./*/*/index.html)"

for HTML_FILE in $HTML_FILES; do
  R_USER="$(echo "${HTML_FILE}" | cut -f2 -d/)"
  RESULT_LINE+="<li><a href=\"${HTML_FILE}\" alt=\"${R_USER}\">${R_USER}</a></li>
"
done

cat <<EOF > "index.html"

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Resultado testes por usu&aacute;rio</title>
</head>
<body>
<ul>
$RESULT_LINE
</ul>
</body>
</html>

EOF
