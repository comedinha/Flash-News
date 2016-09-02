package loader.asset
{
   import flash.events.IEventDispatcher;
   import tibia.game.GameBinaryAsset;
   import tibia.appearances.AppearancesAsset;
   import tibia.game.AssetBase;
   import tibia.options.OptionsAsset;
   import tibia.sessiondump.SessiondumpAsset;
   import tibia.game.SpritesAsset;
   
   public interface IAssetProvider extends IEventDispatcher
   {
       
      
      function get bytesTotalMandatory() : uint;
      
      function getGameBinary() : GameBinaryAsset;
      
      function getAppearances() : AppearancesAsset;
      
      function get loadQueueDelay() : uint;
      
      function getAssetsByClass(param1:Class) : Vector.<AssetBase>;
      
      function get bytesLoadedMandatory() : uint;
      
      function removeAsset(param1:AssetBase) : void;
      
      function getAssetByKey(param1:Object) : AssetBase;
      
      function get bytesLoaded() : uint;
      
      function getDefaultOptionsTutorial() : OptionsAsset;
      
      function set concurrentLoaders(param1:uint) : void;
      
      function getDefaultOptions() : OptionsAsset;
      
      function get loadingFinished() : Boolean;
      
      function set loadQueueDelay(param1:uint) : void;
      
      function get concurrentLoaders() : uint;
      
      function get bytesTotal() : uint;
      
      function getCurrentOptions() : OptionsAsset;
      
      function getSessiondumpAsset() : SessiondumpAsset;
      
      function getSpriteAssets() : Vector.<SpritesAsset>;
      
      function pushAssetForwardInLoadingQueueByKey(param1:String) : void;
   }
}
