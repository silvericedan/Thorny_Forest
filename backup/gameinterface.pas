unit GameInterface;

interface

uses
  Classes,crt, SysUtils,planillas;

const   fila = 25;
        col  = 100;
        desfaseX= 10;
        desfaseY = 0;

        {      DEFINICION DE OBJETO INFERFAZ      }
type   matrizstr=array[1..fila,1..col] of string;
       matrizint= array[1..fila,1..col] of integer;


        Interfaz = object

        private

        mdraw:matrizstr;

        mbase,mpos,mpos0:matrizint;

        xcam,ycam : integer;

        public

        procedure Load_mbase();
        function give_mbase(o,l:integer):integer;
        function give_mpos(o,l:integer):integer;
        procedure set_mpos(o,l:integer);

        procedure Screen_draw(); {segun el simbolo dibuja la pantalla}
        procedure Update_mdraw();
        procedure HUD_draw();
        procedure camera();

        procedure First_consoleDraw();
        procedure Update_consoleDraw();
        procedure Copy_Map();
        procedure Game_conditions();

        end;

var     Interf : Interfaz;

        x,y, bufsimbol, movio, turno, contfruta,round: integer;
        characterhp, characteratk, charactermaxhp, currentipo,currenthp,ENstatus: integer;
        characterstatus,dire : string;
        salida,bufmpos,characterX,characterY,xfru,yfru : integer;
        i0,j0: integer; {contadores de ciclo i0 item/ j0 critter}
        shadow_killed,shadow_dagger: boolean;


implementation

procedure Interfaz.Load_mbase(); {CARGA LA MATRIZ BASE LAS PAREDES, el suelo y el cesped}
          var rbase:integer;
        BegiN
                for y:=5 to fila-4 do
                        begin
                        for x:=5 to col-4 do
                                begin
                                     //mbase[y,x]:=random(3)+1;
                                        rbase:=random(100)+1;
                                        case rbase of
                                        1..30  : mbase[y,x]:=1;
                                        31..80 : mbase[y,x]:=2;
                                        81..100: mbase[y,x]:=3;
                                        end;  //1 liso, 2 cesped, 3 arbusto }
                                end;
                        end;

        End;

function Interfaz.give_mbase(o,l: integer):integer;
          BegiN
                 give_mbase:=mbase[o,l];
          EnD;

function Interfaz.give_mpos(o,l: integer):integer;
          BegiN
                 give_mpos:=mpos[o,l];
          EnD;
procedure Interfaz.set_mpos(o,l: integer);
          BegiN
                 mpos[o,l]:=bufmpos;
          EnD;
procedure Interfaz.Camera();
          var iniY,finY,iniX,finX: integer;
          BegiN
                 iniY:=characterY-4;
                 finY:=characterY+4;
                 iniX:=characterX-4;
                 finX:=characterX+4;

               for y:=iniY to finY do
                       for x:=iniX to finX do
                           if y<= characterY then
                               begin
                               if (x+y-iniX-iniY+1>=3) and (x-y-iniX+iniY<=6) then
                               begin
                                xcam:=x-characterX+5;
                                ycam:=y-characterY+5;
                                gotoxy(xcam+desfaseX,ycam+desfaseY);
                                Screen_draw();
                               end;
                               end
                           else
                                if (y-x-iniY+iniX<=6) and (y+x-iniX-iniY<=14) then
                                begin
                                xcam:=x-characterX+5;
                                ycam:=y-characterY+5;
                                gotoxy(xcam+desfaseX,ycam+desfaseY);
                                Screen_draw();
                                end;


               HUD_draw();

          end;
procedure Interfaz.Screen_Draw();
          BegiN
                 case mdraw[y,x] of
                      '.' : begin
                      Textcolor(Brown);
                      write(mdraw[y,x]);
                      Textcolor(White);
                      end;
                      ',' : begin
                      Textcolor(Green);
                      write(mdraw[y,x]);
                      Textcolor(White);
                      end;
                      '&' : begin
                      Textcolor(Green);
                      write(mdraw[y,x]);
                      Textcolor(White);
                      end;
                      'W' : begin
                      Textcolor(Brown);
                      write(mdraw[y,x]);
                      Textcolor(White);
                      end;
                      'B' : begin
                      Textcolor(Brown);
                      write(mdraw[y,x]);
                      Textcolor(White);
                      end;
                      'S' : begin
                      Textcolor(8);
                      write(mdraw[y,x]);
                      Textcolor(White);
                      end;
                      '~' : begin
                      Textcolor(8);
                      write(mdraw[y,x]);
                      Textcolor(White);
                      end;
                      '#' : begin
                      Textcolor(8);
                      write(mdraw[y,x]);
                      Textcolor(White);
                      end

                 else  write(mdraw[y,x]);
                 end;


          EnD;

procedure Interfaz.Update_mdraw(); {ACTUALIZA LA MATRIZ MDRAW CON LOS VALORES DE LA MATRIZ MPOS}
        BegiN
                for y:=1 to fila do
                        begin
                        for x:=1 to col do
                            begin
                            if mbase[y,x]=0 then mdraw[y,x]:='#' else
                            begin
                                case mpos[y,x] of
                                0..1 : case mbase[y,x] of
                                       1: mdraw[y,x]:='.';

                                       2: mdraw[y,x]:=',';

                                       3: mdraw[y,x]:='&';
                                       end;

                                2 : mdraw[y,x]:='@';
                                3..79: begin
                                       bufsimbol:= mpos[y,x] - 2;{guardo el valor para buscarlo en la planilla de critters}
                                       mdraw[y,x]:=nombres[2,bufsimbol];
                                       end;
                                80..99 : begin
                                         bufsimbol:= mpos[y,x]-79;
                                         mdraw[y,x]:=nombresitems[2,bufsimbol];
                                         end;

                                end;
                            end;

                        end;

                        end;

        EnD;

procedure Interfaz.First_consoleDraw(); {ESCRIBE EN LA CONSOLA EL CONTENIDO DE LA MATRIZ MDRAW}
        BegiN
                for y:=1 to fila do
                        begin
                        for x:=1 to col do
                                begin
                                        gotoxy(x+desfaseX,y+desfaseY);
                                        Screen_draw();
                                end;
                        writeln;
                        end;


        EnD;
procedure Interfaz.HUD_draw();
          BegiN
               gotoxy(25,9);
                case movio of
                1 : write('There is a thick fog to the ',dire,'                  ');
                2 : write('You move ',dire,'                                   ');
                3 : write('There is an enemy to the ',dire,'                     ');
                end;

                gotoxy(25,2);
                write('Turn:',turno);
                gotoxy(25,3);
                write('Items:',contfruta);
                gotoxy(25,4);
                write('Hit Points:',characterhp,'/',charactermaxhp,'   ');
                gotoxy(25,5);
                write('Attack:',characteratk,'        ');
                gotoxy(25,7);
                write(characterstatus,'             ');

          EnD;

procedure Interfaz.Update_consoleDraw(); {SI ALGUN GRAFICO CAMBIO EN EL TURNO ANTERIOR, LO MODIFICA, SINO NO HACE NADA}
        BegiN
                for y:=1 to fila do
                        begin
                        for x:=1 to col do
                                if mpos[y,x]<>mpos0[y,x] then
                                        begin
                                             gotoxy(x+desfaseX,y+desfaseY);
                                             Screen_draw();
                                        end;
                        end;

                HUD_draw();
        EnD;

procedure Interfaz.Copy_Map(); {COPIA LOS DATOS DE MPOS EN LA MATRIZ MPOS0 PARA LUEGO PODER COMPARARLOS}
        BegiN
                for y:=1 to fila do
                        begin
                        for x:=1 to col do
                                mpos0[y,x]:=mpos[y,x];
                        end;

        EnD;
procedure Interfaz.Game_Conditions(); {SETEA LOS TURNOS DE COMBATE DE LOS DIFERENTES ENEMIGOS}
        BegiN

                if characterhp<=0 then
                        begin
                        clrscr;
                        writeln;
                        writeln;
                        writeln('                                  YOU DIED');
                        writeln;
                        writeln('                      ');
                        readkey;
                        salida:=1;
                        exit;
                        end;

                if Shadow_killed= true then
                        begin
                        clrscr;
                        writeln;
                        writeln;
                        writeln('                          YOU HAVE KILLED THE SHADE!!');
                        writeln('                         YOUR REVENGE IS NOW COMPLETE');
                        if shadow_dagger=true then
                        writeln('    BUT SOMETHING IS WRONG... YOUR BODY BEGINS TO FADE AWAY... BECOMING A SHADOW...')
                        else
                        writeln('              IT SEEMS THAT THE SUN SHINES AGAIN... AND YOU RETURN TO YOUR CABIN ALIVE!');
                        readkey;
                        salida:=1;
                        exit;
                        end;
        EnD;
end.

