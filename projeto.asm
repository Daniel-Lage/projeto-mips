.macro print_str %string
	.data
		string: .asciiz %string
	.text
		li $v0, 4
		la $a0, string
		syscall
.end_macro

.macro print_str_l %label
	.text
		li $v0, 4
		la $a0, %label
		syscall
.end_macro

.macro print_int %address
	li $v0, 1
	move $a0, %address
	syscall
.end_macro

.macro print_float %address
	li $v0, 2
	mov.s $f12, %address
	syscall
.end_macro

.macro int_input
	li $v0, 5
	syscall
.end_macro

.macro float_input
	li $v0, 6
	syscall
.end_macro

.macro load_float %address %float
	.data
		float: .float %float
	.text
		l.s %address float
.end_macro

.data
	# Strings que eu uso mais de uma vez
	br: .asciiz "\n"
	s: .asciiz "s"
.text
	main:
		jal menu
	
		print_str "Opção inválida\n"

	end:
		print_str "Encerrando o programa"
		li $v0, 10 
		syscall
	
	menu:
		print_str "Digite um numero entre 1 e 8 para executar o procedimento de uma questão ou 9 para sair: "
		int_input

		beq $v0, 1, q1
		beq $v0, 2, q2
		beq $v0, 3, q3
		beq $v0, 4, q4
		beq $v0, 5, q5
		beq $v0, 6, q6
		beq $v0, 7, q7
		beq $v0, 8, q8
		beq $v0, 9, end

		jr $ra
	
	q1:
		print_str "Digite um valor inteiro em metros: "
		int_input
		move $s0, $v0
		
		print_str "O valor equivalente em decímetros é: "
		mul $s0, $s0, 10
		print_int $s0
		print_str_l br
		
		print_str "O valor equivalente em centímetros é: "
		mul $s0, $s0, 10
		print_int $s0
		print_str_l br
		
		print_str "O valor equivalente em milímetros é: "
		mul $s0, $s0, 10
		print_int $s0
		print_str_l br
		
		b menu

	q2:
		print_str "Digite o primeiro valor inteiro: "
		int_input
		move $s0, $v0
		
		print_str "Digite o segundo valor inteiro: "
		int_input
		add $s0, $s0, $v0
		
		print_str "Digite o terceiro valor inteiro: "
		int_input
		add $s0, $s0, $v0
		
		print_str "Digite o quarto valor inteiro: "
		int_input
		add $s0, $s0, $v0
		
		print_str "A soma dos quatro valores é: "
		print_int $s0
		print_str_l br
		
		b menu

	q3:
		print_str "Digite a primeira nota: "
		float_input
		mov.s $f1, $f0
		
		print_str "Digite a segunda nota: "
		float_input
		add.s $f1, $f1, $f0
		
		print_str "Digite a terceira nota: "
		int_input
		add.s $f1, $f1, $f0
		
		load_float $f0, 3
		div.s $f0, $f1, $f0
		
		print_str "A media aritmetica das três notas é: "
		print_float $f0
		print_str_l br
		
		b menu
	q4:
		print_str "Digite a primeira nota: "
		float_input
		mov.s $f1, $f0
		
		print_str "Digite o peso da primeira nota: "
		float_input
		mov.s $f3, $f0
		mul.s $f1, $f1, $f0
		
		print_str "Digite a segunda nota: "
		float_input
		mov.s $f2, $f0
		
		print_str "Digite o peso da segunda nota: "
		float_input
		add.s $f3, $f3, $f0
		mul.s $f2, $f2, $f0
		add.s $f1, $f1, $f2
		
		print_str "Digite a terceira nota: "
		float_input
		mov.s $f2, $f0
		
		print_str "Digite o peso da terceira nota: "
		float_input
		add.s $f3, $f3, $f0
		mul.s $f2, $f2, $f0
		add.s $f1, $f1, $f2
		
		print_str "A media ponderada das três notas é: "
		div.s $f1, $f1, $f3
		print_float $f1
		print_str_l br
		
		b menu
	q5: 
		print_str "Digite um valor positivo: "
		float_input
		
		# end if less than 0
		load_float $f1, 0
		c.lt.s $f0, $f1
		bc1t end
		
		print_str "O valor ao quadrado é: "
		mul.s $f1, $f0, $f0
		print_float $f1
		print_str_l br
		
		print_str "O valor ao cubo é: "
		mul.s $f1, $f1, $f0
		print_float $f1
		print_str_l br
		
		print_str "A raiz quadrada do valor é: "
		sqrt.s $f1, $f0
		print_float $f1
		print_str_l br
		
		# depois eu vejo como calcula a raiz cubica :)
		
		b menu
	q6:
		print_str "Digite seu ano de nascimento: "
		int_input
		
		la $s1, 2025
		sub $s0, $s1, $v0
		
		
		print_str "Sua idade após seu aniversario será: "
		print_int $s0
		print_str_l br
		
		add $s0, $s0, 2
		
		print_str "Sua idade após seu aniversario em 2027 será: "
		print_int $s0
		print_str_l br
		
		b menu
	q7:
		print_str "Digite um valor em segundos: "
		int_input
		move $s0, $v0
		
		blt $s0, 0, end
		
		print_int $s0
		print_str " segundo"
		
		bgt $s0, 1, if_1
		blt $s0, 1, if_1
		
		print_str " é 1 segundo"
		b period
		
		if_1:
			print_str "s são "
		end_if_1:
		
		la $s1, 60
		la $s2, 3600
		
		
		div $s0, $s2
		mflo $s3 # hours
		mfhi $s0 # minutes and seconds (in seconds)
		
		div $s0, $s1
		mflo $s4 # minutes
		mfhi $s5 # seconds
		
		beqz $s3, minutes
			
		print_int $s3
		print_str " hora"
			
		beq $s3, 1, one_hour
			
		print_str_l s
			
		one_hour:
			
		beqz $s0 period
			
		beqz $s4 if_2
		beqz $s5 if_2
			
		b if_3
			
		if_2:
			print_str " e "
				
			b minutes
		if_3:
			print_str ", "
		minutes:
			beqz $s4, seconds
			
			print_int $s4
			print_str " minuto"
			
			beq $s4, 1, one_minute
			
			print_str_l s
			
			one_minute:
			
			beqz $s5 period
			
			print_str " e "
			
		seconds:
			print_int $s5
			print_str " segundo"
			
			beq $s5, 1, one_second
			
			print_str_l s
			
			one_second:
			
		period:
			print_str ".\n"
		
		b menu
		
	q8:
		print_str "A seguir é o cardapio de uma lanchonete:\n"
		print_str "1: Hambúrguer (R$3,00)\n"
		print_str "2: Xbúrguer (R$2,50)\n"
		print_str "3: Fritas (R$2,50)\n"
		print_str "4: Refrigerante (R$1,00)\n"
		print_str "Digite um valor entre 1 e 4 para escolher um item ou 5 para encerrar a execução: "
		int_input

		load_float $f1, 3.0
		beq $v0, 1, item_chosen
		load_float $f1, 2.5
		beq $v0, 2, item_chosen
		beq $v0, 3, item_chosen
		load_float $f1, 1.0
		beq $v0, 4, item_chosen
		beq $v0, 5, total

		jr $ra

		item_chosen:
			print_str "Digite a quantidade do item: "
			float_input

			mul.s $f1, $f1, $f0
			add.s $f2, $f2, $f1
			b q8
		
		total:
			print_str "O preço total foi: "
			print_float $f2
			print_str_l br
			b menu
