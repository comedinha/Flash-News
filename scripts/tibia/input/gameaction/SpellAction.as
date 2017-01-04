package tibia.input.gameaction
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import tibia.creatures.Player;
   import tibia.game.Delay;
   import tibia.input.IAction;
   import tibia.magic.Spell;
   import tibia.magic.SpellStorage;
   import tibia.network.IServerConnection;
   
   public class SpellAction implements IAction
   {
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      private static const BUNDLE:String = "StaticAction";
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      private var m_Spell:Spell = null;
      
      private var m_Parameter:String = null;
      
      private var m_LastPerform:Number = 0;
      
      public function SpellAction(param1:*, param2:String)
      {
         super();
         this.m_Spell = null;
         if(param1 is Spell)
         {
            this.m_Spell = Spell(param1);
         }
         else if(param1 is int)
         {
            this.m_Spell = SpellStorage.getSpell(int(param1));
         }
         if(this.m_Spell == null)
         {
            throw new ArgumentError("SpellAction.SpellAction: Invalid spell: " + param1);
         }
         this.m_Parameter = param2;
         if(this.m_Parameter != null)
         {
            this.m_Parameter = this.m_Parameter.replace(/(^\s+|\s+$)/,"");
         }
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : SpellAction
      {
         if(param1 == null || param1.localName() != "action" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("SpellAction.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@type) == null || _loc3_.length() != 1 || _loc3_[0].toString() != "spell")
         {
            return null;
         }
         var _loc4_:int = -1;
         if((_loc3_ = param1.@spell) != null && _loc3_.length() == 1)
         {
            _loc4_ = parseInt(_loc3_[0].toString());
         }
         var _loc5_:String = null;
         if((_loc3_ = param1.@parameter) != null && _loc3_.length() == 1)
         {
            _loc5_ = _loc3_[0].toString();
         }
         else if((_loc3_ = param1.text()) != null && _loc3_.length() == 1)
         {
            _loc5_ = _loc3_[0].toString();
         }
         if(SpellStorage.checkSpell(_loc4_))
         {
            return new SpellAction(_loc4_,_loc5_);
         }
         return null;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc5_:Delay = null;
         var _loc2_:Player = Tibia.s_GetPlayer();
         if(_loc2_ == null || _loc2_.getSpellCasts(this.m_Spell) < 0)
         {
            return;
         }
         var _loc3_:IServerConnection = Tibia.s_GetConnection();
         var _loc4_:SpellStorage = Tibia.s_GetSpellStorage();
         if(param1 && _loc3_ != null && _loc4_ != null)
         {
            if(this.m_LastPerform + SpellStorage.MIN_SPELL_DELAY / 2 > Tibia.s_FrameTibiaTimestamp)
            {
               return;
            }
            _loc5_ = _loc4_.getSpellDelay(this.m_Spell.ID);
            if(_loc5_ != null && _loc5_.end - _loc3_.latency > Tibia.s_FrameTibiaTimestamp)
            {
               return;
            }
         }
         this.m_Spell.cast(null,this.m_Parameter);
         this.m_LastPerform = Tibia.s_FrameTibiaTimestamp;
      }
      
      public function clone() : IAction
      {
         return new SpellAction(this.m_Spell,this.m_Parameter);
      }
      
      public function equals(param1:IAction) : Boolean
      {
         return param1 is SpellAction && SpellAction(param1).m_Spell == this.m_Spell && SpellAction(param1).m_Parameter == this.m_Parameter;
      }
      
      public function get spell() : Spell
      {
         return this.m_Spell;
      }
      
      public function get parameter() : String
      {
         return this.m_Parameter;
      }
      
      public function get hidden() : Boolean
      {
         return true;
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = <action type="spell" spell="{this.m_Spell.ID}"/>;
         if(this.m_Parameter != null && this.m_Parameter.length > 0)
         {
            _loc1_.@parameter = this.m_Parameter;
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         return _loc1_.getString(BUNDLE,"GAME_SPELL",[this.m_Spell.name]);
      }
   }
}
