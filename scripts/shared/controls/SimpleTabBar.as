package shared.controls
{
   import mx.controls.TabBar;
   import mx.core.mx_internal;
   import mx.core.ClassFactory;
   
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
