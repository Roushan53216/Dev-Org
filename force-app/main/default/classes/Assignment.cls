public class Assignment {
    
    public static void doAssignment(String n,String m){
        List<String> contactFirst = n.split(',');
        List<String> contactSecond = m.split(',');
        System.debug('>>>First '+contactFirst);
        System.debug('>>>Second '+contactSecond);
        Set<String> commonList = new  Set<String>();
        commonList.addAll(contactFirst);
        commonList.addAll(contactSecond);
        System.debug('>>>> '+commonList);
        
        
        
    }

}