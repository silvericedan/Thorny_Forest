unit planillas;


interface

uses
  Classes, SysUtils;

const      nombres : array [1..2,1..5] of string = (('Rabbit','Fox','Wolf','Bear','Shadow'),('R','F','W','B','S'));
           estadisticas : array [1..4,1..5] of integer = ((0,0,1,1,1),(3,5,10,30,30),(1,2,4,6,8),(3,4,5,6,7));
                                                         // aggro,         hp,           atk,       simbol

           nombresitems : array[1..2,1..6] of string = (('Apple','Stick','Big Stick','Rusty Dagger','Mist','Meat'),('a','|','/','!','~','m'));
           estaditems: array[1..4,1..6] of integer =  ((8,0,0,0,2,10),(0,0,0,0,5,2),(0,2,4,10,0,0),(80,81,82,83,84,85));
                                                      // hp,            hpmax,        atk               position number

implementation

end.

