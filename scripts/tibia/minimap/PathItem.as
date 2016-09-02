package tibia.minimap
{
   import shared.utility.HeapItem;
   
   class PathItem extends HeapItem
   {
       
      
      public var y:int = 0;
      
      public var pathHeuristic:int = 2.147483647E9;
      
      public var predecessor:tibia.minimap.PathItem = null;
      
      public var cost:int = 2.147483647E9;
      
      public var distance:int = 2.147483647E9;
      
      public var x:int = 0;
      
      public var pathCost:int = 2.147483647E9;
      
      function PathItem(param1:int, param2:int)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.distance = Math.abs(param1) + Math.abs(param2);
      }
   }
}
