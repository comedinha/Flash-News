package tibia.game
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   
   public class SecureWebsiteService extends EventDispatcher
   {
       
      
      private var m_Loader:URLLoader = null;
      
      private var m_UploadToken:String = null;
      
      private var m_ServiceData:Object = null;
      
      private var m_ServiceURL:String = null;
      
      public function SecureWebsiteService(param1:String)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("SecureWebsiteService.SecureWebsiteService: service url can\'t be null");
         }
         this.m_ServiceURL = param1;
      }
      
      private function onUploadError(param1:ErrorEvent) : void
      {
         this.unloadLoader();
         dispatchEvent(param1);
      }
      
      public function startServiceCall(param1:String) : void
      {
         this.unloadLoader();
         this.m_UploadToken = null;
         this.m_Loader = new URLLoader();
         this.m_Loader.addEventListener(Event.COMPLETE,this.onUploadComplete);
         this.m_Loader.addEventListener(IOErrorEvent.IO_ERROR,this.onUploadError);
         this.m_Loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadError);
         var _loc2_:URLRequest = new URLRequest(this.m_ServiceURL);
         _loc2_.contentType = "application/json";
         _loc2_.method = URLRequestMethod.POST;
         _loc2_.data = JSON.stringify({"sid":param1});
         this.m_Loader.load(_loc2_);
      }
      
      private function unloadLoader() : void
      {
         if(this.m_Loader != null)
         {
            try
            {
               this.m_Loader.close();
            }
            catch(e:Error)
            {
            }
            this.m_Loader.removeEventListener(Event.COMPLETE,this.onUploadComplete);
            this.m_Loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onUploadError);
            this.m_Loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadError);
            this.m_Loader = null;
         }
      }
      
      private function onUploadComplete(param1:Event) : void
      {
         var ErrorCode:int = 0;
         var ServiceEvent:SecureWebsiteServiceEvent = null;
         var _URLRequest:URLRequest = null;
         var _SecureWebsiteServiceEvent:SecureWebsiteServiceEvent = null;
         var a_Event:Event = param1;
         var Result:Object = null;
         var _Event:Event = null;
         try
         {
            Result = JSON.parse(this.m_Loader.data);
         }
         catch(e:TypeError)
         {
         }
         if(Result == null || "errorcode" in Result && Result["errorcode"] !== 0)
         {
            this.m_UploadToken = null;
            this.unloadLoader();
            if(Result == null)
            {
               _Event = new ErrorEvent(ErrorEvent.ERROR,false,false,"Website service request failed: Result is empty");
            }
            else
            {
               ErrorCode = Result["errorcode"];
               _Event = new ErrorEvent(ErrorEvent.ERROR,false,false,"Website service request failed: " + Result["errorcode"],ErrorCode);
            }
            dispatchEvent(_Event);
            return;
         }
         if(this.m_UploadToken == null)
         {
            if("token" in Result)
            {
               this.m_UploadToken = Result["token"];
            }
            if(this.m_UploadToken != null)
            {
               this.m_ServiceData = new Object();
               ServiceEvent = new SecureWebsiteServiceEvent(SecureWebsiteServiceEvent.REQUEST_DATA,false,true,this.m_ServiceData);
               dispatchEvent(ServiceEvent);
               if(ServiceEvent.isDefaultPrevented())
               {
                  this.unloadLoader();
                  this.m_UploadToken = null;
               }
               else
               {
                  this.m_ServiceData["token"] = this.m_UploadToken;
                  _URLRequest = new URLRequest(this.m_ServiceURL);
                  _URLRequest.contentType = "application/json";
                  _URLRequest.method = URLRequestMethod.POST;
                  _URLRequest.data = JSON.stringify(this.m_ServiceData);
                  this.m_Loader.load(_URLRequest);
               }
            }
            else
            {
               this.m_UploadToken = null;
               this.unloadLoader();
               _Event = new ErrorEvent(ErrorEvent.ERROR,false,false,"Invalid token.");
               dispatchEvent(_Event);
            }
         }
         else
         {
            _SecureWebsiteServiceEvent = new SecureWebsiteServiceEvent(SecureWebsiteServiceEvent.COMPLETE,false,true,Result);
            dispatchEvent(_SecureWebsiteServiceEvent);
            this.m_UploadToken = null;
            this.unloadLoader();
            dispatchEvent(a_Event);
         }
      }
   }
}
