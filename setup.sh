#!/bin/sh

replace () {
  for f in *.tsx *.ts
  do
    file_name=$1
    file_name_in_lower_camel_case="$(F="$file_name" node -p "process.env.F.replace(/-([a-z])/g, (_, p) => p.toUpperCase())")"

    if which gsed; then
      gsed -i "s/COMPONENT_NAME/$file_name_in_lower_camel_case/g" "$f"
      gsed -i "s/COMPONENT_FILE_NAME/$file_name/g" "$f"
    else
      sed -i "s/COMPONENT_NAME/$file_name_in_lower_camel_case/g" "$f"
      sed -i "s/COMPONENT_FILE_NAME/$file_name/g" "$f"
    fi

    if [ "$f" != "index.ts" ]; then
      mv "$f" "$(echo "$f" | sed "s/COMPONENT_FILE_NAME/$file_name/")"
    fi
  done
}

post_process () {
  rm setup.sh
}

if test -z "$1"
then
  echo コンポート名（ケバブケース）を指定してください
  echo './setup.sh component-name'
  exit 1
fi

set -xe

replace "$1"
post_process
