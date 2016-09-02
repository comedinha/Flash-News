package tibia.input
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import mx.controls.TextArea;
   import mx.controls.TextInput;
   import shared.utility.StringHelper;
   
   public function PreventWhitespaceInput(param1:Event) : void
   {
      var _loc2_:String = null;
      var _loc3_:int = 0;
      var _loc4_:int = 0;
      if(param1 != null)
      {
         _loc2_ = null;
         if(param1 is KeyboardEvent)
         {
            _loc4_ = KeyboardEvent(param1).charCode;
            if(_loc4_ == 0)
            {
               _loc4_ = KeyboardEvent(param1).keyCode;
            }
            if(_loc4_ != 0)
            {
               _loc2_ = String.fromCharCode(_loc4_);
            }
         }
         else if(param1 is TextEvent)
         {
            _loc2_ = TextEvent(param1).text;
         }
         _loc3_ = -1;
         if(param1.currentTarget is TextArea)
         {
            _loc3_ = TextArea(param1.currentTarget).selectionBeginIndex;
         }
         else if(param1.currentTarget is TextInput)
         {
            _loc3_ = TextInput(param1.currentTarget).selectionBeginIndex;
         }
         if(_loc3_ == 0 && (_loc2_ == null || _loc2_.length < 1 || StringHelper.s_IsWhitsepace(_loc2_)))
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
         }
      }
   }
}
