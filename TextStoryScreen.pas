unit TextStoryScreen;

interface

uses
    Classes,crt;

type
        TextStoryScreenType = object

    private
    
    public

    procedure Initial();
    procedure Final();
    procedure YouDied();
    procedure ShadowKilled();
    procedure BecomeShadow();
    procedure GoodEnding();    

    end;

var     TextStoryScreenImpl : TextStoryScreenType;

implementation

    procedure TextStoryScreenType.Initial(); {PANTALLA DE PRESENTACION}
        BegiN
                cursoroff; {apaga el cursor para que no titilee}
                writeln;
                writeln;
                writeln('                                PRESENTING...bbb');
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
                readkey;
                clrscr;
                writeln;
                writeln('                                ### ENEMIES ### ');
                writeln;
                writeln('         R = Rabbit  -  F = Fox  -  W = Wolf  -  B = Bear  -  S = Shadow ');
                writeln;
                writeln('                                ### ITEMS  ### ');
                writeln;
                writeln('                   | = Stick  -  / = Wooden Club  -  ! = Rusty Sword');
                writeln('                        a = Apple  -  m = Meat  -  ~ = Mist');
                writeln;
                writeln('                                ### TERRAIN  ### ');
                writeln;
                writeln('                            , = Grass  -  . = Dirt  ');
                writeln('                                & = Thorny Bush');
                writeln;
                writeln;
                writeln('                        GOOD LUCK! PRESS ENTER TO CONTINUE');

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
                writeln;
                writeln('                               THE HISTORY');
                writeln;
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

        EnD;

    procedure TextStoryScreenType.Final(); {PANTALLA FINAL}
        BegiN
                clrscr;
                writeln;
                writeln;
                writeln('                                  ENDING THE GAME...');
                writeln('                               PRESS ANY KEY TO EXIT');
                cursoron;
                readkey;
        EnD;

    procedure TextStoryScreenType.YouDied();
        BegiN
                clrscr;
                writeln;
                writeln;
                writeln('                                  YOU DIED');
                writeln;
                writeln('                            BETTER LUCK NEXT TIME!');
        EnD;

        procedure TextStoryScreenType.ShadowKilled(); 
        BegiN
                clrscr;
                writeln;
                writeln;
                writeln('                          YOU HAVE KILLED THE SHADOW!!');
                writeln('                         YOUR REVENGE IS NOW COMPLETE');
        EnD;

        procedure TextStoryScreenType.BecomeShadow();
        BegiN
                writeln('    BUT SOMETHING IS WRONG... YOUR BODY BEGINS TO FADE AWAY... BECOMING A SHADOW...')
        EnD;

                procedure TextStoryScreenType.GoodEnding();
        BegiN
                writeln('                        THE MIST CLEARS AND YOU CAN SEE THE FOREST CLEARLY');
                writeln('              IT SEEMS THAT THE SUN SHINES AGAIN... AND YOU RETURN TO YOUR CABIN ALIVE!');
                writeln('                 THE UNKNOWN HERO COMES BACK TO HIS LAND, AND GOES OFF IN A NEW ADVENTURE!');
        EnD;
end.