public with sharing class SOSLRecipes {
  public static List<List<SObject>> basicSOSLSearch() {
    String keyword = 'Kansas';
    List<List<SObject>> searchResults = [
      FIND :keyword
      IN ALL FIELDS
      RETURNING Account(Name), Contact(LastName, Account.name)
    ];
    return searchResults;
  }
  public static List<List<SObject>> nameFieldSearch() {
    String keyword = 'Alaska';
    List<List<SObject>> searchResults = [
      FIND :keyword
      IN NAME FIELDS
      RETURNING Account(Name), Contact(LastName, Account.name)
    ];
    return searchResults;
  }
}
