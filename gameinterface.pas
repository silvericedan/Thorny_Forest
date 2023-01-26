unit GameInterface;

interface

uses
  Classes, crt, SysUtils, GameEntitiesStats, TextStoryScreen;

const
  fila = 25;
  col = 100;
  desfaseX = 10;
  desfaseY = 0;

{      DEFINICION DE OBJETO INFERFAZ      }
type
  matrizstr = array[1..fila, 1..col] of string;
  matrizint = array[1..fila, 1..col] of integer;


  GameInterfaceType = object

  private

    mdraw: matrizstr;

    mbase, mpos, mpos0: matrizint;

    xcam, ycam: integer;

  public

    procedure Load_mbase();
    function give_mbase(o, l: integer): integer;
    function give_mpos(o, l: integer): integer;
    procedure set_mpos(o, l: integer);

    procedure Screen_draw(); {segun el simbolo dibuja la pantalla}
    procedure Update_mdraw();
    procedure HUD_draw();
    procedure camera();

    procedure Copy_Map();
    procedure Game_conditions();

  end;

var
  gameInterfaceImpl: GameInterfaceType;

  x, y, bufsimbol, movio, hudTurn, hudItems, round: integer;
  characterhp, characteratk, charactermaxhp : integer;
  characterstatus, dire: string;
  salida, bufmpos, characterX, characterY: integer;
  i0, j0: integer; {contadores de ciclo i0 item/ j0 critter}
  shadow_killed, shadow_dagger: boolean;


implementation

procedure GameInterfaceType.Load_mbase(); {CARGA LA MATRIZ BASE LAS PAREDES, el suelo y el cesped}
var
  rbase: integer;
begin
  for y := 5 to fila - 4 do
  begin
    for x := 5 to col - 4 do
    begin
      rbase := random(100) + 1;
      case rbase of
        1..30: mbase[y, x] := 1; // 1 es grava
        31..80: mbase[y, x] := 2; // 2 es cesped
        81..100: mbase[y, x] := 3; // 3 es arbusto espinoso
      end;
    end;
  end;

end;

function GameInterfaceType.give_mbase(o, l: integer): integer;
begin
  give_mbase := mbase[o, l];
end;

function GameInterfaceType.give_mpos(o, l: integer): integer;
begin
  give_mpos := mpos[o, l];
end;

procedure GameInterfaceType.set_mpos(o, l: integer);
begin
  mpos[o, l] := bufmpos;
end;

procedure GameInterfaceType.Camera();
var
  iniY, finY, iniX, finX: integer;
begin
  iniY := characterY - 4;
  finY := characterY + 4;
  iniX := characterX - 4;
  finX := characterX + 4;

  for y := iniY to finY do
    for x := iniX to finX do
      if y <= characterY then
      begin
        if (x + y - iniX - iniY + 1 >= 3) and (x - y - iniX + iniY <= 6) then
        begin
          xcam := x - characterX + 5;
          ycam := y - characterY + 5;
          gotoxy(xcam + desfaseX, ycam + desfaseY);
          Screen_draw();
        end;
      end
      else
      if (y - x - iniY + iniX <= 6) and (y + x - iniX - iniY <= 14) then
      begin
        xcam := x - characterX + 5;
        ycam := y - characterY + 5;
        gotoxy(xcam + desfaseX, ycam + desfaseY);
        Screen_draw();
      end;


  HUD_draw();

end;

procedure GameInterfaceType.Screen_Draw();
begin
  case mdraw[y, x] of
    '.':
    begin
      Textcolor(Brown);
      Write(mdraw[y, x]);
      Textcolor(White);
    end;
    ',':
    begin
      Textcolor(Green);
      Write(mdraw[y, x]);
      Textcolor(White);
    end;
    '&':
    begin
      Textcolor(Green);
      Write(mdraw[y, x]);
      Textcolor(White);
    end;
    'W':
    begin
      Textcolor(Brown);
      Write(mdraw[y, x]);
      Textcolor(White);
    end;
    'B':
    begin
      Textcolor(Brown);
      Write(mdraw[y, x]);
      Textcolor(White);
    end;
    'S':
    begin
      Textcolor(8);
      Write(mdraw[y, x]);
      Textcolor(White);
    end;
    '~':
    begin
      Textcolor(8);
      Write(mdraw[y, x]);
      Textcolor(White);
    end;
    '#':
    begin
      Textcolor(8);
      Write(mdraw[y, x]);
      Textcolor(White);
    end

    else
      Write(mdraw[y, x]);
  end;

end;

procedure GameInterfaceType.Update_mdraw();
{ACTUALIZA LA MATRIZ MDRAW CON LOS VALORES DE LA MATRIZ MPOS}
begin
  for y := 1 to fila do
  begin
    for x := 1 to col do
    begin
      if mbase[y, x] = 0 then
        mdraw[y, x] := '#'
      else
      begin
        case mpos[y, x] of
          0..1: case mbase[y, x] of
              1: mdraw[y, x] := '.';

              2: mdraw[y, x] := ',';

              3: mdraw[y, x] := '&';
            end;

          2: mdraw[y, x] := '@';
          3..79:
          begin
            bufsimbol := mpos[y, x] - 2;
            {guardo el valor para buscarlo en la planilla de critters}
            mdraw[y, x] := nombres[2, bufsimbol];
          end;
          80..99:
          begin
            bufsimbol := mpos[y, x] - 79;
            mdraw[y, x] := nombresitems[2, bufsimbol];
          end;

        end;
      end;

    end;

  end;

end;


procedure GameInterfaceType.HUD_draw();
begin
  gotoxy(25, 9);
  case movio of
    1: Write('There is a thick fog to the ', dire, '                  ');
    2: Write('You move ', dire, '                                   ');
    3: Write('There is an enemy to the ', dire, '                     ');
  end;

  gotoxy(25, 2);
  Write('Turn:', hudTurn);
  gotoxy(25, 3);
  Write('Items:', hudItems);
  gotoxy(25, 4);
  Write('Hit Points:', characterhp, '/', charactermaxhp, '   ');
  gotoxy(25, 5);
  Write('Attack:', characteratk, '        ');
  gotoxy(25, 7);
  Write(characterstatus, '                                   ');

end;

procedure GameInterfaceType.Copy_Map();
{COPIA LOS DATOS DE MPOS EN LA MATRIZ MPOS0 PARA LUEGO PODER COMPARARLOS}
begin
  for y := 1 to fila do
  begin
    for x := 1 to col do
      mpos0[y, x] := mpos[y, x];
  end;

end;

procedure GameInterfaceType.Game_Conditions();
{SETEA LOS TURNOS DE COMBATE DE LOS DIFERENTES ENEMIGOS}
begin

  if characterhp <= 0 then
  begin
    TextStoryScreenImpl.YouDied();
    readkey;
    salida := 1;
    exit;
  end;

  if Shadow_killed = True then
  begin
      TextStoryScreenImpl.ShadowKilled();
    if shadow_dagger = True then
    begin
      TextStoryScreenImpl.BecomeShadow();
    end
    else
    begin
      TextStoryScreenImpl.GoodEnding();
    end;
    readkey;
    salida := 1;
    exit;
  end;
end;

end.
