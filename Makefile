# Project name
SOURCE          = hworld.c
ADDITIONAL      = 
# Get base name so we can create .elf file
NAME            = $(basename $(SOURCE))
# MSP430 MCU to compile for
CPU             = msp430g2553
# Optimisation level
OPTIMIZATION    = -O0
# Extra variables
CFLAGS          = -mmcu=$(CPU) $(OPTIMIZATION) -std=c99 -Wall -g -fomit-frame-pointer
# Libemb library link flags
LIBEMB          = -lconio -lserial

# Build and link executable
$(NAME).elf: $(NAME).o $(ADDITIONAL)
	msp430-gcc $(CFLAGS) -o $@ $(NAME).o $(ADDITIONAL) $(LIBEMB)
	msp430-objdump -D $(NAME).elf > $(NAME).hex

$(NAME).o: $(SOURCE)
	msp430-gcc -c $(CFLAGS) -o $(NAME).o $(SOURCE) $(LIBEMB)

# Flash to board with mspdebug
flash: $(NAME).elf
	mspdebug tilib "prog $(NAME).elf"

# Erase board
erase:
	mspdebug tilib erase

# Clean up temporary files
clean:
	rm -f *.elf *.hex *.o

# Remote debug board
debug: $(NAME).elf
	( mspdebug tilib "gdb" 1>/dev/null & ); msp430-gdb $(NAME).elf -ex "target remote :2000"

