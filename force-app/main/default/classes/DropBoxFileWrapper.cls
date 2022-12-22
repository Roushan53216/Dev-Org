public class DropBoxFileWrapper {
    
    public cls_entries[] entries;
	public String cursor;
	public boolean has_more;
	public class cls_entries {
		public String tag;	
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