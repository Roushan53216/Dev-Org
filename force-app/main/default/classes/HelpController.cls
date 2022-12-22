public class HelpController {
    public Integer val{get;set;}
    private Integer see;
    public HelpController(){
        System.debug('&&&'+val);
    }
    Public PageReference chl(){
        see = val + val;
        System.debug('^^^'+val);
        return null;
    }
}