package tibia.input.staticaction
{
   import tibia.input.IAction;
   import tibia.input.InputEvent;
   import mx.resources.ResourceManager;
   import mx.resources.IResourceManager;
   
   public class StaticAction implements IAction
   {
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      protected static const BUNDLE:String = "StaticAction";
      
      protected static const s_Action:Vector.<tibia.input.staticaction.StaticAction> = new Vector.<tibia.input.staticaction.StaticAction>();
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_Label:String = null;
      
      protected var m_ID:int = 0;
      
      protected var m_EventMask:uint = 0;
      
      protected var m_Hidden:Boolean = true;
      
      public function StaticAction(param1:int, param2:String = null, param3:uint = 0, param4:Boolean = false)
      {
         super();
         if(param1 < 0 || param1 > 65535)
         {
            throw new ArgumentError("StaticAction.StaticAction: ID out of range: " + param1);
         }
         this.m_ID = param1;
         this.m_Label = param2;
         this.m_EventMask = param3;
         this.m_Hidden = param4;
         tibia.input.staticaction.StaticAction.s_RegisterAction(this);
      }
      
      public static function s_GetAction(param1:int) : tibia.input.staticaction.StaticAction
      {
         var _loc2_:int = s_Action.length - 1;
         while(_loc2_ >= 0)
         {
            if(s_Action[_loc2_].ID == param1)
            {
               return s_Action[_loc2_];
            }
            _loc2_--;
         }
         return null;
      }
      
      public static function s_RegisterAction(param1:tibia.input.staticaction.StaticAction) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("StaticActionList.s_RegisterAction: Invalid action.");
         }
         if(s_GetAction(param1.ID) != null)
         {
            throw new ArgumentError("StaticActionList.s_RegsiterAction: Action " + param1.ID + " is not unique.");
         }
         s_Action.push(param1);
      }
      
      public static function s_GetAllActions() : Vector.<tibia.input.staticaction.StaticAction>
      {
         return s_Action.slice();
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : IAction
      {
         var _loc4_:int = 0;
         if(param1 == null || param1.localName() != "action" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("StaticAction.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@type) == null || _loc3_.length() != 1 || _loc3_[0].toString() != "static")
         {
            return null;
         }
         if((_loc3_ = param1.@object) != null && _loc3_.length() == 1)
         {
            _loc4_ = parseInt(_loc3_[0].toString());
            return tibia.input.staticaction.StaticAction.s_GetAction(_loc4_);
         }
         return null;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         throw new Error("StaticAction.perform: Needs to be implemented by a subclass.");
      }
      
      public function get eventMask() : uint
      {
         return this.m_EventMask;
      }
      
      public function get hidden() : Boolean
      {
         return this.m_Hidden;
      }
      
      function keyCallback(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:Boolean) : void
      {
         this.perform(param1 == InputEvent.KEY_REPEAT);
      }
      
      public function marshall() : XML
      {
         return <action type="static" object="{this.m_ID}"/>;
      }
      
      function textCallback(param1:uint, param2:String) : void
      {
         this.perform(false);
      }
      
      public function toString() : String
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:String = null;
         if(this.m_Label != null)
         {
            _loc2_ = _loc1_.getString(BUNDLE,this.m_Label);
         }
         else
         {
            _loc2_ = _loc1_.getString(BUNDLE,"UNKNOWN_ACTION");
         }
         if(_loc2_ == null || _loc2_.length < 1)
         {
            _loc2_ = this.m_Label;
         }
         return _loc2_;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function clone() : IAction
      {
         return this;
      }
      
      public function equals(param1:IAction) : Boolean
      {
         return param1 === this;
      }
   }
}
