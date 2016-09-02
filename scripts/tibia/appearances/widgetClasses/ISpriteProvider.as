package tibia.appearances.widgetClasses
{
   import tibia.appearances.AppearanceType;
   
   public interface ISpriteProvider
   {
       
      
      function getSprite(param1:uint, param2:CachedSpriteInformation = null, param3:AppearanceType = null) : CachedSpriteInformation;
   }
}
