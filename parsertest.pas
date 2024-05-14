{$define debug}
unit parsertest;
interface

function parseprogram:boolean;
function seccionstatement:boolean;{+---statement}

implementation
uses
	scanner,traductor;
var
	aux:TToken;
	scanneravance:boolean;
	tabs:integer;
	aux2:TToken;

function block:boolean;forward;
function Expresion:boolean;forward;
	
procedure err(T:TToken);
begin
	writeln ('error en columna: ',columna,' fila: ',fila,' se encontró: ', T.Nombre);
end;
procedure scanneravanzar;
begin
	scanneravance:=true;
end;
function siguientetoken:TToken;		
begin
	if scanneravance then
	begin
		aux:=Estado0;
		scanneravance:=false;
	end;
	siguientetoken:=aux;
end;

procedure imprimirtab;
var
	i:integer;
begin
	for i:=0 to tabs do
	write('|',#32);
end;

function Factor: boolean;
var 
	R: boolean;
	T: TToken;
	id:string;
	numero:integer;
begin{begin factor}	
	tabs:=tabs+1;
	{imprimirtab;}
	{writeln('+---SECCION Factor:');}
	R:= True;
	{scanneravanzar;}
	T:= siguientetoken;
	if T.Tipo = TOKEN_IDENTIFICADOR then
	begin
		id:=T.Nombre;
		{imprimirtab;}
	    	{writeln('+---TOKEN ID: ',T.Nombre);}
		TraductorFactorID(id);
	    	scanneravanzar;
	    	T:= siguientetoken;
	end;
	T:= siguientetoken;
	if T.Tipo = TOKEN_ENTERO then
	begin
		numero:=T.ValorI;
	    	{imprimirtab;}
	    	{writeln('+---TOKEN NUMBER',T.ValorI);}
		TraductorFactorIN(numero);
	    	scanneravanzar;
	    	T:= siguientetoken;   
	end;
	T:= siguientetoken;
	if T.Tipo = TOKEN_PARENTESIS_ABRE then
	begin
		{imprimirtab;}
	    	{writeln('+---TOKEN PARENTESIS ABRE',T.Nombre);}
	    	scanneravanzar;
	    	T:= siguientetoken;
	    	R:=Expresion();
	if T.Tipo = TOKEN_PARENTESIS_CIERRE then
    	begin 	
		{imprimirtab;}
	    	{writeln('+---TOKEN PARENTESIS CIERRA',T.Nombre);}
		end;
	end;
	T:= siguientetoken;
	if R then
	begin
       		{writeln('+---oli',T.Nombre);}	
		Factor:=true;
	end
	else
	begin
	   Factor:=false;
	end;
	tabs:=tabs-1;
end;{end factor}

function term: boolean;
var 
	R: boolean;
	T: TToken;
	opr:string;
begin  {begin de term}
	tabs:=tabs+1;
	{imprimirtab;}
	{writeln('+---SECCION TERM');}
	T:=  siguientetoken;	
	R:= True;
	R:=Factor;
	T:=  siguientetoken;
	repeat
		if (T.Tipo = TOKEN_POR) or (T.Tipo= TOKEN_ENTRE) then
		begin
	    		opr:=T.Nombre;
	    		scanneravanzar;
	    		R:=Factor;
			TraductorTerm(opr);
	    		{scanneravanzar;
	   		 T:= siguientetoken;}
		end;
	until (T.Tipo <> TOKEN_POR) or (T.Tipo <> TOKEN_ENTRE); 	
	if R then
	begin
	   	term:=true;
	end
	else
	begin
	   	term:=false;
	end;
	tabs:=tabs-1;
end; {end de term}

function Expresion: boolean;
function recursiva:boolean;
var 
	R: boolean;
	T: TToken;
	opr:string;
begin{begin recursiva}
	tabs:=tabs+1;	
	T:=siguientetoken;
	{imprimirtab;}
	{writeln('+---SECCION RECURSIVA');}
	if T.Tipo = TOKEN_MAS then
	begin
		opr:=T.Nombre;
		{imprimirtab;}
		{writeln('+---TOKEN MAS: ',T.Nombre);}
		scanneravanzar;
		T:= siguientetoken;
		R:= term;
		if R then
		begin
			TraductorExpresion(opr);
		end;
	end;
	if T.Tipo = TOKEN_MENOS then
	begin  
		opr:=T.Nombre;
		{imprimirtab;}
		{writeln('+---TOKEN MENOS: ',T.Nombre);}
		scanneravanzar;
		T:= siguientetoken;
		R:= term;
		if R then
		begin
			TraductorExpresion(opr);
		end;
	end;
	T:=  siguientetoken;
	R:= term;
       	T:=  siguientetoken;
	if (T.Tipo = TOKEN_MAS) or (T.Tipo = TOKEN_MENOS) then
	begin		
		R:=recursiva();
	end;
	if R then
        begin
          	recursiva:=true;
	end
	else
	begin
		recursiva:=false;
	end;
	tabs:=tabs-1;
end;{end recursiva}	
var 
	R: boolean;
	T: TToken;
begin {begin expresion}
	tabs:=tabs+1;
	{scanneravanzar;}
	T:=  siguientetoken;

	{imprimirtab;}
	{writeln('+---SECCION EXPRESION');}
	R:= True;
	R:= recursiva;
	T:=  siguientetoken;
	if R then
	begin
		expresion:=true;
		
	end
	else
	begin
		expresion:=false;
	end;	
	tabs:=tabs-1;
end; {end de Expresion}

function Condition: boolean;
var
	R : boolean;
	T : TToken;
	id:string;
begin{begin condition}
	tabs:=tabs+1;		
	{imprimirtab;}
	{writeln('+---SECCION CONDITION');}
	{scanneravanzar;}
	T := siguientetoken;
	R:=true;
	if T.Tipo= TOKEN_ODD then
	begin
		
		{imprimirtab;}
		{writeln('+---TOKEN ODD: ',T.Nombre);}
		writeln(#9'OPR'#9'0'#9,T.Nombre);
		scanneravanzar;
		R:=expresion;	
	end
	else
	begin
		R:=expresion;
		
		T := siguientetoken;
		{writeln(T.Tipo);}
		case T.Tipo of
			TOKEN_IGUAL	:id:=T.Nombre;
			TOKEN_DIFERENTE	:id:=T.Nombre;
			TOKEN_MENOR	:id:=T.Nombre;
			TOKEN_MAYOR		:id:=T.Nombre;
			TOKEN_MENOR_IGUAL	:id:=T.Nombre;
			TOKEN_MAYOR_IGUAL	:id:=T.Nombre;			
		end;
		scanneravanzar;
		R:=expresion;
		writeln(#9'OPR'#9'0'#9,id);
	end;
	if R then
	begin
	Condition:=true;
	end
	else
	begin
	Condition:=false;
	end;
	tabs:=tabs-1;		
end;{end condition}

function statement_ident:boolean;
var	
	R : boolean;
	T : TToken;
	id:string;
begin{begin statement_ident}
	tabs:=tabs+1;
	{imprimirtab;}
	{writeln('+---SECCION STATEMENT_ID');}		
	scanneravanzar;
	id:=aux2.Nombre;
	
	T:= siguientetoken;
	if T.Tipo = TOKEN_ASIGNACION then
	begin
		{imprimirtab;}
		{writeln('+---TOKEN ASIGNACION: ',T.Nombre);}
		scanneravanzar;								
	end;
		T:= siguientetoken;
		R:= Expresion;
		T:= siguientetoken;
	if R then
	begin	
		statement_ident:=true;
		TraductorStatementIdent(id);
	end
	else
	begin
		statement_ident:=false;
	end;
	tabs:=tabs-1;
end;{end statement_ident}

function statement_call:boolean;
var		
	R : boolean;
	T : TToken;
	id:string;
begin{begin statement_call}
	tabs:=tabs+1;
	{imprimirtab;}
	{writeln('+---SECCION STATEMENT_CALL');}		
	scanneravanzar;
	
	T:= siguientetoken;
	if T.Tipo = TOKEN_IDENTIFICADOR then
	begin
		id:=T.Nombre;
		{imprimirtab;}
		{writeln('+---TOKEN ID: ',T.Nombre);}
		scanneravanzar;
		TraductorStatementCall(id);
	end;
	T:= siguientetoken;
	if R then 
	begin
		statement_call:=true;
	end
	else
	begin
		statement_call:=false;
	end;
	tabs:=tabs-1;	 			
end;{end statement_call}	
function statement_begin:boolean;
var	
	R : boolean;
	T : TToken;
begin{begin statement begin}
	tabs:=tabs+1;
	{imprimirtab;}
	{writeln('+---SECCION STATEMENT BEGIN');}
	R:=true;
	repeat
		scanneravanzar;
		T:= siguientetoken;
		R:=seccionstatement;
		T:= siguientetoken;
					
	until T.Tipo <> TOKEN_PUNTO_COMA;

	scanneravanzar;
	T:= siguientetoken;
	if T.Tipo = TOKEN_END then
	begin
		{imprimirtab;}
		{writeln('+---TOKEN END: ',T.Nombre);}
		{scanneravanzar;}
		T:= siguientetoken;
      	end;
		T:= siguientetoken;
	if R then
	begin		
		statement_begin:=true;
	end
	else
	begin
		statement_begin:=false;
	end;
	tabs:=tabs-1;
end;{end statement begin}
function statement_if:boolean;
var	
	R : boolean;
	T : TToken;
begin{begin statement if}
	tabs:=tabs+1;
	numIf:=numIf+1;
	{imprimirtab;}
	{writeln('+---SECCION STATEMENT IF');}
	scanneravanzar;
	T:= siguientetoken;
	R:=Condition;
	writeln (#9'JMC'#9'0'#9'ENDIF',numIf);
	T:= siguientetoken;			
	if T.Tipo = TOKEN_THEN then
	begin
		{imprimirtab;}
		{writeln('+---TOKEN THEN: ',T.Nombre);}
		scanneravanzar;
	 	R:=seccionstatement();
  	end;
		if R then
	begin
		statement_if:=true;
		TraductorStatementIf;
	end
	else
	begin
		statement_if:=false;
	end;
	tabs:=tabs-1;		
end;{end statement if}	

function statement_while:boolean;
var			
	R : boolean;
	T : TToken;
begin{begin statement while}
	tabs:=tabs+1;
	numWh:=numWh+1;
	{imprimirtab;}
	{writeln('+---SECCION STATEMENT WHILE');}
	scanneravanzar;
	T:= siguientetoken;
	TraductorStatementWhile;
	R:=Condition;
	writeln(#9'JMC'#9'0'#9'ENDWHILE',numWh);
	T:= siguientetoken;
	if (T.Tipo = TOKEN_DO) and (R) then
	begin
		{imprimirtab;}
		{writeln('+---TOKEN DO: ',T.Nombre);}
		scanneravanzar;
	 	R:=seccionstatement();			
  	end;
		T:= siguientetoken;
	if R then
	begin			
		statement_while:=true;
		writeln(#9'JMP'#9'0'#9'WHILE',numWh);
		writeln(#9'Etiqueta:'#9'ENDWHILE',numWh);
	end
	else
	begin
		statement_while:=false;
	end;
	tabs:=tabs-1;		
end;{end statement while}

function SeccionStatement:boolean;{+---statement}
var			
	R : boolean;
	T : TToken;
begin{begin statement}
	tabs:=tabs+1;
	{imprimirtab;}
	{writeln('+---SECCION STATEMENT');}
	{TraductorStatement;}
	T:= siguientetoken;
	R:=true;
	if T.Tipo = TOKEN_IDENTIFICADOR then
	begin
		
		{imprimirtab;}
		{writeln('+---TOKEN ID: ',T.Nombre);}
		aux2:=T;
	 	R:= statement_ident;		
	end;
	T:= siguientetoken;
	if T.Tipo = TOKEN_CALL then
	begin
		
		{imprimirtab;}
		{writeln('+---SECCION STATEMENT');}
	 	R:= statement_call;		
	end;
	T:= siguientetoken;
	if T.Tipo = TOKEN_BEGIN then
	begin		 	
		R:= statement_begin;
	end;
	if T.Tipo = TOKEN_IF then
	begin
		
		{imprimirtab;}
		{writeln('+---SECCION STATEMENT IF: ',T.Nombre);}
		R:= statement_if;
	end;
	T:= siguientetoken;
	if T.Tipo = TOKEN_WHILE then
	 begin
	 	
		{imprimirtab;}
		{writeln('+---SECCION STATEMENT WHILE: ',T.Nombre);}
	 	R:= statement_while;		
	 end;
	T:=siguientetoken;
	if R then
	begin			
		seccionstatement:=true;	
	end
	else
	begin
		seccionstatement:=false;
	end;
	tabs:=tabs-1;		
end;{end statement}

function seccionprocedure:boolean;{+---procedure}
var
	R : boolean;
	T : TToken;
	id : string;
	u : boolean;
begin{begin procedure}
	nivel:=nivel+1;
	
	repeat
		R:=True;
		if T.Tipo= TOKEN_PROCEDURE then
		begin
			{$ifdef debug}
			tabs:=tabs+1;
			{{imprimirtab;}
			writeln('+---SECCION PROCEDURE');}
	       		scanneravanzar;
			{$endif}
		end;
		scanneravanzar;
		T:=siguientetoken;
		if T.Tipo= TOKEN_IDENTIFICADOR then
		begin
			id:=T.Nombre;
			{$ifdef debug}
			{imprimirtab;}
			{writeln('+---TOKEN ID:',T.Nombre);}
			u:=TraductorProcedure(id);
	       		scanneravanzar;
			{$endif}
		end;
		T:=siguientetoken;
		if T.Tipo= TOKEN_PUNTO_COMA then
		begin
			{$ifdef debug}
			{imprimirtab;}
			{writeln('+---TOKEN PUNTO Y COMA:',T.Nombre); }
			{$endif}
		end;
		if R then
		begin
			R:=block;
			scanneravanzar;
		end;
		
		T:=siguientetoken;
		
	until T.Tipo <> TOKEN_PROCEDURE;
	T:=siguientetoken;

	if (R) then
	begin
		{$ifdef debug}
        	seccionprocedure:=TRUE;
		{$endif}
	end 	
	else
	begin
		seccionprocedure:=false;	
	end;
	tabs:=tabs-1;
	nivel:=nivel-1;
	writeln(nivel);
end;{end procedure}

function block:boolean;{+---block}
function seccionconst:boolean;{+---const}
var	
	id: string;
	numero : integer;
	R : boolean;
	T : TToken;
	u : boolean;	
begin{begin de const}
	tabs:=tabs+1;
	{imprimirtab;}
	{writeln('+---SECCION CONS');}
		
	repeat
		scanneravanzar;
		T := siguientetoken;
       		if T.Tipo = TOKEN_IDENTIFICADOR then
		begin
			id:=T.Nombre;
			{$ifdef debug}
			{imprimirtab;}
			{writeln('+---TOKEN ID:',T.Nombre);}
			scanneravanzar;
			{$endif}
		end;
 		T := siguientetoken;
 		if T.Tipo = TOKEN_IGUAL then
		begin
			{$ifdef debug}
			{imprimirtab;}
			{writeln('+---TOKEN IGUAL ',T.Nombre);}
			scanneravanzar;
			{$endif}
		end;
		T:= siguientetoken;
		if T.Tipo = TOKEN_ENTERO then
		begin
			numero:=T.ValorI;
			{$ifdef debug}
			{imprimirtab;}
			{writeln('+---TOKEN ENTERO:',T.ValorI);}
			scanneravanzar;
			{$endif}
		end;
		u:=TraductorConst(id,numero);
		T:= siguientetoken;
      	until T.Tipo <> TOKEN_COMA;
	if T.Tipo = TOKEN_PUNTO_COMA then
	begin
		seccionconst := true;				
		{imprimirtab;}
		{writeln('+---TOKEN PUNTO Y COMA:',T.Nombre);}
		scanneravanzar;
	end
	else
	begin
		seccionconst:=false;
	end;
	tabs:=tabs-1;
end;{end const}

function seccionvar:boolean;{+---var}
var
	u : boolean;
	R : boolean;
	T : TToken;
	id : string;
	count : integer = 0;			
begin{begin de var}
	tabs:=tabs+1;
	{imprimirtab;}
	{writeln('+---SECCION VAR');}
		
	repeat
		scanneravanzar;
		T :=siguientetoken;
		if T.Tipo = TOKEN_IDENTIFICADOR then
		begin
			id:=T.Nombre;
			{$ifdef debug}
			{imprimirtab;}
			{writeln('+---TOKEN ID:',T.Nombre);}
			scanneravanzar;
			{$endif}
		end;
		u:= TraductorVar(id);
		count:=count+1;
       		T:= siguientetoken;
	until T.Tipo <> TOKEN_COMA;
	if T.Tipo = TOKEN_PUNTO_COMA then
	begin
		seccionvar:=true;			
		{imprimirtab;}
		{writeln('+---TOKEN PUNTO COMA:',T.Nombre);}
		scanneravanzar;
	end	
	else
	begin
		seccionvar:= false;			
	end;
	tabs:=tabs-1;
	ImprimirTraductorVar(count);
end;{end de var}
		
var
	u : boolean;
	R : boolean;
	T : TToken;
	auxB : integer=0;
		
begin{begin de block}
	tabs:=tabs+1;
	{imprimirtab;}	
	{writeln('+---BLOCK');}
	{u:=TraductorBlock(auxB);
	auxB:=auxB+1;}
	R:=true;
	scanneravanzar;
	T:=siguientetoken;
	if T.Tipo = TOKEN_CONST then
	begin
		R:=seccionconst;
		
	end;
	T:=siguientetoken;
	if (T.Tipo = TOKEN_VAR) and (R) then
	begin
		R:=seccionvar;
	end;
	T:=siguientetoken;
	if (T.Tipo = TOKEN_PROCEDURE) and (R) then
	begin
		aux1:=1;
		R:=seccionprocedure;
	end;
	T:=siguientetoken;
	if R then
	begin
		if aux1=0 then
		begin
			{TraductorStatement;}
		end;
		R:=seccionstatement;
		
	end
	else
	begin
		R:=False;
	end;
	if R then
	begin
		
		block:=true;
	end
	else
	begin
		block:=false;		
	end;
	
	tabs:=tabs-1;
	aux1:=0;
end;{en de block}

function parseprogram:boolean;{+program}
var
	u:boolean;
	R : boolean;
	T : TToken;				
begin{begin parseprogarm}
	tabs := 0;
	{imprimirtab;}
	{writeln ('+PROGRAM');}	
	R:=block;
	if (R) then
	begin
		parseprogram:=TRUE;
		u:=TraductorProgram;
		
	end
	else
	begin
		err(T);
		parseprogram:=false;		
	end;
end;{end parseprogarm}

begin
end.
