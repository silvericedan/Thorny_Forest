program ThornyForest;

uses
  crt,
  GameEntities,
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
  gameInterfaceImpl.Load_mbase();
  mainChar.InitializeStats();
  TextStoryScreenImpl.Initial();
  mainChar.CheatingMode();
  mainChar.PassMposAndStatsToGameInterface();
  itemInterface.InitializeItems();
  monstruos.existence();

  gameInterfaceImpl.Update_mdraw();
  gameInterfaceImpl.Copy_map();
  ch := #40;

  while (ch <> #27) and (salida <> 1) do
  begin
    gameInterfaceImpl.Update_mdraw();
    gameInterfaceImpl.Camera();
    gameInterfaceImpl.Copy_map();
    mainChar.DetectKeyboardInput();
    mainChar.PlayerMovement();
    mainChar.PassMposAndStatsToGameInterface();
    monstruos.Behavior();
    mainChar.PassMposAndStatsToGameInterface();
    gameInterfaceImpl.Game_conditions();

  end;

  TextStoryScreenImpl.Final()

end.
