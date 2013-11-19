a=serial('COM5');
fopen(a);
a.baud=4800;
a.stopbit=1;
a.Terminator='CR';
