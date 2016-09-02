package shared.controls
{
   import mx.containers.TabNavigator;
   import mx.core.mx_internal;
   import mx.core.ClassFactory;
   
   public class SimpleTabNavigator extends TabNavigator
   {
       
      
      public function SimpleTabNavigator()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         tabBar.mx_internal::navItemFactory = new ClassFactory(SimpleTab);
      }
   }
}
