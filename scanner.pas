unit scanner;
interface
uses
	sysutils;

type
	TTipoToken =(T_ERROR,TOKEN_ENTERO,TOKEN_IDENTIFICADOR,TOKEN_IGUAL,TOKEN_COMA,TOKEN_PUNTO_COMA,TOKEN_ASIGNACION,TOKEN_MENOR,TOKEN_DIFERENTE,TOKEN_MENOR_IGUAL,TOKEN_MAS,TOKEN_MAYOR,TOKEN_MAYOR_IGUAL,TOKEN_MENOS,TOKEN_POR,TOKEN_ENTRE,TOKEN_PARENTESIS_ABRE,TOKEN_PARENTESIS_CIERRE,TOKEN_GATO,TOKEN_PUNTO,TOKEN_ADMIRACION,TOKEN_CONST,TOKEN_VAR,TOKEN_PROCEDURE,TOKEN_CALL,TOKEN_BEGIN,TOKEN_END,TOKEN_IF,TOKEN_THEN,TOKEN_WHILE,TOKEN_DO,TOKEN_ODD);

  TToken = record
    Tipo : TTipoToken;
    ValorI : integer;
    Nombre : string;

  end;
var
  F : file of char;
  ch: char;
  S : string;
  n : string;
  T : TToken;
  Avance : boolean;
  fila  :  integer;
  columna  :  integer;
	
function Estado0: TToken;
function Leer: char;
procedure Avanzar;
procedure inicializarscanner;

implementation

{================   L E E R   ================}
function Leer: char;
begin
if eof(F) then halt;
 if Avance then
  begin
    read(F,ch);
    Avance := false;
    columna:=columna+1;
  end;
  Leer := ch;
end;

{=============  A V A N Z A R   =============}
procedure Avanzar;
begin
  Avance := true;
end;

{================INICIALIZAR SCANNER================}
procedure inicializarscanner;

begin
	n := ParamStr(1);
	assign(F, n);
	reset(F);
	S := '';
	Avanzar;
	fila:=1;
	columna:=1;
end;


{=============   E R R O R    ===============}
function Error: TToken;
var
  T : TToken;
begin
  
{writeln(stderr,'Estado E');}
  Avanzar;
  T.Tipo := T_ERROR;
  T.Nombre := S;
  Error := T;
end;

{============= E S T A D O 22 =================}
function EstadoT22: TToken;
var
  T : TToken;
begin
  {writeln(stderr,'Estado T22');}
  Avanzar;
  T.Tipo := TOKEN_ADMIRACION;
  T.Nombre := S;
  EstadoT22 := T;
end;
{============= E S T A D O 21 =================}
function EstadoT21: TToken;
var
  T : TToken;
begin
  {writeln(stderr,'Estado T21');}
  Avanzar;
  T.Tipo := TOKEN_PUNTO;
  T.Nombre := S;
  EstadoT21 := T;
end;
{============= E S T A D O 20 =================}
function EstadoT20: TToken;
var
  T : TToken;
begin
  {writeln(stderr,'Estado T20');}
  Avanzar;
  T.Tipo := TOKEN_GATO;
  T.Nombre := S;
  EstadoT20 := T;
end;
{==============E S T A D O 19=========================}
function EstadoT19: TToken;
var
  c : char;
  T : TToken;
begin
  {writeln(stderr,'Estado T19 COMENTARIO');}
  Avanzar;
  c := Leer;

    while (c <> '}') do
       begin
	if (c=#10)then
	begin
		fila:=fila+1;
	end;
       S := S + c;
       Avanzar;
       c := Leer;
       end;
    if (c = '}') then
       begin
         S := S + c;
         Avanzar;
         c := Leer;
         T := EstadoT19;
         {EstadoT19 := T;}
       end
    else
       begin
         T := Error;
       end;
  EstadoT19 := T;
end;
{============= E S T A D O 18 =================}
function EstadoT18: TToken;
var
  T : TToken;
begin
 { writeln(stderr,'Estado T18');}
  Avanzar;
  T.Tipo := TOKEN_PARENTESIS_CIERRE;
  T.Nombre := S;
  EstadoT18 := T;
end;
{============= E S T A D O 17 =================}
function EstadoT17: TToken;
var
  T : TToken;
begin
  {writeln(stderr,'Estado T16');}
  Avanzar;
  T.Tipo := TOKEN_PARENTESIS_ABRE;
  T.Nombre := S;
  EstadoT17 := T;
end;
{============= E S T A D O 16 =================}
function EstadoT16: TToken;
var
  T : TToken;
begin
{  writeln(stderr,'Estado T16');}
  Avanzar;
  T.Tipo := TOKEN_ENTRE;
  T.Nombre := S;
  EstadoT16 := T;
end;
{============= E S T A D O 15 =================}
function EstadoT15: TToken;
var
  T : TToken;
begin
{  writeln(stderr,'Estado T15');}
  Avanzar;
  T.Tipo := TOKEN_POR;
  T.Nombre := S;
  EstadoT15 := T;
end;
{============= E S T A D O 14 =================}
function EstadoT14: TToken;
var
  T : TToken;
begin
{  writeln(stderr,'Estado T14');}
  Avanzar;
  T.Tipo := TOKEN_MENOS;
  T.Nombre := S;
  EstadoT14 := T;
end;
{============= E S T A D O 13 =================}
function EstadoT13: TToken;
var
  T : TToken;
begin
 {writeln(stderr,'Estado T13');}
  Avanzar;
  T.Tipo := TOKEN_MAS;
  T.Nombre := S;
  EstadoT13 := T;
end;
{============= E S T A D O 12 =================}
function EstadoT12: TToken;
var
  T : TToken;
begin
{  writeln(stderr,'Estado T12');}
  Avanzar;
  T.Tipo := TOKEN_MAYOR_IGUAL;
  T.Nombre := '>=';
  EstadoT12 := T;
end;
{============= E S T A D O 11 =================}
function EstadoT11: TToken;
var
  c : char;
  T : TToken;
begin
{  writeln(stderr,'Estado T11');}
  Avanzar;
  c := Leer;
  S := c;
  case c of
    '=':	T := EstadoT12;

  else
    T.Tipo := TOKEN_MAYOR;
    T.Nombre := '>';
  end;
  EstadoT11 := T;
end;
{============= E S T A D O 10 =================}
function EstadoT10: TToken;
var
  T : TToken;
begin
{  writeln(stderr,'Estado T10');}
  Avanzar;
  T.Tipo := TOKEN_MENOR_IGUAL;
  T.Nombre := '<=';
  EstadoT10 := T;
end;
{============= E S T A D O 9 =================}
function EstadoT9: TToken;
var
  T : TToken;
begin
{  writeln(stderr,'Estado T9');}
  Avanzar;
  T.Tipo := TOKEN_DIFERENTE;
  T.Nombre := '<>';
  EstadoT9 := T;
end;
{============= E S T A D O 8 =================}
function EstadoT8: TToken;
var
  c : char;
  T : TToken;
begin
 { writeln(stderr,'Estado T8');}
  Avanzar;
  c := Leer;
  S := c;
  case c of
    '>':	T := EstadoT9;
    '=':	T := EstadoT10;
  else
    T.Tipo := TOKEN_MENOR;
    T.Nombre := '<';
  end;
  EstadoT8 := T;
end;

{============= E S T A D O 7 =================}
function EstadoT7: TToken;
var
  T : TToken;
begin
  {writeln(stderr,'Estado T7');}
  Avanzar;
  T.Tipo := TOKEN_ASIGNACION;
  T.Nombre := ':=';
  EstadoT7 := T;
end;
{============= E S T A D O 6 =================}
function EstadoT6: TToken;
var
  c : char;
  T : TToken;
begin
  {writeln(stderr,'Estado T6');}
  Avanzar;
  c := Leer;
  if (c = '=') then
     begin
     S := c;
     T := EstadoT7;
     end
  else
     begin
     S := c;
     T := Error;
     end;
  EstadoT6 := T;
end;
{============= E S T A D O 5 =================}
function EstadoT5: TToken;
var
  T : TToken;
begin
  {writeln(stderr,'Estado T5');}
  Avanzar;
  T.Tipo := TOKEN_PUNTO_COMA;
  T.Nombre := S;
  EstadoT5 := T;
end;
{============= E S T A D O 4 =================}
function EstadoT4: TToken;
var
  T : TToken;
begin
  {writeln(stderr,'Estado T4');}
  Avanzar;
  T.Tipo := TOKEN_COMA;
  T.Nombre := S;
  EstadoT4 := T;
end;
{============= E S T A D O 3 =================}
function EstadoT3: TToken;
var
  T : TToken;
begin
  {writeln(stderr,'Estado T3');}
  Avanzar;
  T.Tipo := TOKEN_IGUAL;
  T.Nombre := S;
  EstadoT3 := T;
end;
{============= E S T A D O 2 =================}
function EstadoT2: TToken;
var
  c : char;
  T : TToken;
begin
  {writeln(stderr,'Estado T2');}
  Avanzar;
  c := Leer;
  while c in ['a'..'z','A'..'Z', '_', '0'..'9'] do
  begin
    S := S + c;
    Avanzar;
    c := Leer;
  end;
  S:= lowercase(S);
{========PALABRAS RESERVADAS=======}
   if s='const' then
   begin 
	T.Tipo := TOKEN_CONST;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='var'then
   begin 
	T.Tipo := TOKEN_VAR;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='procedure'then
   begin 
	T.Tipo := TOKEN_PROCEDURE;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='call'then
   begin 
	T.Tipo := TOKEN_CALL;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='begin'then
   begin 
	T.Tipo := TOKEN_BEGIN;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='end'then
   begin 
	T.Tipo := TOKEN_END;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='if'then
   begin 
	T.Tipo := TOKEN_IF;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='then'then
   begin 
	T.Tipo := TOKEN_THEN;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='while'then
   begin 
	T.Tipo := TOKEN_WHILE;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='do'then
   begin 
	T.Tipo := TOKEN_DO;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else if s='odd'then
   begin 
	T.Tipo := TOKEN_ODD;
  	T.Nombre := S;
  	EstadoT2 := T
   end
   else
        T.Tipo := TOKEN_IDENTIFICADOR;
  	T.Nombre := S;
  	EstadoT2 := T;
   
{================================}
{  T.Tipo := TOKEN_IDENTIFICADOR;
  T.Nombre := S;
  EstadoT2 := T;}
end;
{============= E S T A D O 1 =================}
function EstadoT1: TToken;
var
  c : char;
  T : TToken;
begin
  {writeln(stderr,'Estado T1');}
  Avanzar;
  c := Leer;
  while c in ['0'..'9'] do
  begin
    S := S + c;
    Avanzar;
    c := Leer;
  end;
  T.Tipo := TOKEN_ENTERO;
  T.ValorI := StrToInt(S);
  EstadoT1 := T;
end;

{==============E S T A D O 0 (CERO)=====================}
function Estado0: TToken;
var
  c : char;
  T : TToken;
begin
  {writeln(stderr,'Estado 0');}
	c := Leer;
	S := c;
	while (c = #13) or (c = #10) or (c = #32) or (c = #9) and not eof(F) do
	begin
	if c=#10 then
	begin
		fila:=fila+1;
		columna:=0;
	end;
	Avanzar;
	c := Leer;
	end;
	S := c;
    case c of
    '0'..'9':   T := EstadoT1;
    'A'..'Z':   T := EstadoT2;
    'a'..'z':   T := EstadoT2;
         '_':   T := EstadoT2;
	 '=':   T := EstadoT3;
	 ',':   T := EstadoT4;
	 ';':   T := EstadoT5;
	 ':':   T := EstadoT6;
	 '<':	T := EstadoT8;
	 '+':	T := EstadoT13;
	 '>':	T := EstadoT11;
	 '-':	T := EstadoT14;
	 '*':   T := EstadoT15;
	 '/':   T := EstadoT16;
	 '(':   T := EstadoT17;
	 ')':   T := EstadoT18;
         '{':   T := EstadoT19;
	 '#':   T := EstadoT20;
	 '.':   T := EstadoT21;
	 '!':   T := EstadoT22; 



    else
	T := Error;
    end;
    Estado0 := T;
end;
begin
end.


