package tibia.tutorial
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import mx.resources.ResourceManager;
   import tibia.game.AssetBase;
   import tibia.game.SecureWebsiteService;
   import tibia.game.SecureWebsiteServiceEvent;
   
   public class TutorialProgressServiceAsset extends AssetBase
   {
      
      private static const BUNDLE:String = "Communication";
       
      
      private var m_CharacterName:String = null;
      
      private var m_SecureWebsiteService:SecureWebsiteService = null;
      
      private var m_ProgressIdentifierToUpload:String = null;
      
      public function TutorialProgressServiceAsset(param1:String, param2:int = 0, param3:String = "application/json")
      {
         super(param1,param2,param3);
         this.m_SecureWebsiteService = new SecureWebsiteService(param1);
         this.m_SecureWebsiteService.addEventListener(SecureWebsiteServiceEvent.REQUEST_DATA,this.onWebsiteServiceRequestData);
         this.m_SecureWebsiteService.addEventListener(SecureWebsiteServiceEvent.COMPLETE,this.onWebsiteServiceComplete);
         this.m_SecureWebsiteService.addEventListener(ErrorEvent.ERROR,this.onWebsiteServiceError);
         this.m_SecureWebsiteService.addEventListener(IOErrorEvent.IO_ERROR,this.onWebsiteServiceError);
      }
      
      override protected function processDownloadedData(param1:URLLoader) : Boolean
      {
         return true;
      }
      
      override public function get loaded() : Boolean
      {
         return true;
      }
      
      private function onWebsiteServiceRequestData(param1:SecureWebsiteServiceEvent) : void
      {
         var a_Event:SecureWebsiteServiceEvent = param1;
         try
         {
            a_Event.serviceData["progress"] = this.m_ProgressIdentifierToUpload;
            a_Event.serviceData["charactername"] = this.m_CharacterName;
            return;
         }
         catch(Error:*)
         {
            a_Event.preventDefault();
            return;
         }
      }
      
      override public function load() : void
      {
         super.load();
      }
      
      private function onWebsiteServiceError(param1:ErrorEvent) : void
      {
         this.m_ProgressIdentifierToUpload = null;
         var _loc2_:String = null;
         var _loc3_:ErrorEvent = null;
         if(param1.errorID == -4)
         {
            _loc2_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_USER_HAS_LOGGED_OUT_WHILE_PLAYING");
            _loc3_ = new ErrorEvent(ErrorEvent.ERROR,false,false,_loc2_);
            dispatchEvent(_loc3_);
         }
         else if(param1.errorID != -5)
         {
            _loc2_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_LOST_CONNECTION");
            _loc3_ = new ErrorEvent(ErrorEvent.ERROR,false,false,_loc2_,param1.errorID);
            dispatchEvent(_loc3_);
            param1.preventDefault();
         }
      }
      
      private function onWebsiteServiceComplete(param1:SecureWebsiteServiceEvent) : void
      {
         this.m_ProgressIdentifierToUpload = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function sendProgress(param1:String, param2:String, param3:String) : void
      {
         this.m_ProgressIdentifierToUpload = param1;
         this.m_CharacterName = param2;
         this.m_SecureWebsiteService.startServiceCall(param3);
      }
   }
}
