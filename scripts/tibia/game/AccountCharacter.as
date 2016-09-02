package tibia.game
{
   import tibia.network.IConnectionData;
   
   public class AccountCharacter implements IConnectionData
   {
      
      public static const CLIENT_VERSION:uint = 2309;
      
      public static const CLIENT_PREVIEW_STATE:uint = 0;
      
      public static const PREVIEW_STATE_PREVIEW_NO_ACTIVE_CHANGE:uint = 1;
      
      public static const PREVIEW_STATE_PREVIEW_WITH_ACTIVE_CHANGE:uint = 2;
      
      public static const CLIENT_TYPE:uint = 3;
      
      public static const PREVIEW_STATE_REGULAR:uint = 0;
       
      
      private var m_World:String = null;
      
      private var m_Address:String = null;
      
      private var m_WorldPreviewState:uint = 0;
      
      private var m_Port:int = 0;
      
      private var m_SessionKey:String = null;
      
      private var m_Name:String = null;
      
      public function AccountCharacter(param1:String, param2:String, param3:String, param4:String, param5:int, param6:uint)
      {
         super();
         this.m_SessionKey = param1;
         this.m_Name = param2;
         this.m_World = param3;
         this.m_Address = param4;
         this.m_Port = param5;
         this.m_WorldPreviewState = param6;
      }
      
      public function get port() : int
      {
         return this.m_Port;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get worldPreviewState() : uint
      {
         return this.m_WorldPreviewState;
      }
      
      public function get sessionKey() : String
      {
         return this.m_SessionKey;
      }
      
      public function get address() : String
      {
         return this.m_Address;
      }
      
      public function get world() : String
      {
         return this.m_World;
      }
   }
}
