package tibia.chat
{
   import tibia.reporting.IReportable;
   import shared.utility.i18n.i18nFormatTime;
   import shared.utility.StringHelper;
   
   public class ChannelMessage implements IReportable
   {
      
      private static var s_NextID:int = 0;
       
      
      protected var m_RawText:String = null;
      
      protected var m_Speaker:String = null;
      
      protected var m_AllowedReportTypes:uint = 0;
      
      protected var m_HTMLText:String = null;
      
      protected var m_Mode:int;
      
      protected var m_Timestamp:Number = NaN;
      
      protected var m_PlainText:String = null;
      
      protected var m_ID:int = 0;
      
      protected var m_SpeakerLevel:int = 0;
      
      public function ChannelMessage(param1:int, param2:String, param3:int, param4:int, param5:String)
      {
         this.m_Mode = MessageMode.MESSAGE_NONE;
         super();
         if(param1 <= 0)
         {
            this.m_ID = --s_NextID;
         }
         else
         {
            this.m_ID = param1;
         }
         this.m_Speaker = param2;
         this.m_SpeakerLevel = param3;
         this.m_Mode = param4;
         this.m_RawText = param5;
         var _loc6_:Date = new Date();
         this.m_Timestamp = _loc6_.getTime() + _loc6_.getTimezoneOffset();
      }
      
      public function get speakerLevel() : int
      {
         return this.m_SpeakerLevel;
      }
      
      public function setReportTypeAllowed(param1:uint, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.m_AllowedReportTypes = this.m_AllowedReportTypes | 1 << param1;
         }
         else
         {
            this.m_AllowedReportTypes = this.m_AllowedReportTypes & ~(1 << param1);
         }
      }
      
      public function formatMessage(param1:Boolean, param2:Boolean, param3:uint, param4:uint) : void
      {
         var _loc5_:* = "";
         if(param1)
         {
            _loc5_ = i18nFormatTime(new Date(this.m_Timestamp));
         }
         if(this.m_Speaker != null)
         {
            _loc5_ = _loc5_ + (" " + this.m_Speaker);
            if(param2 && this.m_SpeakerLevel > 0)
            {
               _loc5_ = _loc5_ + (" [" + this.m_SpeakerLevel + "]");
            }
         }
         if(_loc5_ != null && _loc5_.length > 0)
         {
            _loc5_ = _loc5_ + ": ";
         }
         var _loc6_:String = StringHelper.s_HTMLSpecialChars(this.m_RawText);
         if(this.m_Mode == MessageMode.MESSAGE_NPC_FROM || this.m_Mode == MessageMode.MESSAGE_NPC_FROM_START_BLOCK)
         {
            _loc6_ = StringHelper.s_HilightToHTML(_loc6_,param4 & 16777215);
         }
         this.m_HTMLText = "<p><font color=\"#" + (param3 & 16777215).toString(16) + "\">" + _loc5_ + _loc6_ + "</font></p>";
         _loc6_ = this.m_RawText;
         if(this.m_Mode == MessageMode.MESSAGE_NPC_FROM || this.m_Mode == MessageMode.MESSAGE_NPC_FROM_START_BLOCK)
         {
            _loc6_ = StringHelper.s_RemoveHilight(_loc6_);
         }
         this.m_PlainText = _loc5_ + _loc6_;
      }
      
      public function get plainText() : String
      {
         return this.m_PlainText;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function get mode() : int
      {
         return this.m_Mode;
      }
      
      public function get characterName() : String
      {
         return this.m_Speaker;
      }
      
      public function isReportTypeAllowed(param1:uint) : Boolean
      {
         return (this.m_AllowedReportTypes & 1 << param1) != 0;
      }
      
      public function get htmlText() : String
      {
         return this.m_HTMLText;
      }
      
      public function get reportableText() : String
      {
         return StringHelper.s_RemoveHilight(this.m_RawText);
      }
      
      public function get speaker() : String
      {
         return this.m_Speaker;
      }
   }
}
