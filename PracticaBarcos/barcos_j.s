@;=============== Fichero fuente de la práctica de los barcos  =================
@;== 	define las rutinas jugar() y sus rutinas auxiliares					  ==
@;== 	programador1: bernat.bosca@estudiants.urv.cat							  ==
@;== 	programador2: albert.canellas@estudiants.urv.cat							  ==


@;-- .text. código de las rutinas ---
.text	
		.align 2
		.arm


@; jugar(int dim, char tablero_disparos[]):
@;	rutina para realizar los lanzamientos contra el tablero de barcos iniciali-
@;	zado con la última llamada a B_incializa_barcos(), anotando los resultados
@;	en el tablero de disparos que se pasa por parámetro (por referencia), donde
@;	los dos tableros tienen el mismo tamaño (dim = dimensión del tablero de
@;	barcos). La rutina realizará los disparos necesarios hasta hundir todos los
@;	barcos, devolviendo el número total de disparos realizado.
@;	Parámetros:
@;		R0: dim; tamaño de los tableros (dimxdim)
@; 		R1: char tablero_disparos[]; dirección base del tablero de disparos
@;	Resultado:
@;		R0: número total de disparos realizados para completar la partida
		.global jugar
jugar:
		push {r1-r3, r5-r7, r9, r11, r12, lr}
		mov r10, r0						@; R10: dim=R0;
		mov r4, #0						@; R4: final_barcos
		mov r12, #0						@; R12: flag de tocat
		mov r11, #0						@; R11: tocats consecutius
		mov r5, #0						@; R5: flag de tocats consecutius
		.Lwhile23:
			cmp r4, #10
			bge .Lfinwhile23
			mov r0, r10					@; R0: dim (ho recupera de R10);
			bl fer_un_tret
			bl efectuar_disparo
			mov r8, r0					@; R8: copia el resultat del tir
			cmp r0, #2
			bge .L900
			cmp r12, #0
			ble .L900
			add r5, #1
			.L900:
			cmp r0, #2					@; R0: es el resultat del tir;
			bne .Lact12
			add r11, #1					@; R11: casilles tocades seguides
			mov r12, #1
			mov r7, r2					@; R7 i R9 sols si s'ha fet un tocat
			mov r9, r3					@; R7: fila; R9: columna
			.Lact12:
				cmp r5, #2
				bne .Lpera
				mov r11, #1
				.Lpera:
					cmp r5, #3
					blt .Lpoma
					add r11, #1
				.Lpoma:
				cmp r11, #4
				blt .Lban
				mov r11, #0
				.Lban:
				cmp r0, #3
				bne .Lendif
				add r4, #1					@; R4: final_barcos++;
				mov r12, #0					@; R12: marcador de barco enfonsat
				mov r11, #0
				mov r5, #0
			.Lendif:
			b .Lwhile23
		.Lfinwhile23:
		bl B_num_disparos				@; carrega a R0 el num_total_disparos		
		pop {r1-r3, r5-r7, r9, r11, r12, pc}



@; fer_un_tret(int *f, int *c, int dim, char tablero_disparos[]):
@;	rutina para calcular las coordenadas del nuevo disparo
@;	Parámetros:
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
@;		R0: dim; tamaño de los tableros (dimxdim)
@; 		R1: tablero_disparos[]; dirección base del tablero de disparos
@;		R8: resultado del disparo anterior
fer_un_tret:
		push {r0, r4-r5, r7-r9, r10-r11, lr}
		mov r6, r11						@; R6: tocats consecutius
		mov r11, r0						@; R11: guardem dim
		cmp r12, #0
		beq .Lfinbarc
		mul r5, r7, r0
		add r5, r9						@; R5: coordena si s'ha fet un tocat avans
		ldrb r8, [r1, r5]
		cmp r8, #'@'
		bne .Lfinbarc
		mov r4, r0
		sub r4, #1						@; R4: dim-1
		cmp r9, r4
		bge .Lif1						@; si esta al vorde per la columna saltar
		mov r10, r5
		add r10, #1
		ldrb r8, [r1, r10]				@; posicio coordena+1;
		cmp r8, #'?'
		bne .Lif1
		mov r2, r7
		mov r3, r9
		add r3, #1
		cmp r8, #'?'
		beq .Lfinal
		.Lif1:
			cmp r9, #0						@; si R9=0 saltar
			ble .Lif2						@; si esta al vorde per la columna saltar
			mov r10, r5
			sub r10, #1
			cmp r6, #2
			blt .L33
			sub r10, #1
			cmp r6, #3
			blt .L33
			sub r10, #1
			.L33:
			ldrb r8, [r1, r10]				@; posicio coordena-1;
			cmp r8, #'?'
			bne .Lif2
			mov r2, r7
			mov r3, r9
			sub r3, #1
			cmp r6, #2
			blt .L122
			sub r3, #1
			cmp r6, #3
			blt .L122
			sub r3, #1
			.L122:
			cmp r8, #'?'
			beq .Lfinbarc
			.Lif2:
				mov r4, r0
				sub r4, #1						@; R4: dim-1
				cmp r7, r4
				bge .Lif3						@; si esta al vorde per la fila saltar
				mov r10, r5
				mov lr, #0
				.Lburn:
				add lr, #1
				add r10, r0
				ldrb r8, [r1, r10]				@; posicio coordena+dim;
				cmp r8, #'@'
				beq .Lburn
				cmp r8, #'?'
				bne .Lif3
				mov r2, r7
				mov r3, r9
				add r2, lr
				cmp r8, #'?'
				beq .Lfinal
				.Lif3:
					cmp r7, #0						@; si R7=0 saltar
					ble .Lfinbarc					@; si esta al vorde per la fila saltar
					mov r10, r5
					sub r10, r0
					cmp r6, #2
					blt .L12
					sub r10, r0
					cmp r6, #3
					blt .L12
					sub r10, r0
					cmp r6, #4
					blt .L12
					sub r10, r0
					.L12:
					ldrb r8, [r1, r10]				@; posicio coordena-dim;
					cmp r8, #'?'
					bne .Lfinal
					mov r2, r7
					mov r3, r9
					sub r2, #1
					cmp r6, #2
					blt .L129
					sub r2, #1
					cmp r6, #3
					blt .L129
					sub r2, #1
					cmp r6, #4
					blt .L129
					sub r2, #1
					.L129:
					cmp r8, #'?'
					beq .Lfinal
		.Lfinbarc:		
		cmp r3, #0
		blt .Lif3
		mov r5, #0
		cmp r12, #0
		bne .Lfinal
			.Lwh:						@; sino tenim la coordena, es que hem
				cmp r5, #1				@; de fer un tir random
				bge .Lfinal
				mov r11, r0				@; R11: guardem dim
				bl mod_random
				mov r2, r0				@; conseguim fila random
				mov r0, r11				@; recuperem dim a R0
				bl mod_random
				mov r3, r0				@; conseguim columna random
				mov r0, r11				@; recuperem dim a R0
				mul r7, r2, r0			@; calculem coordena a R7
				add r7, r3
				ldrb r8, [r1, r7]		@; R8: carregem la posicio coordena
				cmp r8, #'?'
				bne .Lwh
				add r5, #1				@; R5 que es i++; per sortir
				b .Lwh
		.Lfinal:
		pop {r0, r4-r5, r7-r9, r10-r11, pc}



@; efectuar_disparo(int dim, char tablero_disparos[], int f, int c):
@;	rutina para efectuar un disparo contra el tablero de barcos inicializado
@;	con la última llamada a B_incializa_barcos(), anotando los resultados en
@;	el tablero de disparos que se pasa por parámetro (por referencia), donde los
@;	dos tableros tienen el mismo tamaño (dim = dimensión del tablero de barcos).
@;	La rutina realizará el disparo llamando a la función B_dispara(), y actuali-
@;	zará el contenido del tablero de disparos consecuentemente, devolviendo
@;	el código de resultado del disparo.
@;	Parámetros:
@;		R0: dim; tamaño de los tableros (dimxdim)
@; 		R1: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
@;	Resultado:
@;		R0: código del resultado del disparo (-1: ERROR, 0:REPETIT, 1: AGUA,
@;												2: TOCAT, 3: ENFONSAT)
efectuar_disparo:
		push {r1-r5, r7, r9, r10-r12, lr}
		mov r11, r0						@; R11: guardem dim
		mov r5, #0						
		add r5, r2, #65						@; R5: fila en char
		mov r0, r5 
		mov r12, r1							@; R12: guardem tablero_disparos[];
		mov r1, r3							@; ja tenim 'fila' y 'c' a R0 i R1
		add r1, #1
		bl B_dispara						@; R0: res_tir (retornat de B_dispara);
		mov r8, r0							@; R8: rep res_tir
		mul r6, r2, r11						
		add r6, r3							@; R6: coordena
		.Lswitch:
			mov r10, #0
			sub r10, #1						@; R10: -1
			cmp r0, r10						@; case -1
			beq .Lfinswitch	
			cmp r0, #0						@; case 0
			beq .Lfinswitch	
			cmp r0, #1						@; case 1
			bne .Lcase2	
			mov r10, #'.'					@; R2: '.';
			strb r10, [r12, r6]				@; guarda '.'
			b .Lfinswitch					@; saltar a fin
			.Lcase2:
				cmp r0, #2					@; case 2
				bne .Lcase3
				mov r10, #'@'					@; R2: '@';
				strb r10, [r12, r6]				@; guarda '@'
				bl coordena_ad_a
				bl coordena_ad_s
				bl coordena_sd_a
				bl coordena_sd_s
				b .Lfinswitch
				.Lcase3:
					mov r10, #'@'					@; R2: '@';
					strb r10, [r12, r6]				@; guarda '@'
					mul r0, r11, r11				@; R0: dim_total (dimxdim);
					mov r7, #0						@; R7: i=0;
					.Lbuclesico:
						cmp r7, r0
						bge .Lfinbuclesico
						ldrb r9, [r12, r7]			@; R9: coordena de la tabla en i lloc
						cmp r9, #'@'
						bleq voltejar_aigua			@; si R9='@' fer voltejar_aigua
						add r7, #1					@; i++;
						b .Lbuclesico
					.Lfinbuclesico:
					b .Lfinswitch
		.Lfinswitch:
		mov r0, r8							@; R0: recupera res_tir
		pop {r1-r5, r7, r9, r10-r12, pc}



@; voltejar_aigua(int casilla, int dim, char tablero_disparos[]) equival a:
@;	rutina para voltear de agua a un barco hundido
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
voltejar_aigua:
		push {r0, r2, r7, lr}
		bl coordena_sd_s
		bl coordena_sd
		bl coordena_sd_a
		bl coordena_s
		bl coordena_a
		bl coordena_ad_s
		bl coordena_ad
		bl coordena_ad_a
		pop {r0, r2, r7, pc}



@; coordena_ad_a() equival a:
@;	tablero_disparos[cooerdena+dim+1]; en c
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
coordena_ad_a:
		push {r2, r3, r4, lr}
		mov r4, r11						@; R4: dim-1
		sub r4, #1
		cmp r2, r4
		bge .Lnocan3
		cmp r3, r4
		bge .Lnocan3
		add r4, r6, r11
		add r4, #1						@; R4: coordena+dim+1
		ldrb r9, [r12, r4]				@; R9: puntero de coordena+dim+1
		cmp r9, #'?'					@; comprovar el que hi ha a R9
		bne .Lnocan3
		mov r2, #'.'					@; R2: '.';
		strb r2, [r12, r4]				@; guarda '.' a R9
		.Lnocan3:
		pop {r2, r3, r4, pc}



@; coordena_ad_s() equival a:
@;	tablero_disparos[cooerdena+dim-1]; en c
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
coordena_ad_s:
		push {r2, r3, r4, lr}
		mov r4, r11
		sub r4, #1
		cmp r2, r4
		bge .Lnocan2
		cmp r3, #0
		ble .Lnocan2
		add r4, r6, r11
		sub r4, #1						@; R4: coordena+dim-1
		ldrb r9, [r12, r4]				@; R9: puntero de coordena+dim-1
		cmp r9, #'?'					@; comprovar el que hi ha a R9
		bne .Lnocan2
		mov r2, #'.'					@; R2: '.';
		strb r2, [r12, r4]				@; guarda '.' a R9
		.Lnocan2:
		pop {r2, r3, r4, pc}



@; coordena_sd_a() equival a:
@;	tablero_disparos[cooerdena-dim+1]; en c
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
coordena_sd_a:
		push {r2, r3, r4, lr}
		mov r4, r11
		sub r4, #1
		cmp r2, #0
		ble .Lnocan3
		cmp r3, r4
		bge .Lnocan3
		sub r4, r6, r11
		add r4, #1						@; R4: coordena-dim+1
		ldrb r9, [r12, r4]				@; R9: puntero de coordena-dim+1
		cmp r9, #'?'					@; comprovar el que hi ha a R9
		bne .Lnocan1
		mov r2, #'.'					@; R2: '.';
		strb r2, [r12, r4]				@; guarda '.' a R9
		.Lnocan1:
		pop {r2, r3, r4, pc}



@; coordena_sd_s() equival a:
@;	tablero_disparos[cooerdena-dim-1]; en c
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
coordena_sd_s:
		push {r2, r3, r4, lr}
		cmp r2, #0
		ble .Lnocan3
		cmp r3, #0
		ble .Lnocan3
		sub r4, r6, r11
		sub r4, #1						@; R4: coordena-dim-1
		ldrb r9, [r12, r4]				@; R9: puntero de coordena-dim-1
		cmp r9, #'?'					@; comprova el que hi ha a R9
		bne .Lnocan
		mov r2, #'.'					@; R2: '.';
		strb r2, [r12, r4]				@; guarda '.' a R9
		.Lnocan:
		pop {r2, r3, r4, pc}



@; coordena_sd() equival a:
@;	tablero_disparos[cooerdena-dim]; en c
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
coordena_sd:
		push {r2, r3, r4, lr}
		cmp r2, #0
		ble .Lnocan13
		sub r4, r6, r11					@; R4: coordena-dim
		ldrb r9, [r12, r4]				@; R9: puntero de coordena-dim
		cmp r9, #'?'					@; comprovar el que hi ha a R9
		bne .Lnocan13
		mov r2, #'.'					@; R2: '.';
		strb r2, [r12, r4]				@; guarda '.' a R9
		.Lnocan13:
		pop {r2, r3, r4, pc}



@; coordena_ad() equival a:
@;	tablero_disparos[cooerdena+dim]; en c
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
coordena_ad:
		push {r2, r3, r4, lr}
		mov r4, r11
		sub r4, #1
		cmp r2, r4
		bge .Lnocan23
		add r4, r6, r11					@; R4: coordena+dim
		ldrb r9, [r12, r4]				@; R9: puntero de coordena+dim
		cmp r9, #'?'					@; comprovar el que hi ha a R9
		bne .Lnocan23
		mov r2, #'.'					@; R2: '.';
		strb r2, [r12, r4]				@; guarda '.' a R9
		.Lnocan23:
		pop {r2, r3, r4, pc}


@; coordena_a() equival a:
@;	tablero_disparos[cooerdena+1]; en c
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
coordena_a:
		push {r2, r3, r4, lr}
		mov r4, r11
		sub r4, #1
		cmp r3, r4
		bge .Lnocan24
		add r4, r6, #1					@; R4: coordena+1
		ldrb r9, [r12, r4]				@; R9: puntero de coordena+1
		cmp r9, #'?'					@; comprovar el que hi ha a R9
		bne .Lnocan24
		mov r2, #'.'					@; R2: '.';
		strb r2, [r12, r4]				@; guarda '.' a R9
		.Lnocan24:
		pop {r2, r3, r4, pc}



@; coordena_s() equival a:
@;	tablero_disparos[cooerdena-1]; en c
@;	Parámetros:
@;		R6: coordena
@;		R11: dim
@;		R12: tablero_disparos[]; dirección base del tablero de disparos
@;		R2: f; número de fila (0..dim-1)
@;		R3: c; número de columna (0..dim-1)
coordena_s:
		push {r2, r3, r4, lr}
		cmp r3, #0
		ble .Lnocan30
		sub r4, r6, #1					@; R4: coordena-1
		ldrb r9, [r12, r4]				@; R9: puntero de coordena-1
		cmp r9, #'?'					@; comprovar el que hi ha a R9
		bne .Lnocan30
		mov r2, #'.'					@; R2: '.';
		strb r2, [r12, r4]				@; guarda '.' a R9
		.Lnocan30:
		pop {r2, r3, r4, pc}


	
.end
