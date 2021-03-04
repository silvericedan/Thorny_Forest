program ThornyForest;

uses crt, actors,gameinterface;

{TODO: - SISTEMA DE ITEMS QUE UPGRADEAN  echo!
       - MAPA MAS GRANDE GENERADO RANDOM  echo!
       - TERRENO LISO . ARBUSTOS & Y ARBOLES %% arbustos no, complicaria el movimiento
       ya que cuando el personaje se mueve vuelve a escribir el casillero en 1. Una idea para resolverlo es...
       Para este caso, deberiamos usar una matriz que guarde el piso y las paredes, y otra matriz aparte que guarde el lugar de
       los personajes. En ese caso, para moverse el personaje primero chequearia la matriz de suelo, para ver si el espacio que quiere
       avanzar se encuentra algun muro o arbusto, luego si el espacio es caminable, deberia chequear si hay alguna criatura parada sobre ese suelo. echo!}




procedure Initial(); {INICIA RANDOMIZE Y DA LA PANTALLA DE PRESENTACION}
        BegiN
                cursoroff; {apaga el cursor para que no titilee}
                randomize();

                writeln;
                writeln;
                writeln('                                PRESENTING...');
                writeln;
                writeln('                        _  ');
                writeln('                 ______| |_______________________________  ');
                writeln('                |______| |_THORNY_FOREST_________________\ ');
                writeln('                       |_|       ');
                writeln;
                writeln('   THIS GAME IS A ROGUE-LIKE, A GAME BASED IN THE ORIGINAL "ROGUE" MADE IN 1980');
                writeln;
                writeln('   PLAY USING YOUR KEYBOARD, WASD TO MOVE, BUMP INTO ENEMIES TO FIGHT THEM');
                writeln('   THERE ARE SOME APPLES IN THE GROUND THAT WILL HEAL YOU, USE THEM WISELY!');
                writeln('                  THE THORNY BUSHES CAN HURT YOU... OR SAVE YOU' );
                writeln('                    FIND THE RUSTY SWORD TO KILL THE SHADOW');
                writeln('                     OR MAYBE THERES ANOTHER WAY TO BEAT IT..');
                writeln;
                writeln('                               ### ENEMIES ### ');
                writeln;
                writeln('         R = Rabbit  -  F = Fox  -  W = Wolf  -  B = Bear  -  S = Shadow ');
                writeln;
                writeln('                                ### ITEMS  ### ');
                writeln;
                writeln('                   | = Stick  -  / = Big Stick  -  ! = Rusty Sword');
                writeln('                        a = Apple  -  m = Meat  -  ~ = Mist');
                writeln;
                writeln('                      GOOD LUCK! PRESS ENTER TO CONTINUE');

                readkey;
                clrscr;


                writeln;
                writeln('################################################################################');
                writeln('####################################,(@*########################################');
                writeln('###################################*,%&/*#######################%&##############');
                writeln('###################################(,(#,#####################(&#################');
                writeln('#################################&@&%(###((#################%###################');
                writeln('################################/#&&%/#%@@/.,############%%#####################');
                writeln('#################################(*/&&,#(( ..,########/#########################');
                writeln('##################################*,#,****##,(/#####/(##########################');
                writeln('################################### . .(@@&##,((#*%#############################');
                writeln('###################################*#%//  (@&(/(.,*(############################');
                writeln('####################################@#(....*##/.################################');
                writeln('##################################(@##.*..,.(###################################');
                writeln('##################################%%@@##..//####################################');
                writeln('#################################(/##/### .#//##################################');
                writeln('##################################@%*#####(,/(##################################');
                writeln('###############################(**/*%####%./,/######%%%%%#####%%%%%%%%%%%%%%%###');
                writeln('####%##################%%%###%//(#%%%%%%%%(((#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                writeln('%%%################%%%%%%%#%#*(##(#%%%%%%%///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                writeln('%%%%%%%%%#%%#################(#@#%########/((##%%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                writeln('%%%%%%%%%#%%%%%#############,,*(##########,##%####%###%#%%%%%%%%%%%%%%%%%%%%%%%%');
                writeln('%%%%%%%%%%%%%%%%%%%%%%######/############(,(/(((%%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                writeln('%%%%%%%%%%%%%%%%%%%%%%%%###*,/#(####%%%############%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%##. ...%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                writeln('################################################################################');
                writeln;
                writeln('                            PRESS ENTER TO CONTINUE');
                readkey;
                clrscr;
                writeln('   You live alone in a cabin on the edge of the thorn forest. On a cold night you ');
                writeln('   enter the forest to look for some fallen firewood, but a thick fog covers the   ');
                writeln('   forest and prevents you from leaving. A shadow figure armed with rusty sword ');
                writeln('   passes by your side and leaves you with a bleeding wound ... ');
                writeln('   You run as fast as you can and you lose your attacker, now you must recover ');
                writeln('   your strength and try to get out of this cursed forest ...           ');
                writeln('   It looks like you are not going to come out alive from this place...');
                writeln;
                writeln('                      Unless you take care of that shadow');
                writeln;
                writeln('                          PRESS ENTER TO CONTINUE');
                readkey;
                clrscr;

        EnD;

BEGIN
        Initial();
        Interf.Load_mbase();
        perso.respawn();
        perso.update_mpos();
        fruta.respawn();
        monstruos.existence();

        Interf.Update_mdraw();
        Interf.Copy_map();
        ch := #40;

        //Interf.First_consoleDraw();       //para activar camara desactivar este y

        while (ch<>#27) and (salida<>1) do
         begin
                Interf.Update_mdraw();
                Interf.Camera();
                //Interf.Update_consoleDraw(); //desactivar este
                Interf.Copy_map();
                Perso.Detect_Keyboard();
                Perso.Player_Movement();
                perso.update_mpos();
                monstruos.behavior();
                if Drop_items= true then
                   begin
                     fruta.npc_created();
                     Drop_items:=false;
                   end;
                perso.update_mpos();
                Interf.Game_conditions();

        end;
        clrscr;
        writeln;
        writeln;
        writeln('                                  ENDING THE GAME...');
        writeln('                               PRESS ANY KEY TO EXIT');
        cursoron;
        readkey;
END.


