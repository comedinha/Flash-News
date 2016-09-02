package tibia.chat.chatWidgetClasses
{
   import mx.controls.Label;
   
   public class NicklistItemRenderer extends Label
   {
      
      public static const HEIGHT_HINT:Number = 18;
       
      
      private var m_UncommittedData:Boolean = false;
      
      public function NicklistItemRenderer()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.m_UncommittedData = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:NicklistItem = null;
         super.commitProperties();
         if(this.m_UncommittedData)
         {
            if(data != null && data is NicklistItem)
            {
               _loc1_ = data as NicklistItem;
               text = _loc1_.name;
               if(_loc1_.state == NicklistItem.STATE_SUBSCRIBER)
               {
                  setStyle("color",getStyle("subscriberTextColor"));
               }
               else if(_loc1_.state == NicklistItem.STATE_INVITED)
               {
                  setStyle("color",getStyle("inviteeTextColor"));
               }
               else if(_loc1_.state == NicklistItem.STATE_PENDING)
               {
                  setStyle("color",getStyle("pendingTextColor"));
               }
            }
            else
            {
               text = null;
               setStyle("color",0);
            }
            this.m_UncommittedData = false;
         }
      }
   }
}
