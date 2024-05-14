unit traductor;
interface
var
	aux1 : integer;
	nivel : integer = 0;
	numIf:integer=0;
	numwh:integer=0;

function TraductorProgram:boolean;
function TraductorBlock(aux:integer):boolean;
function TraductorConst(id:string;numero:integer):boolean;
function TraductorVar(id:string):boolean;
function TraductorProcedure(id:string):boolean;
function TraductorStatement:boolean;
function TraductorStatementWhile:boolean;
function TraductorStatementIf:boolean;
function TraductorStatementBegin:boolean;
function TraductorStatementCall(id:string):boolean;
function TraductorStatementIdent(id:string):boolean;
function TraductorCondition:boolean;
function TraductorRecursiva:boolean;
function TraductorExpresion(opr:string):boolean;
function TraductorTerm(opr:string):boolean;
function TraductorFactorID(id:string):boolean;
function TraductorFactorIN(numero:integer):boolean;
procedure ImprimirTraductorVar(count:integer);
{function EnColeccion:boolean;
function EnVariable:boolean;
function Traductor:boolean;
function Traductor:boolean;
function Traductor:boolean;}

implementation
type
	constante = record
	letra : string;
	numero : integer;
	end;
var
	
	numvar : integer = 0;
	numcons : integer = 0;
	diccionario : array[0..255] of constante;
	variables : array [0..255] of string; 

function EnColeccion(id:string):boolean;
	var
		i : integer;
		si : boolean;
begin
	for i:=0 to 255 do
	begin
		if diccionario[i].letra = id then
		begin
			si:=True;
			break;			
		end;
	end;
	if si then
	begin
		EnColeccion:=True;
	end
	else
	begin
		EnColeccion:=False;
	end;
end;

procedure PonerEnDiccionario(id:string;numero:integer;pos:integer);
begin
	diccionario[pos].letra:=id;
	diccionario[pos].numero:=numero;
end;

procedure imprimirDic;
var
	i:integer;
begin
	for i:=0 to 255 do
	begin
		writeln(diccionario[i].letra, diccionario[i].numero);
	end;
end;

function EnVar(id:string):boolean;
	var
		i : integer;
		si : boolean;
begin
	for i:=0 to 255 do
	begin
		if variables[i] = id then
		begin
			si:=True;
			break;			
		end;
	end;
	if si then
	begin
		EnVar:=True;
	end
	else
	begin
		EnVar:=False;
	end;
end;

procedure PonerEnVar(id:string;pos:integer);
begin
	variables[pos]:=id;
	
end;

procedure imprimirVar;
var
	i:integer;
begin
	for i:=0 to 255 do
	begin
		writeln(variables[i]);
	end;
end;

procedure ImprimirTraductorVar(count:integer);
begin
	writeln(#9'INS'#9'0'#9,count +3);
end;

function TraductorProgram:boolean;
begin
	{writeln('Traduccion completa');}
	TraductorProgram:=true;
end;

function TraductorBlock(aux:integer):boolean;
begin
	{writeln('Traduccion block completa');}
	if aux=0 then
	begin
		writeln('Main:');
	end;
	TraductorBlock:=true;
end;

function TraductorConst(id:string;numero:integer):boolean;
var
	R : boolean;
	
begin
	
	R:=Encoleccion(id);
	if R then
	begin
		writeln('Traduccion cons error');
		TraductorConst:=false;
	end
	else
	begin
		PonerEnDiccionario(id,numero,numcons);
		{writeln('Traduccion cons completa');}
		{imprimirDic;}
		TraductorConst:=true;
		numcons:=numcons+1;
		
	end;
	
end;

function TraductorVar(id:string):boolean;
var
	R : boolean;
	
begin
	R:=EnVar(id);
	if R then
	begin
		writeln('Traduccion var error');
		TraductorVar:=false;
	end
	else
	begin
		PonerEnVar(id,numvar);
		numvar:=numvar+1;
		{writeln('Traduccion vars completa');}
		{imprimirVar;}
		TraductorVar:=true;
		
	end;
end;

function TraductorProcedure(id:string):boolean;
var
	R:boolean;
begin
	R:=EnVar(id);
	if R then
	begin
		writeln('Traduccion Procedure error');
		TraductorProcedure:=false;
	end
	else
	begin
		PonerEnVar(id,numvar);
		numvar:=numvar+1;
		{writeln('Traduccion procedure completa');}
		{imprimirVar;}
		writeln (#9'etiqueta'#9, id,':');
		TraductorProcedure:=true;
		
	end;
	
end;
function TraductorStatement:boolean;
begin
	
	writeln(#9'Main:');
	
	TraductorStatement:=true;
end;
function TraductorStatementWhile:boolean;
begin
	writeln(#9'Etiqueta:'#9'WHILE',numWh);
	TraductorStatementWhile:=true;
end;
function TraductorStatementIf:boolean;
begin
	writeln(#9'Etiqueta:'#9'ENDIF',numIf);
	TraductorStatementIf:=true;
end;
function TraductorStatementBegin:boolean;
begin
	writeln('Traduccion completa');
	TraductorStatementBegin:=true;
end;
function TraductorStatementCall(id:string):boolean;
var
	R:boolean;
	U:boolean;
begin
	U:=EnVar(id);
	R:= EnColeccion(id);
	
	if (R) or (U)then
	begin
		writeln (#9'JMP'#9'0'#9'etiqueta:',id);
		TraductorStatementCall:=True;	
	end
	else
	begin
		TraductorStatementCall:=false;
	end;
	{writeln('Traduccion statement id completa');}
	
end;
function TraductorStatementIdent(id:string):boolean;
var
	R:boolean;
	U:boolean;
begin
	U:=EnVar(id);
	R:= EnColeccion(id);
	
	if (R) or (U)then
	begin
		writeln (#9'STO'#9,nivel,#9,id);
		TraductorStatementIdent:=True;	
	end
	else
	begin
		TraductorStatementIdent:=false;
	end;
	{writeln('Traduccion statement id completa');}
	
end;
function TraductorCondition:boolean;
begin
	writeln('Traduccion completa');
	TraductorCondition:=true;
end;
function TraductorRecursiva:boolean;
begin
	writeln('Traduccion completa');
	TraductorRecursiva:=true;
end;
function TraductorExpresion(opr:string):boolean;
begin
	writeln(#9'OPR'#9,'0'#9,opr);
	{writeln('Traduccion completa');}
	TraductorExpresion:=true;
end;
function TraductorTerm(opr:string):boolean;
begin
	writeln(#9'OPR'#9,'0'#9,opr);
	{writeln('Traduccion completa');}
	TraductorTerm:=true;
end;
function TraductorFactorID(id:string):boolean;
var
	U:boolean;
	R:boolean;
begin
	U:=EnVar(id);
	R:= EnColeccion(id);
	
	if (R) or (U)then
	begin
		writeln (#9'LOD'#9'0'#9,id);
		TraductorFactorID:=True;	
	end
	else
	begin
		TraductorFactorID:=false;
	end;
	{writeln('Traduccion statement id completa');}
end;
function TraductorFactorIN(numero:integer):boolean;
begin
	writeln(#9'LIT'#9'0'#9,numero);
	{writeln('Traduccion statement in completa');}
	TraductorFactorIN:=true;
end;
{function EnColeccion:boolean;
function EnVariable:boolean;
function Traductor:boolean;
function Traductor:boolean;
function Traductor:boolean;}

begin
end.
