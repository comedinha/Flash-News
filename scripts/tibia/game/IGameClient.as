package tibia.game
{
   import flash.events.IEventDispatcher;
   import tibia.network.IConnectionData;
   import loader.asset.IAssetProvider;
   
   public interface IGameClient extends IEventDispatcher
   {
       
      
      function set isActive(param1:Boolean) : void;
      
      function saveOptions() : void;
      
      function unload() : void;
      
      function setConnectionDataList(param1:Vector.<IConnectionData>, param2:uint) : void;
      
      function setSessionKey(param1:String) : void;
      
      function initializeGameClient(param1:Boolean, param2:Object = null) : void;
      
      function setClientSize(param1:uint, param2:uint) : void;
      
      function get isActive() : Boolean;
      
      function get isRunning() : Boolean;
      
      function get currentConnection() : Object;
      
      function saveLocalData() : void;
      
      function set isFocusNotifierEnabled(param1:Boolean) : void;
      
      function setAssetProvider(param1:IAssetProvider) : void;
   }
}
