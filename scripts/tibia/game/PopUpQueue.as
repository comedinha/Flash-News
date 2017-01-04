package tibia.game
{
   import mx.events.CloseEvent;
   import mx.managers.PopUpManager;
   import tibia.input.InputHandler;
   
   public class PopUpQueue
   {
      
      private static var s_Instance:PopUpQueue = null;
       
      
      private var m_Queue:Vector.<PopUpBase>;
      
      public function PopUpQueue()
      {
         this.m_Queue = new Vector.<PopUpBase>();
         super();
      }
      
      public static function getInstance() : PopUpQueue
      {
         if(s_Instance == null)
         {
            s_Instance = new PopUpQueue();
         }
         return s_Instance;
      }
      
      public function hide(param1:PopUpBase) : void
      {
         var _loc2_:int = -1;
         _loc2_ = this.m_Queue.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_Queue[_loc2_] == param1)
            {
               break;
            }
            _loc2_--;
         }
         if(_loc2_ == 0)
         {
            this.hideInternal(this.m_Queue[0]);
         }
         if(_loc2_ == 0 && this.m_Queue.length > 1)
         {
            this.showInternal(this.m_Queue[1]);
         }
         if(_loc2_ > -1)
         {
            this.m_Queue[_loc2_].removeEventListener(CloseEvent.CLOSE,this.onClose);
            this.m_Queue.splice(_loc2_,1);
         }
      }
      
      public function clear() : void
      {
         var _loc1_:int = 0;
         if(this.m_Queue.length > 0)
         {
            this.hideInternal(this.m_Queue[0]);
            _loc1_ = this.m_Queue.length - 1;
            while(_loc1_ >= 0)
            {
               this.m_Queue[_loc1_].removeEventListener(CloseEvent.CLOSE,this.onClose);
               _loc1_--;
            }
            this.m_Queue.length = 0;
         }
      }
      
      private function hideInternal(param1:PopUpBase) : void
      {
         PopUpManager.removePopUp(param1);
         var _loc2_:InputHandler = Tibia.s_GetInputHandler();
         if(_loc2_ != null)
         {
            _loc2_.captureKeyboard = true;
         }
      }
      
      private function onClose(param1:CloseEvent) : void
      {
         if(!param1.cancelable || !param1.isDefaultPrevented())
         {
            this.hide(param1.currentTarget as PopUpBase);
         }
      }
      
      private function showInternal(param1:PopUpBase) : void
      {
         if(ContextMenuBase.getCurrent() != null)
         {
            ContextMenuBase.getCurrent().hide();
         }
         var _loc2_:InputHandler = Tibia.s_GetInputHandler();
         if(_loc2_ != null)
         {
            _loc2_.captureKeyboard = false;
         }
         PopUpManager.addPopUp(param1,Tibia.s_GetInstance(),true);
         PopUpManager.centerPopUp(param1);
      }
      
      public function show(param1:PopUpBase) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("PopUpQueue.show: Invalid pop-up.");
         }
         this.hideByPriority(param1.priority);
         this.m_Queue.push(param1);
         if(this.m_Queue.length == 1)
         {
            this.showInternal(this.m_Queue[0]);
         }
         param1.addEventListener(CloseEvent.CLOSE,this.onClose);
      }
      
      public function hideByPriority(param1:int) : void
      {
         var _loc2_:int = this.m_Queue.length - 1;
         while(_loc2_ >= 0 && this.m_Queue[_loc2_].priority <= param1)
         {
            this.m_Queue[_loc2_].removeEventListener(CloseEvent.CLOSE,this.onClose);
            if(_loc2_ == 0)
            {
               this.m_Queue[_loc2_].hide();
            }
            _loc2_--;
         }
         this.m_Queue.length = _loc2_ + 1;
      }
      
      public function contains(param1:PopUpBase) : Boolean
      {
         var _loc2_:int = this.m_Queue.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_Queue[_loc2_] == param1)
            {
               return true;
            }
            _loc2_--;
         }
         return false;
      }
   }
}
