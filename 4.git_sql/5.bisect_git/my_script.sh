!#/bin/bash

# Ініціалізуйте репозиторій, введіть ім’я, адресу електронної пошти до файлу .config 

echo -e "\n\n************* СТВОРЕННЯ РЕПОЗИТОРІЯ ТА КОНФІГУРАЦІЯ\n\n" 

rm -rf git-test ; mkdir git-test ; cd git-test 
git init 
git config user.name "A Smart Guy" 
git config user.email "asmartguy@linux.com" 

2. 

echo -e "\n\n*************     СТВОРЕННЯ КІЛЬКОХ ФАЙЛІВ ТА ДОДАВАННЯ " 
echo -e "                      ЇХ ДО ПРОЄКТУ І КОММІТ\n\n" 
n=0 
while [ $n -lt 64 ] ; do 
    n=$(($n+1)) 
    file=file$n 
    echo file > $file  
    if [ "$n" == "19" ] ; then 
        echo BAD >> $file 
    fi 
    git add $file 
    git commit $file -s -m"$file" 
    git tag $file 
    echo I added and committed $file 
done 

echo -e "\n\n************* Я ВНЕСУ РЯДОК З ВАДОЮ ДО file19\n\n" 

3. 

echo -e "\n\n************* ЗАПУСК БІСЕКЦІЇ\n\n" 

git bisect start 
git bisect bad 
git bisect good file1 

echo -e "\n\n************* ПОШУК ФАЙЛУ З ВАДОЮ\n\n" 

echo -e "\n\n************* ПРОВЕДЕННЯ БІСЕКЦІЇ ВРУЧНУ\n\n" 

over=0 
while [ "$over" == "0" ] ; do 
    if [ "$(grep BAD file*)" == "" ] ; then 
        git bisect good | tee gitout 
    else 
        git bisect bad | tee gitout 
    fi 
    if [ "$(grep 'revisions left' gitout)" == "" ] ; then 
        over=1 
        echo "****************** ВАДУ ЗНАЙДЕНО!" 
    fi 
done 

4. 

echo -e "\n\n*************** НАЛАШТУВАННЯ ТЕСТОВОГО СКРИПТА \n\n" 

cat <<EOF > my_script.sh 
#!/bin/bash 
if [ "\$(grep BAD file*)" == "" ] ; then 
    exit 0 
fi 
exit 1 
EOF 