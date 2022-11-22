# ИДЗ № 3. Жуковский Дмитрий Романович БПИ219. Вариант 26 

## Условие задачи
```
 Разработать программу вычисления корня пятой степени согласно быстро сходящемуся итерационному алгоритму определения корня 
 n-той степени с точностью не хуже 0,1%.
```
Планируемая оценка: **6** 

## Этапы выполнения работы

1. Изначально была написана [root.c](https://github.com/bugovsky/CSA_IHW_03/blob/main/Programs/root.c) - программа на языке Си.
2. Проведем тестовые прогоны для [root.c](https://github.com/bugovsky/CSA_IHW_03/blob/main/Programs/root.c) ([тесты](https://github.com/bugovsky/CSA_IHW_03/tree/main/Tests) - с помощью них будет проверяться корректная работа программы):

![](https://github.com/bugovsky/CSA_IHW_03/blob/main/Images/c_tests.png)

Полученные значение сверялись с вычислениями, проводимыми на сервисе WolframAlpha. Вывод программы отличается в пределах допустимой погрешности, значит, программа на языке Си работает корректно.

3. Далее была произведена трансформация программы на языке Си с помощью команд, приведенных ниже: 
```
gcc -O0 -Wall -masm=intel -S -fno-asynchronous-unwind-tables -fcf-protection=none root.c
```

Была получена следующая программа - [root.s](https://github.com/bugovsky/CSA_IHW_03/blob/main/Programs/root.s)

4. Удалим все лишнее из ассемблерной программы (все, что **не влияет** на работу программы):
    - `	.file	"root.c"` -  информацию о названии файла, из которого программа была получена.
    - Информацию об экспорте символов методов:
    
       ```
        .type	calculateRoot, @function
        .type	main, @function
       ```
     - Информацию о трансформации кода в язык ассемблера:
     
       ```
      	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	    .section	.note.GNU-stack,"",@progbits
       ```
     - Информацию о размере функций:
       ```
        .size	calculateRoot, .-calculateRoot
        .size	main, .-main
       ```
     - Следующие объявления:
       ```
       .globl	calculateRoot
       ```
       `.globl	main` нужно оставить, иначе программу невозможно скомпилировать
     - Не забываем про макрос **leave**, его нужно заменить во всей программе на
        ```assembly
        mov rsp, rbp
        pop rbp
        ```
        Но если в прологе функции есть строка формата `sub rsp, x`, где `x` - количество байт, то тогда заменяем **leave** на следующие строки:
        ```assembly
        add rsp, x
        mov rsp, rbp
        pop rbp
        ```
5. Теперь ассемблерная программа очищена от лишних директив и макросов. Отметим, что программа на Си и на языке ассемблера используют локальные переменные и функции с передачей данных через параметры. Оптимизируем программу, используя максимальное количество регистров, после этого добавим в программу комментарии, поясняющие какой регистр представляет конкретную переменную. Добавим в программу комментарии касательно формальных и фактических параметров функции и переносе возвращаемого значения (связь между параметрами языка Си и **регистрами**)
6. [final_root.s](https://github.com/bugovsky/CSA_IHW_03/blob/main/Programs/final_root.s) - итоговая программа на языке ассемблера.
7. Проведем тестовые прогоны для [final_root.s](https://github.com/bugovsky/CSA_IHW_03/blob/main/Programs/final_root.s) и сравним эквивалентность функционирования данной программы и [root.c](https://github.com/bugovsky/CSA_IHW_03/blob/main/Programs/root.c)
    
![](https://github.com/bugovsky/CSA_IHW_03/blob/main/Images/asm_tests.png)  
	
Вывод ассемблерной программы отличается в пределах допустимой погрешности на каждом тесте, а также совпадает с результатами тестов программы на Си, заключаем, что модификация ассемблерной программмы произведена верно, и данная программа работает корректно.  

8. Сопоставление размеров: **TODO**
