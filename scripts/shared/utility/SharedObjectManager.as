package shared.utility
{
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.events.NetStatusEvent;
   
   public class SharedObjectManager
   {
      
      protected static var s_Instance:shared.utility.SharedObjectManager = null;
      
      protected static const LISTING_NAME:String = "listing";
      
      protected static var s_SharedObject:SharedObject = null;
      
      protected static var s_AllocatedSize:int = int.MIN_VALUE;
      
      public static const STORAGE_UNLIMITED:int = 10 * 1024 * 1024 + 1;
       
      
      protected var m_Secure:Boolean = false;
      
      protected var m_SharedObject:SharedObject = null;
      
      protected var m_LocalPath:String = null;
      
      public function SharedObjectManager(param1:String = "/", param2:Boolean = false)
      {
         var a_LocalPath:String = param1;
         var a_Secure:Boolean = param2;
         super();
         this.m_LocalPath = a_LocalPath;
         this.m_Secure = a_Secure;
         this.m_SharedObject = null;
         try
         {
            this.m_SharedObject = SharedObject.getLocal(LISTING_NAME,this.m_LocalPath,this.m_Secure);
            return;
         }
         catch(_Error:*)
         {
            return;
         }
      }
      
      public static function s_AllocateSpace(param1:int = 1.0485761E7, param2:Function = null, param3:Boolean = false) : void
      {
         var a_RequestedSize:int = param1;
         var a_Callback:Function = param2;
         var a_Rerequest:Boolean = param3;
         var SafeCallback:Function = a_Callback != null?a_Callback:function(param1:Boolean):void
         {
         };
         if(s_SharedObject != null)
         {
            SafeCallback(false);
            return;
         }
         var SafeSize:int = Math.abs(a_RequestedSize);
         if(s_AllocatedSize != int.MIN_VALUE && !a_Rerequest || SafeSize <= s_AllocatedSize)
         {
            SafeCallback(SafeSize <= s_AllocatedSize);
            return;
         }
         s_AllocateSpaceInternal(SafeSize,SafeCallback,true);
      }
      
      public static function s_SharedObjectsAvailable() : Boolean
      {
         return s_AllocatedSize > -1;
      }
      
      protected static function s_AllocateSpaceInternal(param1:int, param2:Function, param3:Boolean = true) : void
      {
         var Name:String = null;
         var Listener:Function = null;
         var a_RequestedSize:int = param1;
         var a_Callback:Function = param2;
         var a_FirstPass:Boolean = param3;
         var FlushStatus:String = null;
         try
         {
            Name = new Date().time.toString(16);
            s_SharedObject = SharedObject.getLocal(Name,"/");
            FlushStatus = s_SharedObject.flush(a_RequestedSize);
         }
         catch(e:Error)
         {
            FlushStatus = null;
         }
         if(FlushStatus == SharedObjectFlushStatus.FLUSHED)
         {
            s_SharedObject.clear();
            s_SharedObject = null;
            s_AllocatedSize = Math.max(s_AllocatedSize,a_RequestedSize);
            a_Callback(true);
         }
         else if(FlushStatus == SharedObjectFlushStatus.PENDING)
         {
            Listener = function(param1:NetStatusEvent):void
            {
               var _loc2_:* = false;
               if(s_SharedObject != null)
               {
                  s_SharedObject.removeEventListener(NetStatusEvent.NET_STATUS,Listener);
                  s_SharedObject.clear();
                  s_SharedObject = null;
               }
               if(a_FirstPass && a_RequestedSize >= STORAGE_UNLIMITED && !checkPlayerVersion(10,1,0,0))
               {
                  s_AllocateSpaceInternal(a_RequestedSize,a_Callback,false);
               }
               else
               {
                  _loc2_ = param1.info.code == "SharedObject.Flush.Success";
                  s_AllocatedSize = !!_loc2_?int(Math.max(s_AllocatedSize,a_RequestedSize)):-1;
                  a_Callback(_loc2_);
               }
            };
            s_SharedObject.addEventListener(NetStatusEvent.NET_STATUS,Listener);
         }
         else
         {
            if(s_SharedObject != null)
            {
               s_SharedObject.clear();
               s_SharedObject = null;
            }
            s_AllocatedSize = -1;
            a_Callback(false);
         }
      }
      
      public static function s_GetInstance() : shared.utility.SharedObjectManager
      {
         if(s_Instance == null)
         {
            s_Instance = new shared.utility.SharedObjectManager();
         }
         return s_Instance;
      }
      
      public function exists(param1:String) : Boolean
      {
         return param1 != null && param1.length > 0 && this.m_SharedObject != null && this.m_SharedObject.data.hasOwnProperty(param1);
      }
      
      public function clear(param1:String, param2:Boolean = false) : void
      {
         var o:SharedObject = null;
         var a_Name:String = param1;
         var a_IncludeProtected:Boolean = param2;
         if(a_Name == null || a_Name.length < 1)
         {
            throw new ArgumentError("SharedObjectManager.clear: Invalid name: " + a_Name);
         }
         if(this.m_SharedObject != null)
         {
            if(!this.exists(a_Name) || !a_IncludeProtected && this.m_SharedObject.data[a_Name].isProtected)
            {
               return;
            }
         }
         try
         {
            o = SharedObject.getLocal(a_Name,this.m_LocalPath,this.m_Secure);
            if(o != null)
            {
               o.clear();
            }
            if(this.m_SharedObject != null)
            {
               delete this.m_SharedObject.data[a_Name];
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function getListing(param1:Boolean = false) : Array
      {
         var _loc3_:* = null;
         var _loc2_:Array = [];
         if(this.m_SharedObject != null)
         {
            for(_loc3_ in this.m_SharedObject.data)
            {
               if(!this.m_SharedObject.data[_loc3_].isProtected || param1)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
      
      public function get localPath() : String
      {
         return this.m_LocalPath;
      }
      
      public function getLocal(param1:String, param2:Boolean = true, param3:Boolean = false) : SharedObject
      {
         if(param1 == null || param1.length < 1)
         {
            throw new ArgumentError("SharedObjectManager.getLocal: Invalid name: " + param1);
         }
         if(this.m_SharedObject != null)
         {
            if(!param2 && !this.exists(param1))
            {
               return null;
            }
            this.m_SharedObject.data[param1] = {
               "name":param1,
               "lastAccess":new Date().time,
               "isProtected":param3
            };
         }
         return SharedObject.getLocal(param1,this.m_LocalPath,this.m_Secure);
      }
      
      public function get secure() : Boolean
      {
         return this.m_Secure;
      }
      
      public function syncListing() : void
      {
         try
         {
            if(this.m_SharedObject != null)
            {
               this.m_SharedObject.flush();
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
