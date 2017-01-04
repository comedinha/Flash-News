package mx.binding
{
   import mx.core.mx_internal;
   import mx.rpc.IResponder;
   
   use namespace mx_internal;
   
   public class EvalBindingResponder implements IResponder
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var binding:Binding;
      
      private var object:Object;
      
      public function EvalBindingResponder(param1:Binding, param2:Object)
      {
         super();
         this.binding = param1;
         this.object = param2;
      }
      
      public function fault(param1:Object) : void
      {
      }
      
      public function result(param1:Object) : void
      {
         binding.execute(object);
      }
   }
}
