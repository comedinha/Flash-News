package mx.controls.dataGridClasses
{
   import mx.controls.listClasses.ListBaseContentHolder;
   import mx.controls.listClasses.ListBase;
   
   public class DataGridLockedRowContentHolder extends ListBaseContentHolder
   {
       
      
      public function DataGridLockedRowContentHolder(param1:ListBase)
      {
         super(param1);
         if(param1.dataProvider)
         {
            iterator = param1.dataProvider.createCursor();
         }
      }
      
      override public function get measuredHeight() : Number
      {
         var _loc1_:Number = rowInfo.length;
         if(_loc1_ == 0)
         {
            return 0;
         }
         return rowInfo[_loc1_ - 1].y + rowInfo[_loc1_ - 1].height;
      }
   }
}
