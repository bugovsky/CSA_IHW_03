	.intel_syntax noprefix
	.text
calculateRoot:
	push	rbp									# Пролог функции
	mov	rbp, rsp

	movapd	xmm4, xmm0							# В регистре xmm4 храним значение double prev - первый формальный аргумент функции
	movapd	xmm5, xmm1							# В регистре xmm5 храним значение double curr - второй формальный аргумент функции
	movapd	xmm6, xmm2							# В регистре xmm6 храним значение double num - третий формальный аргумент функции
	movapd	xmm7, xmm3							# В регистре xmm7 храним значение double eps - четвертый формальный аргумент функции
	movsd	xmm2, QWORD PTR .LC1[rip]			# Загружаем в xmm2 значение 5.0
	jmp	.L2										# Безусловный переход к .L2
.L3:
	movapd	xmm4, xmm5							# Обновляем prev - присваиваем значение curr и сохраняем в xmm4
	movapd	xmm1, xmm4							# Кладем в регистр xmm1 значение double prev
	movsd	xmm0, QWORD PTR .LC0[rip]			# Кладем в регистр xmm0 число 4.0
	mulsd	xmm1, xmm0							# Аналог записи в Си-программе 4 * prev, сохранили в xmm1
	movapd	xmm0, xmm4							# Кладем в регистр xmm0 значение double prev
	mulsd	xmm0, xmm0
	mulsd	xmm0, xmm0							# Возвели в 4 степень значение prev
	movapd	xmm3, xmm6							# Сохраняем в xmm3 значение double num
	divsd	xmm3, xmm0							# Делим number на prediction в 4 степени
	addsd	xmm1, xmm3							# В регистр xmm1 кладем результат выражения (4 * prev + num / (prev * prev * prev * prev))
	divsd	xmm1, xmm2							# Получили значение double current, сохранили в регистре xmm1 (поделили значение регистра xmm1 на 5.0)
	movapd	xmm5, xmm1							# Кладем полученное значение в xmm5
.L2:
	movapd	xmm3, xmm7							# Кладем в регистр xmm3 значение double eps
	movapd	xmm0, xmm4							# В регистр xmm0 кладем double prev
	subsd	xmm0, xmm5							# Сохраняем разницу между double prev и double curr в xmm0
	movq	xmm1, QWORD PTR .LC2[rip]
	andpd	xmm0, xmm1
	comisd	xmm0, xmm3
	ja	.L3										# Если fabs(prev - curr) > eps,  то продолжаем работу цикла, переход к метке .L3
	movapd	xmm0, xmm5							# Иначе кладем в регистр xmm0 значение curr - значение, возвращаемое из функции
	pop	rbp
	ret
	.section	.rodata
.LC3:
	.string	"%lf"
.LC5:
	.string	"%lf\n"
	.text
	.globl	main
main:
	push	rbp									 # Пролог функции
	mov	rbp, rsp
	sub	rsp, 48

	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax

	lea	rsi, -40[rbp]							# В регистр rsi кладем адрес переменной double number - второй фактический аргумент функции scanf
	lea	rdi, .LC3[rip]							# В регистр rdi кладем информацию, что вводится тип double - первый фактический аргумент функции scanf
	mov	eax, 0
	call	__isoc99_scanf@PLT					# Вызов функции scanf

	movsd	xmm4, QWORD PTR -40[rbp]			# Кладем в регистр xmm4 значение переменной double number
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	jp	.L6
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	jne	.L6										# Осуществляем проверку на 0, если ввели НЕ 0, то переходим к метке .L6
	movapd	xmm0, xmm4							# Иначе передаем в регистр xmm0 число 0 - второй фактический аргумент функции printf
	lea	rdi, .LC5[rip]							# Загружаем информацию о том, что выводим числа типа double - первый фактический аргумент функции printf
	mov	eax, 1
	call	printf@PLT							# Вызов функции printf - вывод числа
	mov	eax, 0
	jmp	.L9										# Безусловный переход к .L9
.L6:
	movsd	xmm5, QWORD PTR .LC6[rip]           # Кладем в xmm5 число 0.001 (double eps)

	movsd	xmm0, xmm4							# Загружаем в xmm0 значение double number
	movsd	xmm2, QWORD PTR .LC1[rip]			# Загружаем в xmm2 значение 5.0
	divsd	xmm0, xmm2							# Делим значение double number на 5.0
	movapd	xmm6, xmm0                          # Кладем в регистр xmm6 значение выражения double prediction

	movapd	xmm1, xmm6							# Кладем в регистр xmm1 значение double prediction
	movsd	xmm0, QWORD PTR .LC0[rip]			# Кладем в регистр xmm0 число 4
	mulsd	xmm1, xmm0							# Аналог записи в Си-программе 4 * prediction, сохранили в xmm1
	movapd	xmm0, xmm6							# Кладем в регистр xmm0 значение double prediction
	mulsd	xmm0, xmm0
	mulsd	xmm0, xmm0							# Возвели в 4 степень значение prediction
	movapd	xmm3, xmm4							# Сохраняем в xmm3 значение double number
	divsd	xmm3, xmm0							# Делим number на prediction в 4 степени
	addsd	xmm1, xmm3							# В регистр xmm1 кладем результат выражения (4 * prediction + number / (prediction * prediction * prediction * prediction))
	divsd	xmm1, xmm2							# Получили значение double current, сохранили в регистре xmm1 (поделили значение регистра xmm1 на 5.0)
	movapd	xmm7, xmm1							# Кладем полученное значение в xmm7 (double current)
	
	movapd	xmm3, xmm5							# Кладем в xmm3 четвертый фактический параметр функции calculateRoot - eps
	movapd	xmm2, xmm4							# Кладем в xmm2 третий фактический параметр функции calculateRoot - number
	movapd	xmm1, xmm7							# Кладем в xmm1 второй фактический параметр функции calculateRoot - current
	movapd	xmm0, xmm6							# Кладем в xmm0 первый фактический параметр функции calculateRoot - prediction
	call	calculateRoot						# Вызов функции calculateRoot

												# Второй фактический аргумент printf хранится в регистре xmm0 - то, что вернула функция calculateRoot (double current)
	lea	rdi, .LC5[rip]							# Загружаем информацию, что будет выведено число типа double - первый фактический аргумент printf
	mov	eax, 1
	call	printf@PLT							# Выводим число (корень 5-ой степени из введенного числа)
	mov	eax, 0									# Завершаем программу с нулевым кодом возврата
.L9:
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	add     rsp, 48					        	# Эпилог функции
	mov     rsp, rbp
	pop     rbp
	ret
	ret
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1074790400
	.align 8
.LC1:
	.long	0
	.long	1075052544
	.align 16
.LC2:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.align 8
.LC6:
	.long	-755914244
	.long	1062232653
