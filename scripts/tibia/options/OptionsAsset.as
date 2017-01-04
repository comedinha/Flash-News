package tibia.options
{
   import flash.errors.IOError;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.utils.ByteArray;
   import mx.utils.Base64Decoder;
   import mx.utils.Base64Encoder;
   import tibia.game.AssetBase;
   import tibia.game.SecureWebsiteService;
   import tibia.game.SecureWebsiteServiceEvent;
   
   public class OptionsAsset extends AssetBase
   {
       
      
      private var m_SecureWebsiteService:SecureWebsiteService = null;
      
      private var m_UploadXML:XML = null;
      
      private var m_XML:XML = null;
      
      private var m_ParsingError:Boolean = false;
      
      private var m_IsTutorialOptions:Boolean = false;
      
      private var m_IsDefaultOptions:Boolean = false;
      
      public function OptionsAsset(param1:String, param2:int = 0, param3:String = "application/json", param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param2,param3);
         this.m_IsDefaultOptions = param4;
         this.m_IsTutorialOptions = param5;
         m_NoCacheEnabled = true;
         if(param4 == false)
         {
            this.m_SecureWebsiteService = new SecureWebsiteService(param1);
            this.m_SecureWebsiteService.addEventListener(SecureWebsiteServiceEvent.REQUEST_DATA,this.onWebsiteServiceRequestData);
            this.m_SecureWebsiteService.addEventListener(SecureWebsiteServiceEvent.COMPLETE,this.onWebsiteServiceComplete);
            this.m_SecureWebsiteService.addEventListener(ErrorEvent.ERROR,this.onWebsiteServiceError);
            this.m_SecureWebsiteService.addEventListener(IOErrorEvent.IO_ERROR,this.onWebsiteServiceError);
         }
      }
      
      private function onWebsiteServiceRequestData(param1:SecureWebsiteServiceEvent) : void
      {
         var _ByteArray:ByteArray = null;
         var Encoder:Base64Encoder = null;
         var a_Event:SecureWebsiteServiceEvent = param1;
         try
         {
            _ByteArray = new ByteArray();
            _ByteArray.writeUTFBytes(this.m_UploadXML.toXMLString());
            _ByteArray.compress();
            Encoder = new Base64Encoder();
            Encoder.encodeBytes(_ByteArray);
            a_Event.serviceData["options"] = Encoder.toString();
            return;
         }
         catch(Error:*)
         {
            a_Event.preventDefault();
            return;
         }
      }
      
      public function get hasParsingError() : Boolean
      {
         return this.m_ParsingError;
      }
      
      override protected function processDownloadedData(param1:URLLoader) : Boolean
      {
         var Result:Object = null;
         var Decoder:Base64Decoder = null;
         var _ByteArray:ByteArray = null;
         var a_Loader:URLLoader = param1;
         var XMLString:String = null;
         var IsLiveOptions:Boolean = false;
         if(contentType == "application/json")
         {
            try
            {
               IsLiveOptions = true;
               Result = JSON.parse(String(a_Loader.data));
               if("options" in Result)
               {
                  Decoder = new Base64Decoder();
                  Decoder.decode(Result["options"]);
                  _ByteArray = Decoder.toByteArray();
                  _ByteArray.uncompress();
                  XMLString = _ByteArray.readUTFBytes(_ByteArray.bytesAvailable);
               }
            }
            catch(e:TypeError)
            {
            }
            catch(e:IOError)
            {
            }
         }
         else if(contentType == "text/xml")
         {
            XMLString = String(a_Loader.data);
         }
         else
         {
            return false;
         }
         try
         {
            this.m_XML = new XML(XMLString);
         }
         catch(e:*)
         {
            m_ParsingError = true;
            m_XML = null;
         }
         finally
         {
            if(IsLiveOptions && this.hasParsingError)
            {
               return true;
            }
            return this.m_XML != null;
         }
      }
      
      public function get isDefaultOptions() : Boolean
      {
         return this.m_IsDefaultOptions;
      }
      
      override public function get loaded() : Boolean
      {
         return this.m_XML != null;
      }
      
      public function upload(param1:XML, param2:String) : void
      {
         if(param1 == null)
         {
            throw new Error("OptionsAsset.upload: Invalid data.");
         }
         this.m_UploadXML = param1;
         this.m_SecureWebsiteService.startServiceCall(param2);
      }
      
      public function get isTutorialOptions() : Boolean
      {
         return this.m_IsTutorialOptions;
      }
      
      public function get xml() : XML
      {
         return this.m_XML;
      }
      
      override protected function resetDownloadedData() : void
      {
         this.m_XML = null;
      }
      
      private function onWebsiteServiceError(param1:ErrorEvent) : void
      {
         this.m_UploadXML = null;
         dispatchEvent(param1);
      }
      
      private function onWebsiteServiceComplete(param1:SecureWebsiteServiceEvent) : void
      {
         this.m_UploadXML = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
