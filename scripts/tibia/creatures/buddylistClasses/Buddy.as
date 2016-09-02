package tibia.creatures.buddylistClasses
{
   import flash.events.EventDispatcher;
   import tibia.reporting.IReportable;
   import mx.events.PropertyChangeEvent;
   import tibia.reporting.reportType.Type;
   import shared.utility.StringHelper;
   
   public class Buddy extends EventDispatcher implements IReportable
   {
      
      public static const STATUS_ONLINE:uint = 1;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const STATUS_PENDING:uint = 2;
      
      public static const NUM_BUDDIES:int = int.MAX_VALUE;
      
      private static const LOGIN_HIGHLIGHT_TIME:Number = 1000;
      
      public static const STATUS_OFFLINE:uint = 0;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_Description:String = null;
      
      protected var m_Status:uint = 0;
      
      protected var m_Icon:int = 0;
      
      protected var m_ID:int = 0;
      
      protected var m_LastUpdate:Number = NaN;
      
      protected var m_Notify:Boolean = false;
      
      protected var m_Name:String = null;
      
      public function Buddy(param1:int, param2:String)
      {
         super();
         this.m_ID = param1;
         this.m_Name = param2;
      }
      
      [Bindable(event="propertyChange")]
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this.name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set lastUpdate(param1:Number) : void
      {
         var _loc2_:Object = this.lastUpdate;
         if(_loc2_ !== param1)
         {
            this._1992879871lastUpdate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastUpdate",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set status(param1:uint) : void
      {
         var _loc2_:Object = this.status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
         }
      }
      
      public function get notify() : Boolean
      {
         return this.m_Notify;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      private function set _892481550status(param1:uint) : void
      {
         if(param1 != STATUS_ONLINE && param1 != STATUS_OFFLINE && param1 != STATUS_PENDING)
         {
            throw new ArgumentError("Buddy.state: Invalid buddy state");
         }
         this.m_Status = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this.description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set notify(param1:Boolean) : void
      {
         var _loc2_:Object = this.notify;
         if(_loc2_ !== param1)
         {
            this._1039689911notify = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"notify",_loc2_,param1));
         }
      }
      
      public function get characterName() : String
      {
         return this.m_Name;
      }
      
      private function set _3373707name(param1:String) : void
      {
         this.m_Name = param1;
      }
      
      public function clone() : Buddy
      {
         var _loc1_:Buddy = new Buddy(this.m_ID,this.m_Name);
         _loc1_.description = this.m_Description;
         _loc1_.icon = this.m_Icon;
         _loc1_.lastUpdate = this.m_LastUpdate;
         _loc1_.notify = this.m_Notify;
         _loc1_.status = this.m_Status;
         return _loc1_;
      }
      
      private function set _3226745icon(param1:int) : void
      {
         this.m_Icon = Math.max(0,Math.min(param1,BuddyIcon.NUM_ICONS - 1));
      }
      
      [Bindable(event="propertyChange")]
      public function set icon(param1:int) : void
      {
         var _loc2_:Object = this.icon;
         if(_loc2_ !== param1)
         {
            this._3226745icon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon",_loc2_,param1));
         }
      }
      
      private function set _1039689911notify(param1:Boolean) : void
      {
         this.m_Notify = param1;
      }
      
      private function set _1992879871lastUpdate(param1:Number) : void
      {
         this.m_LastUpdate = param1;
      }
      
      public function isReportTypeAllowed(param1:uint) : Boolean
      {
         return param1 == Type.REPORT_NAME;
      }
      
      public function get status() : uint
      {
         return this.m_Status;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function get highlight() : Boolean
      {
         return this.m_Status == STATUS_ONLINE && this.m_LastUpdate > Tibia.s_FrameTibiaTimestamp - LOGIN_HIGHLIGHT_TIME;
      }
      
      public function setReportTypeAllowed(param1:uint, param2:Boolean = true) : void
      {
      }
      
      public function get icon() : int
      {
         return this.m_Icon;
      }
      
      public function get description() : String
      {
         return this.m_Description;
      }
      
      private function set _1724546052description(param1:String) : void
      {
         this.m_Description = StringHelper.s_Trim(param1);
      }
      
      public function get lastUpdate() : Number
      {
         return this.m_LastUpdate;
      }
   }
}
