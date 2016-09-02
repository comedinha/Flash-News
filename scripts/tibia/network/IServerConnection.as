package tibia.network
{
   import flash.events.IEventDispatcher;
   
   public interface IServerConnection extends IEventDispatcher
   {
       
      
      function get messageReader() : IMessageReader;
      
      function get isGameRunning() : Boolean;
      
      function get connectionData() : IConnectionData;
      
      function connect(param1:IConnectionData) : void;
      
      function set communication(param1:IServerCommunication) : void;
      
      function get isPending() : Boolean;
      
      function setConnectionState(param1:uint, param2:Boolean = true) : void;
      
      function get connectionState() : uint;
      
      function get communication() : IServerCommunication;
      
      function readCommunicationData() : void;
      
      function get messageWriter() : IMessageWriter;
      
      function disconnect(param1:Boolean = true) : void;
      
      function get latency() : uint;
      
      function get isConnected() : Boolean;
   }
}
