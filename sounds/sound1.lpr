program sound1;

uses crt;

begin
 // DO RE MI FA SOL LA SI DO
sound(329);//mi
delay(1000);
sound(440);//la
delay(1000);
sound(587);    //re
delay(1000);
sound(783);        //sol
delay(1000);
sound(987);        //si
delay(1000);
sound(1318);        //mi
delay(1000);

sound(523);
sound(329);
sound(783);
delay(1000);//acorde de do mayor , no funciona multiples sonidos

nosound;
readln;
end.

