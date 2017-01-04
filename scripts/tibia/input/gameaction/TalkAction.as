package tibia.input.gameaction
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import tibia.input.IAction;
   
   public class TalkAction extends TalkActionImpl implements IAction
   {
      
      private static const BUNDLE:String = "StaticAction";
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      private static const MIN_TALK_DELAY:int = 2500;
       
      
      private var m_PerformTimestamp:Number = 0;
      
      public function TalkAction(param1:String, param2:Boolean)
      {
         super(param1,param2,TalkActionImpl.CURRENT_CHANNEL_ID);
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : TalkAction
      {
         if(param1 == null || param1.localName() != "action" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("TalkAction.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@type) == null || _loc3_.length() != 1 || _loc3_[0].toString() != "talk")
         {
            return null;
         }
         var _loc4_:* = false;
         if((_loc3_ = param1.@autoSend) != null && _loc3_.length() == 1)
         {
            _loc4_ = _loc3_[0].toString() == "true";
         }
         var _loc5_:String = null;
         if((_loc3_ = param1.@text) != null && _loc3_.length() == 1)
         {
            _loc5_ = _loc3_[0].toString();
         }
         else if((_loc3_ = param1.text()) != null && _loc3_.length() == 1)
         {
            _loc5_ = _loc3_[0].toString();
         }
         if(_loc5_ != null && _loc5_.length > 0)
         {
            return new TalkAction(_loc5_,_loc4_);
         }
         return null;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         if(param1 && m_AutoSend && this.m_PerformTimestamp + MIN_TALK_DELAY > Tibia.s_FrameTibiaTimestamp)
         {
            return;
         }
         super.perform(param1);
         this.m_PerformTimestamp = Tibia.s_FrameTibiaTimestamp;
      }
      
      public function get text() : String
      {
         return m_Text;
      }
      
      public function marshall() : XML
      {
         return <action type="talk" autoSend="{m_AutoSend}" text="{m_Text}"/>;
      }
      
      public function get hidden() : Boolean
      {
         return true;
      }
      
      public function get autoSend() : Boolean
      {
         return m_AutoSend;
      }
      
      public function toString() : String
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         return _loc1_.getString(BUNDLE,"GAME_TALK",[m_Text]);
      }
      
      public function clone() : IAction
      {
         return new TalkAction(m_Text,m_AutoSend);
      }
      
      public function equals(param1:IAction) : Boolean
      {
         return param1 is TalkAction && TalkAction(param1).m_AutoSend == m_AutoSend && TalkAction(param1).m_Text == m_Text;
      }
   }
}
