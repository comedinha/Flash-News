package tibia.cursors
{
   import mx.managers.ICursorManager;
   import mx.managers.CursorManagerPriority;
   import flash.ui.Mouse;
   
   public class CustomCursorManagerImpl implements ICursorManager
   {
      
      private static var s_Instance:ICursorManager = null;
       
      
      private var m_CursorList:Vector.<CursorQueueItem>;
      
      protected var m_CursorPriority:int = -1;
      
      protected var m_CursorID:int = 0;
      
      private var m_NextCursorID:int = 1;
      
      public function CustomCursorManagerImpl()
      {
         this.m_CursorList = new Vector.<CursorQueueItem>();
         super();
      }
      
      public static function getInstance() : ICursorManager
      {
         if(s_Instance == null)
         {
            s_Instance = new CustomCursorManagerImpl();
         }
         return s_Instance;
      }
      
      public function set currentCursorYOffset(param1:Number) : void
      {
      }
      
      public function get currentCursorXOffset() : Number
      {
         return 0;
      }
      
      public function get currentCursorYOffset() : Number
      {
         return 0;
      }
      
      private function cursorClassToCursorName(param1:Class) : String
      {
         var _loc2_:String = DefaultCursor.CURSOR_NAME;
         switch(param1)
         {
            case DefaultRejectCursor:
               _loc2_ = DefaultRejectCursor.CURSOR_NAME;
               break;
            case CrosshairCursor:
               _loc2_ = CrosshairCursor.CURSOR_NAME;
               break;
            case DragCopyCursor:
               _loc2_ = DragCopyCursor.CURSOR_NAME;
               break;
            case DragLinkCursor:
               _loc2_ = DragLinkCursor.CURSOR_NAME;
               break;
            case DragMoveCursor:
               _loc2_ = DragMoveCursor.CURSOR_NAME;
               break;
            case DragNoneCursor:
               _loc2_ = DragNoneCursor.CURSOR_NAME;
               break;
            case ResizeHorizontalCursor:
               _loc2_ = ResizeHorizontalCursor.CURSOR_NAME;
               break;
            case ResizeVerticalCursor:
               _loc2_ = ResizeVerticalCursor.CURSOR_NAME;
               break;
            case AttackCursor:
               _loc2_ = AttackCursor.CURSOR_NAME;
               break;
            case WalkCursor:
               _loc2_ = WalkCursor.CURSOR_NAME;
               break;
            case UseCursor:
               _loc2_ = UseCursor.CURSOR_NAME;
               break;
            case TalkCursor:
               _loc2_ = TalkCursor.CURSOR_NAME;
               break;
            case OpenCursor:
               _loc2_ = OpenCursor.CURSOR_NAME;
               break;
            case LookCursor:
               _loc2_ = LookCursor.CURSOR_NAME;
               break;
            default:
               _loc2_ = DefaultCursor.CURSOR_NAME;
         }
         return _loc2_;
      }
      
      public function hideCursor() : void
      {
      }
      
      public function removeCursor(param1:int) : void
      {
         var _loc3_:CursorQueueItem = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.m_CursorList.length)
         {
            _loc3_ = this.m_CursorList[_loc2_];
            if(_loc3_.m_CursorID == param1)
            {
               this.m_CursorList.splice(_loc2_,1);
               this.showCurrentCursor();
               break;
            }
            _loc2_++;
         }
      }
      
      public function set currentCursorXOffset(param1:Number) : void
      {
      }
      
      public function get currentCursorID() : int
      {
         return this.m_CursorID;
      }
      
      public function removeBusyCursor() : void
      {
      }
      
      public function set currentCursorID(param1:int) : void
      {
      }
      
      public function setCursor(param1:Class, param2:int = 2, param3:Number = 0, param4:Number = 0) : int
      {
         var _loc5_:int = ++this.m_NextCursorID;
         var _loc6_:CursorQueueItem = new CursorQueueItem();
         _loc6_.m_CursorID = _loc5_;
         _loc6_.m_CursorName = this.cursorClassToCursorName(param1);
         if(_loc6_.m_CursorName.substr(0,4) == "drag")
         {
            _loc6_.m_Priority = CursorManagerPriority.HIGH;
         }
         else
         {
            _loc6_.m_Priority = param2;
         }
         this.m_CursorList.push(_loc6_);
         this.m_CursorList.sort(this.priorityCompare);
         this.showCurrentCursor();
         return _loc5_;
      }
      
      public function removeAllCursors() : void
      {
         this.m_CursorList.length = 0;
         this.showCurrentCursor();
      }
      
      private function priorityCompare(param1:CursorQueueItem, param2:CursorQueueItem) : int
      {
         if(param1.m_Priority < param2.m_Priority)
         {
            return -1;
         }
         if(param1.m_Priority == param2.m_Priority)
         {
            if(param1.m_CursorID > param2.m_CursorID)
            {
               return -1;
            }
            if(param1.m_CursorID == param2.m_CursorID)
            {
               return 0;
            }
            return 1;
         }
         return 1;
      }
      
      public function registerToUseBusyCursor(param1:Object) : void
      {
      }
      
      public function unRegisterToUseBusyCursor(param1:Object) : void
      {
      }
      
      public function setBusyCursor() : void
      {
      }
      
      private function showCurrentCursor() : void
      {
         var _loc1_:CursorQueueItem = null;
         if(this.m_CursorList.length > 0)
         {
            _loc1_ = this.m_CursorList[0];
            Mouse.cursor = _loc1_.m_CursorName;
            this.m_CursorID = _loc1_.m_CursorID;
         }
         else
         {
            Mouse.cursor = DefaultCursor.CURSOR_NAME;
         }
      }
      
      public function showCursor() : void
      {
      }
   }
}

class CursorQueueItem
{
    
   
   public var m_CursorName:String = null;
   
   public var m_CursorID:int = 0.0;
   
   public var m_Priority:int = 2.0;
   
   function CursorQueueItem()
   {
      super();
   }
}
