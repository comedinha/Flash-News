package tibia.chat.chatWidgetClasses
{
   public interface ISelectionProxy
   {
       
      
      function getCharCount() : int;
      
      function selectAll() : void;
      
      function getCharIndexAtPoint(param1:Number, param2:Number) : int;
      
      function setSelection(param1:int, param2:int) : void;
      
      function getLabel() : String;
      
      function clearSelection() : void;
   }
}
