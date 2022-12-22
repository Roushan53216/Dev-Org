public with sharing class RoleHeirarchyController {

    @AuraEnabled(cacheable=true)
    public static string getRoles(){
        try {
            List<UserRole> topRole = [SELECT Id, Name, ParentRoleId FROM
                                    UserRole WHERE ParentRoleId = ''];
        // Get all the roles which are present under this parent role recursively
        // This is a flat list of all the roles present in the org
        List<UserRole> allRoles = RoleUtils.getChildRoles(topRole);
        Map<Id,List<RoleInfo>> parentToChildRolesMap = new Map<Id,List<RoleInfo>>();
        for(UserRole role: allRoles) {
            parentToChildRolesMap.put(role.Id, RoleUtils.getChildRoles(role.Id, allRoles));
        }
        List<RoleInfo> roleInfoList = new List<RoleInfo>();
        roleInfoList.add(new RoleInfo(topRole[0].Id, topRole[0].Name,
                            topRole[0].Name, parentToChildRolesMap.get(topRole[0].Id)));
        return JSON.serialize(roleInfoList, true); 
            //return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<string> getUsers(String roleName){
        try {
            List<String> nameList = new List<String>();
            List<UserRole> userRol = [SELECT Id,Name FROM UserRole WHERE Name = :roleName];
            List<User> Roles = [SELECT Id,Name,UserRoleId FROM User
                                    WHERE UserRoleId IN :userRol];
            
            for(User us : Roles){
                nameList.add(us.Name);
            }

            return nameList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}