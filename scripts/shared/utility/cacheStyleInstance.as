package shared.utility
{
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public function cacheStyleInstance(param1:*, param2:String, param3:String = "styleProp", param4:String = "styleInstance") : void
   {
      var Item:Object = null;
      var Temp:* = undefined;
      var a_List:* = param1;
      var a_Selector:String = param2;
      var a_StyleProp:String = param3;
      var a_StyleInstance:String = param4;
      var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(a_Selector);
      for each(Item in a_List)
      {
         Temp = null;
         if(Decl != null && Item.hasOwnProperty(a_StyleProp) && Item[a_StyleProp] != null)
         {
            Temp = Decl.getStyle(Item[a_StyleProp]);
         }
         try
         {
            if(Temp is Class)
            {
               Temp = new Class(Temp)();
            }
            Item[a_StyleInstance] = Temp;
         }
         catch(e:Error)
         {
            continue;
         }
      }
   }
}
