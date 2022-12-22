public class JSONFolderWrapper {
    public String kind;
    public String etag;	
    public String selfLink;	
    public cls_items[] items;
    public class cls_items {
        public String id;	
        public String selfLink;	
        public String kind;	
        public String childLink;	
    }
}