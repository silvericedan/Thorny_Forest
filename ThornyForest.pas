program ThornyForest;

uses
  crt,
  Actors,
  GameInterface,
  TextStoryScreen;

{TODO: - SISTEMA DE ITEMS QUE UPGRADEAN  echo!
       - MAPA MAS GRANDE GENERADO RANDOM  echo!
       - TERRENO LISO . ARBUSTOS & Y ARBOLES %% arbustos no, complicaria el movimiento
       ya que cuando el personaje se mueve vuelve a escribir el casillero en 1. Una idea para resolverlo es...
       Para este caso, deberiamos usar una matriz que guarde el piso y las paredes, y otra matriz aparte que guarde el lugar de
       los personajes. En ese caso, para moverse el personaje primero chequearia la matriz de suelo, para ver si el espacio que quiere
       avanzar se encuentra algun muro o arbusto, luego si el espacio es caminable, deberia chequear si hay alguna criatura parada sobre ese suelo. echo!}

begin
  randomize();
  TextStoryScreenImpl.Initial();
  GameInterfaceImpl.Load_mbase();
  perso.respawn();
  perso.update_mpos();
  fruta.respawn();
  monstruos.existence();

  GameInterfaceImpl.Update_mdraw();
  GameInterfaceImpl.Copy_map();
  ch := #40;

  while (ch <> #27) and (salida <> 1) do
  begin
    GameInterfaceImpl.Update_mdraw();
    GameInterfaceImpl.Camera();
    GameInterfaceImpl.Copy_map();
    Perso.Detect_Keyboard();
    Perso.Player_Movement();
    perso.update_mpos();
    monstruos.behavior();
    if Drop_items = True then
    begin
      fruta.npc_created();
      Drop_items := False;
    end;
    perso.update_mpos();
    GameInterfaceImpl.Game_conditions();

  end;

  TextStoryScreenImpl.Final()

end.
