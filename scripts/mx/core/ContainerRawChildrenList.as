package mx.core
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   use namespace mx_internal;
   
   public class ContainerRawChildrenList implements IChildList
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var owner:Container;
      
      public function ContainerRawChildrenList(param1:Container)
      {
         super();
         this.owner = param1;
      }
      
      public function addChild(param1:DisplayObject) : DisplayObject
      {
         return owner.rawChildren_addChild(param1);
      }
      
      public function getChildIndex(param1:DisplayObject) : int
      {
         return owner.rawChildren_getChildIndex(param1);
      }
      
      public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         owner.rawChildren_setChildIndex(param1,param2);
      }
      
      public function getChildByName(param1:String) : DisplayObject
      {
         return owner.rawChildren_getChildByName(param1);
      }
      
      public function removeChildAt(param1:int) : DisplayObject
      {
         return owner.rawChildren_removeChildAt(param1);
      }
      
      public function get numChildren() : int
      {
         return owner.$numChildren;
      }
      
      public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         return owner.rawChildren_addChildAt(param1,param2);
      }
      
      public function getObjectsUnderPoint(param1:Point) : Array
      {
         return owner.rawChildren_getObjectsUnderPoint(param1);
      }
      
      public function contains(param1:DisplayObject) : Boolean
      {
         return owner.rawChildren_contains(param1);
      }
      
      public function removeChild(param1:DisplayObject) : DisplayObject
      {
         return owner.rawChildren_removeChild(param1);
      }
      
      public function getChildAt(param1:int) : DisplayObject
      {
         return owner.rawChildren_getChildAt(param1);
      }
   }
}
