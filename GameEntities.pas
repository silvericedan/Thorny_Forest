unit GameEntities;

interface

uses
  Classes, SysUtils, crt, GameEntitiesStats, GameInterface;

const
  inipeX = 8;
  inipeY = 8;
  maxcritter = 20;
  maxitems = 41;

type

  matrizcritterstr = array[1..2, 1..maxcritter] of string;
  matrizcritterint = array[1..8, 1..maxcritter] of integer;

  matrizitemsstr = array[1..2, 1..maxitems] of string;
  matrizitemsint = array[1..6, 1..maxitems] of integer;



  {      DEFINICION DE OBJETOS    }

  Items = object

  private

    mitemsint: matrizitemsint;
    mitemsstr: matrizitemsstr;

  public

    procedure InitializeItems();
    procedure CheckWhichItemHasBeenFound();
    procedure PickUpAndUseItem();
    procedure StartingItemMPos();
    procedure CreatureSpawnMeat();

  end;

  { OBJETO PERSONAJE }

  MainCharacter = object

  private
    x, y, xb, yb, hp, maxhp, damage, atx, aty: integer;

    status: string;

  public

    procedure PassMposAndStatsToGameInterface();
    procedure InitializeStats();
    procedure DetectKeyboardInput();
    procedure PlayerMovement();
    procedure UseItem();
    procedure CheatingMode();

  end;

  { OBJETO CRITTER/NPC }

  Critter = object

  private

    mcritterint: matrizcritterint; {matrices conteniendo datos de critter activos/inactivos}
    mcritterstr: matrizcritterstr;

    xb, yb, choice: integer;

    status: string;{sin uso}

  public

    procedure existence(); {si existe hace algo, sino no}
    procedure update_mpos();{simbolo en xy, hp en hub y status hud}
    procedure GenerateCritterSetStatsAndPosition();     {aparece xy en mpos,setea stats}
    procedure despawn();      {borra xy en mpos}
    procedure movement(m: integer);
    procedure stance(ag: integer);  {si persigue o se mueve aleatorio}
    procedure CritterTakeDamage();
    procedure Behavior();        {si esta vivo-> toma daño, mueve, ataca}
    procedure DropItemOnDead();

  end;

var
  itemInterface: Items;
  mainChar: MainCharacter;
  npcCritter: Critter;

  i: integer;
  icheck: integer;{contadores de ciclo i0 item/ j0 critter/item check}

  itemBonusHealth, itemBonusAttack, itemBonusMaxHealth, xfru, yfru: integer;

  itemName: string;

  isMainCharacterAttacking, isItemOnCurrentTile: boolean;

  keyPressed, keyPressedLowerCase: char;


implementation

{ ### PROCEDURES DE ITEMS ### }
procedure Items.StartingItemMPos();
begin
  repeat
    mitemsint[5, i0] := random(fila - 8) + 5;   //item posicion Y
    mitemsint[6, i0] := random(col - 8) + 5;     // item posicion X
  until gameInterfaceImpl.give_mpos(mitemsint[5, i0], mitemsint[6, i0]) = 0;

  bufmpos := mitemsint[4, i0];
  gameInterfaceImpl.set_mpos(mitemsint[5, i0], mitemsint[6, i0]); //set_mpos(y,x)

end;

procedure Items.InitializeItems();
var
  ritem, aitem: integer;
begin
  for i0 := 1 to maxitems - 21 do
  begin
    aitem := random(100) + 1;
    case aitem of
      1..50: ritem := 1; //apples
      51..80: ritem := random(2) + 2; //2 stick y 3 wooden club
      81..100: ritem := 5; //5 mist
    end;
    if i0 = 1 then
      ritem := 4; //4 dagger

    mitemsstr[1, i0] := nombresitems[1, ritem]; //setea nombre
    mitemsstr[2, i0] := nombresitems[2, ritem]; //setea icono

    mitemsint[1, i0] := estaditems[1, ritem];  //bonus hp
    mitemsint[2, i0] := estaditems[2, ritem];  //bonus maxhp
    mitemsint[3, i0] := estaditems[3, ritem];  //bonus atk
    mitemsint[4, i0] := estaditems[4, ritem];  //simbolo numerico


    StartingItemMPos();
  end;
end;

procedure Items.PickUpAndUseItem();
begin
  itemBonusHealth := mitemsint[1, icheck];
  itemBonusMaxHealth := mitemsint[2, icheck];
  itemBonusAttack := mitemsint[3, icheck];
  itemName := mitemsstr[1, icheck];
  mainChar.status := ('You get a ' + itemName);
  if icheck = 1 then
    begin
    shadow_dagger := True;
    mainChar.status := mainChar.status + ', something is wrong...'
    end;
  mainChar.UseItem();

  itemName := '';
  itemBonusHealth := 0;
  itemBonusMaxHealth := 0;
  itemBonusAttack := 0;

  isItemOnCurrentTile := False;

end;

procedure Items.CreatureSpawnMeat();
var
  citem: integer;
begin
  i0 := i0 + 1;
  citem := 6; //meat
  mitemsstr[1, i0] := nombresitems[1, citem]; //setea nombre
  mitemsstr[2, i0] := nombresitems[2, citem]; //setea icono

  mitemsint[1, i0] := estaditems[1, citem];  //bonus hp
  mitemsint[2, i0] := estaditems[2, citem];  //bonus maxhp
  mitemsint[3, i0] := estaditems[3, citem];  //bonus atk
  mitemsint[4, i0] := estaditems[4, citem];  //simbolo numerico


  mitemsint[5, i0] := yfru;   //item posicion Y
  mitemsint[6, i0] := xfru;     // item posicion X

  bufmpos := mitemsint[4, i0];
  gameInterfaceImpl.set_mpos(yfru, xfru); //set_mpos(y,x)

end;

procedure Items.CheckWhichItemHasBeenFound();
begin
  if isItemOnCurrentTile = True then
    for icheck := 1 to maxitems do
      if (mainChar.aty = mitemsint[5, icheck]) and
        (mainChar.atx = mitemsint[6, icheck]) then
        PickUpAndUseItem();

end;

{ ### PROCEDURES DE PERSONAJE ### }
procedure MainCharacter.PassMposAndStatsToGameInterface();
begin
  bufmpos := 2;
  gameInterfaceImpl.set_mpos(mainChar.y, mainChar.x);
  characterhp := mainChar.hp;
  characterstatus := mainChar.status;
  characteratk := mainChar.damage;
  charactermaxhp := mainChar.maxhp;
  characterX := mainChar.x;
  characterY := mainChar.y;
end;

procedure MainCharacter.InitializeStats();
begin
  if (y <> 0) and (x <> 0) then
  begin
    bufmpos := 0;
    gameInterfaceImpl.set_mpos(y, x);
  end;

  mainChar.y := inipeY;
  mainChar.x := inipeX;

  mainChar.hp := 8;
  mainChar.maxhp := 16;
  mainChar.damage := 1;

  PassMposAndStatsToGameInterface();
end;

procedure MainCharacter.DetectKeyboardInput();
begin
  keyPressed := Readkey;
  keyPressedLowerCase := lowercase(keyPressed);
  case (keyPressedLowerCase) of
    'k':
    begin         {k es left arrow}
      yb := y;
      xb := x - 1;
      dire := 'East';
    end;

    'a':
    begin
      yb := y;
      xb := x - 1;
      dire := 'East';
    end;
    'm':
    begin         {m es right arrow}
      yb := y;
      xb := x + 1;
      dire := 'West';
    end;

    'd':
    begin
      yb := y;
      xb := x + 1;
      dire := 'West';
    end;

    'h':
    begin         {h es up arrow}
      yb := y - 1;
      xb := x;
      dire := 'North';
    end;

    'w':
    begin
      yb := y - 1;
      xb := x;
      dire := 'North';
    end;

    'p':
    begin         {p es up arrow}
      yb := y + 1;
      xb := x;
      dire := 'South';
    end;

    's':
    begin
      yb := y + 1;
      xb := x;
      dire := 'South';
    end;
    else
    begin
      yb := y;
      xb := x;
      dire := 'No move';
    end;

  end;

  hudTurn := hudTurn + 1;

end;


procedure MainCharacter.PlayerMovement();
begin
  if gameInterfaceImpl.give_mbase(yb, xb) <> 0 then
  begin
    case gameInterfaceImpl.give_mpos(yb, xb) of

      0..1:
      begin    {encontro un espacio vacio}
        if gameInterfaceImpl.give_mbase(yb, xb) = 3 then
          mainChar.hp := mainChar.hp - 1; //si pasa sobre arbustos espinosos "3" &, -1 vida.

        movio := 2;
        bufmpos := 0;
        gameInterfaceImpl.set_mpos(y, x);
        y := yb;
        x := xb;
        mainChar.status := ('Walking...');
      end;

      3..79:
      begin       {encontro un enemigo}
        movio := 3;
        isMainCharacterAttacking := True;
        aty := yb; {guardo las coordenadas donde ataqu‚}
        atx := xb;

        yb := y;   {devuelvo las coordenadas al lugar original}
        xb := x;

        mainChar.status := ('Attacking an enemy!');
      end;

      80..99:
      begin           {encontro un item}

        movio := 2;
        isItemOnCurrentTile := True;
        aty := yb; {guardo las coordenadas donde levante}
        atx := xb;
        itemInterface.CheckWhichItemHasBeenFound();
        aty := 0; //reseteo aty y atx
        atx := 0;
        bufmpos := 0;
        gameInterfaceImpl.set_mpos(y, x);
        y := yb;
        x := xb;
        gameInterfaceImpl.set_mpos(yb, xb);

      end;

    end;
  end
  else
  begin
    movio := 1;
    yb := y;
    xb := x;
    mainChar.status := ('You lose your turn!');
  end;

end;

procedure MainCharacter.UseItem();
begin
  hp := hp + itemBonusHealth;
  maxhp := maxhp + itemBonusMaxHealth;
  if itemBonusAttack > damage then
    damage := itemBonusAttack;
  if hp > maxhp then
    hp := maxhp;
  hudItems := hudItems + 1;
end;


procedure MainCharacter.CheatingMode();
begin

  keyPressed := Readkey;
  if keyPressed = '*' then
  begin
    writeln('                            Cheating mode enabled!');
    mainChar.hp := 300;
    mainChar.maxhp := 300;
    mainChar.damage := 100;
    readkey;
  end;
  clrscr;
end;

{ ### PROCEDURES DE CRITTER ### }

procedure Critter.existence();
begin
  mcritterint[1, 1] := 1; //doy vida a una criatura
  mcritterint[1, 2] := 1;
  mcritterint[1, 3] := 1;
  mcritterint[1, 4] := 1;
  mcritterint[1, 5] := 1;
  mcritterint[1, 6] := 1;
  mcritterint[1, 7] := 1;
  mcritterint[1, 8] := 1;
  mcritterint[1, 9] := 1;
  mcritterint[1, 10] := 1;
  mcritterint[1, 11] := 1;
  mcritterint[1, 12] := 1;
  mcritterint[1, 13] := 1;
  mcritterint[1, 14] := 1;
  mcritterint[1, 15] := 1;
  mcritterint[1, 16] := 1;
  mcritterint[1, 17] := 1;
  mcritterint[1, 18] := 1;
  mcritterint[1, 19] := 1;
  mcritterint[1, 20] := 1;
  for j0 := 1 to maxcritter do
  begin
    if mcritterint[1, j0] = 1 then // si se habilito respawn
    begin
      mcritterint[1, j0] := 0; //apago respawn
      GenerateCritterSetStatsAndPosition();
    end;

  end;
end;

procedure Critter.GenerateCritterSetStatsAndPosition();
var
  spawning, aspawning: integer;
begin
  mcritterint[2, j0] := 1;//live = true

  repeat
    mcritterint[3, j0] := random(col - 8) + 5; // posicion inicial x
    mcritterint[4, j0] := random(fila - 8) + 5; // posicion inicial y

  until gameInterfaceImpl.give_mpos(mcritterint[4, j0], mcritterint[3, j0]) = 0;

  aspawning := random(100) + 1;
  case aspawning of
    1..40: spawning := 1; //rabbit
    41..70: spawning := 2; //fox
    71..90: spawning := 3;  //wolf
    91..100: spawning := 4; //bear
  end;
  if j0 = 1 then
    spawning := 5;

  mcritterstr[1, j0] := nombres[1, spawning]; // seteo nom creat
  mcritterstr[2, j0] := nombres[2, spawning]; // seteo letra creat

  mcritterint[5, j0] := estadisticas[1, spawning]; //set aggro
  mcritterint[6, j0] := estadisticas[2, spawning]; //set hp
  mcritterint[7, j0] := estadisticas[3, spawning]; //set atk
  mcritterint[8, j0] := estadisticas[4, spawning]; //set num simbol

  update_mpos();

end;

procedure Critter.update_mpos();
begin
  bufmpos := mcritterint[8, j0];
  gameInterfaceImpl.set_mpos(mcritterint[4, j0], mcritterint[3, j0]);
end;

procedure Critter.CritterTakeDamage();
begin
  if (mainChar.atx = mcritterint[3, j0]) and (mainChar.aty = mcritterint[4, j0])
  then // (3,j0) posicion x / (4,j0) posicion y
  begin
    mcritterint[5, j0] := 1; // aggro on
    mcritterint[6, j0] := mcritterint[6, j0] - mainChar.damage;  //hp-damage

    isMainCharacterAttacking := False;
    mainChar.aty := 0;
    mainChar.atx := 0;
  end;
  if mcritterint[6, j0] < 0 then
    mcritterint[2, j0] := 0; // si hp<0 -> live = false
end;

procedure Critter.despawn();
begin

  bufmpos := 0;
  gameInterfaceImpl.set_mpos(mcritterint[4, j0], mcritterint[3, j0]);
  //altera matriz mpos dejando espacio vacio
  if mcritterstr[1, j0] <> 'Shadow' then
  begin
    xfru := mcritterint[3, j0];
    yfru := mcritterint[4, j0];
    DropItemOnDead();
  end;
  if mcritterstr[1, j0] = 'Shadow' then
    Shadow_killed := True;

end;

procedure Critter.stance(ag: integer);
begin
  ag := random(2);

  for i := 1 to 2 do
  begin
    if (mainChar.x = mcritterint[3, j0]) and (ag = 0) then
      ag := random(2) //si ya estas en su x y sale moverse en x, re-tirar
    else
    if (mainChar.y = mcritterint[4, j0]) and (ag = 1) then
      ag := random(2);

  end;

  case ag of

    0:
    begin
      if (mainChar.x < mcritterint[3, j0]) then
        choice := 0;

      if (mainChar.x > mcritterint[3, j0]) then
        choice := 1;
    end;


    1:
    begin
      if (mainChar.y < mcritterint[4, j0]) then
        choice := 2;

      if (mainChar.y > mcritterint[4, j0]) then
        choice := 3;
    end;
  end;

end;

procedure Critter.movement(m: integer);
begin
  if mcritterint[5, j0] = 0 then
    m := random(4)
  else
    m := choice; // aggro=0 mov aleatorio, aggro=1 mov persigue

  case m of
    0:
    begin
      yb := mcritterint[4, j0];      // y
      xb := mcritterint[3, j0] - 1;  // x
    end;

    1:
    begin
      yb := mcritterint[4, j0];
      xb := mcritterint[3, j0] + 1;
    end;

    2:
    begin
      yb := mcritterint[4, j0] - 1;
      xb := mcritterint[3, j0];
    end;

    3:
    begin
      yb := mcritterint[4, j0] + 1;
      xb := mcritterint[3, j0];
    end;
  end;

  if (gameInterfaceImpl.give_mbase(yb, xb) <> 0) then
  begin
    case gameInterfaceImpl.give_mpos(yb, xb) of


      0..1:
      begin     {encontro un espacio vacio}
        if (gameInterfaceImpl.give_mbase(yb, xb) <> 3) then
        begin
          bufmpos := 0;
          gameInterfaceImpl.set_mpos(mcritterint[4, j0], mcritterint[3, j0]);
          //altera matriz mpos dejando espacio vacio

          mcritterint[4, j0] := yb;  // se mueve a nuevo y
          mcritterint[3, j0] := xb;  // se mueve a nuevo x

          bufmpos := mcritterint[8, j0];
          gameInterfaceImpl.set_mpos(mcritterint[4, j0], mcritterint[3, j0]);
          //altera matriz mpos dejando su simbolo

          status := (' El ' + mcritterstr[1, j0] + ' se a movido!');
        end;
      end;

      2:
      begin        {encuentra un personaje}
        mainChar.hp := mainChar.hp - mcritterint[7, j0];
        //personaje hp - critter damage
        status := (' El ' + mcritterstr[1, j0] + ' te a atacado!');

      end;
    end;
  end;

end;

procedure Critter.DropItemOnDead();
begin
  itemInterface.CreatureSpawnMeat();
end;

procedure Critter.Behavior();
begin
  for j0 := 1 to maxcritter do
  begin

    if mcritterint[2, j0] = 1 then //si esta vivo hacer
    begin

      if isMainCharacterAttacking = True then
      begin
        CritterTakeDamage();
      end;

      if mcritterint[2, j0] = 1 then
        // si sigue vivo dsp de recibir daño
      begin
        stance(1);
        movement(1);
      end
      else
        despawn();  //si no sigue vivo, apagar

    end;

  end;
end;


end.
