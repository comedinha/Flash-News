package mx.core
{
   import flash.utils.getQualifiedClassName;
   
   use namespace mx_internal;
   
   public class ContextualClassFactory extends ClassFactory
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var moduleFactory:IFlexModuleFactory;
      
      public function ContextualClassFactory(param1:Class = null, param2:IFlexModuleFactory = null)
      {
         super(param1);
         this.moduleFactory = param2;
      }
      
      override public function newInstance() : *
      {
         var _loc2_:* = null;
         var _loc1_:Object = null;
         if(moduleFactory)
         {
            _loc1_ = moduleFactory.create(getQualifiedClassName(generator));
         }
         if(!_loc1_)
         {
            _loc1_ = super.newInstance();
         }
         if(properties)
         {
            for(_loc2_ in properties)
            {
               _loc1_[_loc2_] = properties[_loc2_];
            }
         }
         return _loc1_;
      }
   }
}
