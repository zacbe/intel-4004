program main;
uses
	scanner,parsertest;
begin
	if ParamCount < 1 then
	begin
		writeln('Nescesito: ', ParamStr(0), '+ archivo a scannear');
		halt;
	end
	else
	begin
		inicializarscanner;
		if parseprogram then
		begin
			writeln('ok parseado exitoso')
		end
		else
		begin
		writeln('Error, parseado detenido...')
		end;
	end;
	close(F);
end.
