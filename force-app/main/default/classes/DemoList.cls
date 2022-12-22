public class DemoList {
    public static void checkList(){
        List<String> colorList = new  List<String>();
        colorList.add('Green');
        colorList.add('Red');
        colorList.add('Yellow');
        colorList.add('Purple');
        Integer listSize = colorList.size();
        System.debug('Size of the List '+listSize);
        String colorIndexVlaue = colorList.get(1);
        System.debug('Color at index 0 : '+colorIndexVlaue);
        Integer index = 0;
        for(String coloritt: colorList){
            coloritt = colorList.get(index);
            System.debug(coloritt+'ia at index '+index);
            index++;
        }
        List<String> mergeList = new List<String>();
        mergeList.add('Sky Blue');
        mergeList.add('Brown');
        for(String temp :mergeList){
            System.debug(temp);
        }
        colorList.addAll(mergeList);
        for(String mergedList : colorList){
            System.debug(mergedList);
        }
    }

    /*

    This is being commited from Github Branch Hello branch......
    hy
    hy
    yh
    yh
    yh
    hy
    yh
    yh
    yhyh

    yh
     */

}