public class SetDemo {
    
    public SetDemo(){
        Set<String> colorSet = new Set<String>();
        colorSet.add('Green');
        colorSet.add('Red');
        colorSet.add('Black');
        colorSet.add('Yellow');
        System.debug('Colors in the set '+colorSet);
        for(String itret : colorSet){
            System.debug(itret);
        }
        System.debug(colorSet.Size());
        Set<String> tempSet = new Set<String>();
        tempSet.add('Green');
        tempSet.add('Sky Blue');
        System.debug(tempSet);
        colorSet.addAll(tempSet);
        System.debug(colorSet);
        colorSet.add('Green');
        colorSet.add('GreeN');
        System.debug(colorSet);
        
        
    }

}