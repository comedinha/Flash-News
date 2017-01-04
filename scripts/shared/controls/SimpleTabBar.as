package shared.controls
{
   import mx.controls.TabBar;
   import mx.core.ClassFactory;
   import mx.core.mx_internal;
   
   public class SimpleTabBar extends TabBar
   {
       
      
      public function SimpleTabBar()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         mx_internal::navItemFactory = new ClassFactory(SimpleTab);
      }
   }
}
