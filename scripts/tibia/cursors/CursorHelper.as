package tibia.cursors
{
   import mx.managers.CursorManager;
   
   public class CursorHelper
   {
       
      
      private var m_CursorID:int = 0;
      
      private var m_CursorClassPending:Class = null;
      
      private var m_DefaultPriority:int = 2;
      
      private var m_RegisteredCursorClass:Class = null;
      
      public function CursorHelper(param1:int = 3.0)
      {
         super();
         this.m_DefaultPriority = param1;
      }
      
      public function resetCursor() : void
      {
         this.setCursor(null);
      }
      
      public function setCursor(param1:Class) : void
      {
         if(param1 != this.m_RegisteredCursorClass)
         {
            if(param1 == null)
            {
               this.registerCursor(false);
            }
            else
            {
               this.m_CursorClassPending = param1;
               this.registerCursor(true);
            }
         }
      }
      
      private function registerCursor(param1:Boolean) : void
      {
         if(this.m_CursorID != 0 && param1)
         {
            this.registerCursor(false);
         }
         if(this.m_CursorID != 0 && this.m_CursorClassPending == this.m_RegisteredCursorClass)
         {
            this.m_CursorClassPending = null;
            return;
         }
         if(param1 && this.m_CursorID == 0 && this.m_CursorClassPending != null)
         {
            this.m_CursorID = CursorManager.getInstance().setCursor(this.m_CursorClassPending,this.m_DefaultPriority);
            this.m_RegisteredCursorClass = this.m_CursorClassPending;
            this.m_CursorClassPending = null;
         }
         else if(!param1 && this.m_CursorID != 0)
         {
            CursorManager.getInstance().removeCursor(this.m_CursorID);
            this.m_RegisteredCursorClass = null;
            this.m_CursorID = 0;
         }
      }
   }
}
