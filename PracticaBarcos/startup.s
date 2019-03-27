@;=== startup function for ARM assembly programs ===
@;== 	programador1: bernat.bosca@estudiants.urv.cat							  ==
@;== 	programador2: albert.canellas@estudiants.urv.cat							  ==

.text
		.arm
		.global _start
	_start:
		bl randomize		@; initizalize the seed of the random numbers
		bl principal		@; call the main routine
	.Lstop:
		b .Lstop			@; endless loop

.end
