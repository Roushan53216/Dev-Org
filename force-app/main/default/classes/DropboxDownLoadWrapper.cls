public class DropboxDownLoadWrapper {
    public cls_metadata metadata;
    public String link;	
    class cls_metadata {
        public String name;	
        public String path_lower;	
        public String path_display;	
        public String id;	
        public String client_modified;	
        public String server_modified;	
        public String rev;	
        public Integer size;	
        public boolean is_downloadable;
        public String content_hash;
    }
}