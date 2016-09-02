package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.SetPropertyActionInstance;
   
   use namespace mx_internal;
   
   public class SetPropertyAction extends Effect
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var value;
      
      public var name:String;
      
      public function SetPropertyAction(param1:Object = null)
      {
         super(param1);
         instanceClass = SetPropertyActionInstance;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         super.initInstance(param1);
         var _loc2_:SetPropertyActionInstance = SetPropertyActionInstance(param1);
         _loc2_.name = name;
         _loc2_.value = value;
      }
      
      override public function getAffectedProperties() : Array
      {
         return [name];
      }
   }
}
