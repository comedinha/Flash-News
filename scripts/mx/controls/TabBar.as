package mx.controls
{
   import mx.core.mx_internal;
   import flash.events.MouseEvent;
   import flash.display.DisplayObject;
   import mx.core.IFlexDisplayObject;
   import mx.core.ClassFactory;
   import mx.controls.tabBarClasses.Tab;
   
   use namespace mx_internal;
   
   public class TabBar extends ToggleButtonBar
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      mx_internal static var createAccessibilityImplementation:Function;
       
      
      public function TabBar()
      {
         super();
         buttonHeightProp = "tabHeight";
         buttonStyleNameProp = "tabStyleName";
         firstButtonStyleNameProp = "firstTabStyleName";
         lastButtonStyleNameProp = "lastTabStyleName";
         buttonWidthProp = "tabWidth";
         navItemFactory = new ClassFactory(Tab);
         selectedButtonTextStyleNameProp = "selectedTabTextStyleName";
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         if(getChildIndex(DisplayObject(param1.currentTarget)) == selectedIndex)
         {
            Button(param1.currentTarget).selected = true;
            param1.stopImmediatePropagation();
            return;
         }
         super.clickHandler(param1);
      }
      
      override protected function createNavItem(param1:String, param2:Class = null) : IFlexDisplayObject
      {
         var _loc3_:IFlexDisplayObject = super.createNavItem(param1,param2);
         DisplayObject(_loc3_).addEventListener(MouseEvent.MOUSE_DOWN,tab_mouseDownHandler);
         DisplayObject(_loc3_).addEventListener(MouseEvent.DOUBLE_CLICK,tab_doubleClickHandler);
         return _loc3_;
      }
      
      private function tab_doubleClickHandler(param1:MouseEvent) : void
      {
         Button(param1.currentTarget).selected = true;
      }
      
      private function tab_mouseDownHandler(param1:MouseEvent) : void
      {
         selectButton(param1.currentTarget.parent.getChildIndex(param1.currentTarget),true,param1);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(TabBar.createAccessibilityImplementation != null)
         {
            TabBar.createAccessibilityImplementation(this);
         }
      }
   }
}
