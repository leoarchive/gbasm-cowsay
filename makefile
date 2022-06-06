default:
	rgbasm -L -o cowsay.o cowsay.asm; rgblink -o cowsay.gb cowsay.o; rgbfix -v -p 0xFF cowsay.gb

clean:
	rm *.gb *.o