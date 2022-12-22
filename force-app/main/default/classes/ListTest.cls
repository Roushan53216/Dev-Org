public class ListTest {
    
    public static void helloList(){
        List<String> striingList = new List<String>{'a','b','c'};
            for(String str : striingList){
                System.debug(str);
            }
    }

}