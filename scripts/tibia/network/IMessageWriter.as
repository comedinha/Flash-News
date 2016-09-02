package tibia.network
{
   import flash.utils.ByteArray;
   
   public interface IMessageWriter
   {
       
      
      function get outputPacketBuffer() : ByteArray;
      
      function createMessage() : ByteArray;
      
      function finishMessage() : void;
   }
}
