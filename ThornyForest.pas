program ThornyForest;

uses
  crt,
  GameEntities,
  GameInterface,
  TextStoryScreen;

begin
  randomize();
  gameInterfaceImpl.Load_mbase();
  mainChar.InitializeStats();
  TextStoryScreenImpl.Initial();
  mainChar.CheatingMode();
  mainChar.PassMposAndStatsToGameInterface();
  itemInterface.InitializeItems();
  npcCritter.EnableCrittersSpawn();

  gameInterfaceImpl.Update_mdraw();
  gameInterfaceImpl.Copy_map();
  keyPressed := #40;

  while (keyPressed <> #27) and (salida <> 1) do
  begin
    gameInterfaceImpl.Update_mdraw();
    gameInterfaceImpl.Camera();
    gameInterfaceImpl.Copy_map();
    mainChar.DetectKeyboardInput();
    mainChar.PlayerMovement();
    mainChar.PassMposAndStatsToGameInterface();
    npcCritter.Behavior();
    mainChar.PassMposAndStatsToGameInterface();
    gameInterfaceImpl.Game_conditions();

  end;

  TextStoryScreenImpl.Final()

end.
