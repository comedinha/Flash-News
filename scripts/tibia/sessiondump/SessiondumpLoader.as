package tibia.sessiondump
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import shared.utility.URLHelper;
   
   public class SessiondumpLoader extends EventDispatcher
   {
      
      private static const STATE_DEFAULT:int = 0;
      
      private static const STATE_ERROR:int = -1;
      
      private static const STATE_LOADED:int = 2;
      
      private static const STATE_LOADING:int = 1;
       
      
      private var m_State:uint = 0;
      
      private var m_InputStream:ByteArray = null;
      
      private var m_URLStream:URLStream = null;
      
      public function SessiondumpLoader()
      {
         super();
      }
      
      public function get isLoadingFinished() : Boolean
      {
         return this.m_State == STATE_LOADED;
      }
      
      public function get inputStream() : ByteArray
      {
         return this.m_InputStream;
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         if(this.m_URLStream != null)
         {
            if(this.m_URLStream.bytesAvailable > 0)
            {
               this.m_URLStream.readBytes(this.m_InputStream,this.m_InputStream.length);
            }
         }
         this.m_State = STATE_LOADED;
         dispatchEvent(param1);
      }
      
      public function load(param1:String) : void
      {
         if(this.m_State == STATE_DEFAULT)
         {
            this.unloadLoader();
            this.m_InputStream = new ByteArray();
            this.m_InputStream.endian = Endian.LITTLE_ENDIAN;
            this.m_URLStream = new URLStream();
            this.m_URLStream.addEventListener(Event.COMPLETE,this.onLoaderComplete);
            this.m_URLStream.addEventListener(ProgressEvent.PROGRESS,this.onLoaderProgress);
            this.m_URLStream.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
            this.m_URLStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoaderError);
            this.m_URLStream.load(new URLRequest(URLHelper.s_NoCache(param1)));
            this.m_State = STATE_LOADING;
         }
      }
      
      public function get isLoading() : Boolean
      {
         return this.m_State == STATE_LOADING;
      }
      
      private function onLoaderError(param1:ErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function unloadLoader() : void
      {
         if(this.m_URLStream != null)
         {
            if(this.m_State == STATE_LOADING)
            {
               try
               {
                  this.m_URLStream.close();
               }
               catch(_Error:*)
               {
               }
            }
            this.m_URLStream.removeEventListener(Event.COMPLETE,this.onLoaderComplete);
            this.m_URLStream.removeEventListener(ProgressEvent.PROGRESS,this.onLoaderProgress);
            this.m_URLStream.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
            this.m_URLStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoaderError);
            this.m_URLStream = null;
            this.m_InputStream = null;
         }
      }
      
      private function onLoaderProgress(param1:ProgressEvent) : void
      {
         if(this.m_URLStream != null && this.m_URLStream.bytesAvailable > 0)
         {
            this.m_URLStream.readBytes(this.m_InputStream,this.m_InputStream.length);
         }
      }
   }
}
