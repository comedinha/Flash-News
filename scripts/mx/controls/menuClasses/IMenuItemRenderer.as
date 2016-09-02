package mx.controls.menuClasses
{
   import mx.controls.Menu;
   
   public interface IMenuItemRenderer
   {
       
      
      function get measuredBranchIconWidth() : Number;
      
      function get measuredIconWidth() : Number;
      
      function get measuredTypeIconWidth() : Number;
      
      function set menu(param1:Menu) : void;
      
      function get menu() : Menu;
   }
}
