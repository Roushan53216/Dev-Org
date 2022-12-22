public class MapDemo {
    
    public static void mapTest(){
        Map<String,String> colorMap = new Map<String,String>();
        colorMap.put('Key1','Red');
        colorMap.put('Key2','Green');
        colorMap.put('Key3','Yellow');
        colorMap.put('Key4','Black');
        colorMap.put('Key5','White');
        
        System.debug(colorMap);
        
        Set<String> colorKeySet = colorMap.keySet();
        System.debug('Colors to key '+colorKeySet);
        List<String> colorList = colorMap.values();
        System.debug('Colors into the List '+colorList);
        colorMap.put('Key3','Blue');
        System.debug(colorMap);
        System.debug(colorMap.containsKey('Key3'));
        System.debug(colorMap.size());
        Map<String,String> colorCloneMap = colorMap.clone();
        System.debug('Cloned Map '+colorCloneMap);
        
        Map<Integer,String> colorDiffrentMAp = new Map<Integer,String>();
        colorDiffrentMAp.put(1,'Hara');
        colorDiffrentMAp.put(2,'Green');
        colorDiffrentMAp.put(3,'Yellow');
        colorDiffrentMAp.put(4,'Black');
        colorDiffrentMAp.put(5,'White');
        System.debug(colorDiffrentMAp.get(4));
        for(String mapString:colorDiffrentMAp.values()){
            System.debug(mapString);
        }
        
    }

}