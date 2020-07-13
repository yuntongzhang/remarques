#!/bin/bash

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi

echo -e "\n\033[0;32mBuilding the new site...\033[0m"
hugo -D

echo -e "\n\n\033[0;32mCommitting to the static files folder...\033[0m"
cd public
git add .
git commit -m "$msg"

echo -e "\n\n\033[0;32mUpdating static files remote...\033[0m"
git push origin master

echo -e "\n\n\033[0;32mCommitting to the source files repo...\033[0m"
cd ..
git add .
git commit -m "$msg"

echo -e "\n\n\033[0;32mUpdating source files remote...\033[0m"
git push origin master

echo -e "\n\033[0;32mDone!\033[0m"
