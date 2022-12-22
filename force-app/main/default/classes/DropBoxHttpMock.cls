global class DropBoxHttpMock {
    global HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //res.setBody('{"Animals":["Horse","Dog","Tiger","Lion","Cat","Mouse"]}');
        res.setStatusCode(200);
        return res;
    }
    	
}