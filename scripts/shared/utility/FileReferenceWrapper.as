package shared.utility
{
   import flash.net.FileReference;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.DataEvent;
   import flash.events.HTTPStatusEvent;
   import flash.errors.IllegalOperationError;
   
   public class FileReferenceWrapper extends FileReference
   {
      
      private static var s_Instance:shared.utility.FileReferenceWrapper = null;
       
      
      public function FileReferenceWrapper()
      {
         super();
      }
      
      override public function upload(param1:URLRequest, param2:String = "Filedata", param3:Boolean = false) : void
      {
         var a_Rquest:URLRequest = param1;
         var a_UploadDataFieldName:String = param2;
         var a_TestUpload:Boolean = param3;
         this.checkInstance();
         this.setInstance();
         try
         {
            super.upload(a_Rquest,a_UploadDataFieldName,a_TestUpload);
            return;
         }
         catch(_Error:*)
         {
            clearInstance();
            throw _Error;
         }
      }
      
      private function clearInstance(... rest) : void
      {
         s_Instance = null;
         removeEventListener(Event.CANCEL,this.clearInstance);
         removeEventListener(Event.SELECT,this.clearInstance);
         removeEventListener(Event.COMPLETE,this.clearInstance);
         removeEventListener(IOErrorEvent.IO_ERROR,this.clearInstance);
         removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.clearInstance);
         removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,this.clearInstance);
         removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.clearInstance);
      }
      
      private function checkInstance() : void
      {
         if(s_Instance != null)
         {
            throw new IllegalOperationError();
         }
      }
      
      override public function load() : void
      {
         this.checkInstance();
         this.setInstance();
         try
         {
            super.load();
            return;
         }
         catch(_Error:*)
         {
            clearInstance();
            throw _Error;
         }
      }
      
      private function setInstance() : void
      {
         s_Instance = this;
         addEventListener(Event.CANCEL,this.clearInstance);
         addEventListener(Event.SELECT,this.clearInstance);
         addEventListener(Event.COMPLETE,this.clearInstance);
         addEventListener(IOErrorEvent.IO_ERROR,this.clearInstance);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.clearInstance);
         addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,this.clearInstance);
         addEventListener(HTTPStatusEvent.HTTP_STATUS,this.clearInstance);
      }
      
      override public function download(param1:URLRequest, param2:String = null) : void
      {
         var a_Request:URLRequest = param1;
         var a_DefaultFileName:String = param2;
         this.checkInstance();
         this.setInstance();
         try
         {
            return super.download(a_Request,a_DefaultFileName);
         }
         catch(_Error:*)
         {
            clearInstance();
            throw _Error;
         }
      }
      
      override public function cancel() : void
      {
         try
         {
            super.cancel();
            this.clearInstance();
            return;
         }
         catch(_Error:*)
         {
            throw _Error;
         }
      }
      
      override public function browse(param1:Array = null) : Boolean
      {
         var a_TypeFilter:Array = param1;
         this.checkInstance();
         this.setInstance();
         try
         {
            return super.browse(a_TypeFilter);
         }
         catch(_Error:*)
         {
            clearInstance();
            throw _Error;
         }
         return false;
      }
      
      override public function save(param1:*, param2:String = null) : void
      {
         var a_Data:* = param1;
         var a_DefaultFileName:String = param2;
         this.checkInstance();
         this.setInstance();
         try
         {
            super.save(a_Data,a_DefaultFileName);
            return;
         }
         catch(_Error:*)
         {
            clearInstance();
            throw _Error;
         }
      }
   }
}
