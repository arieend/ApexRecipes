public with sharing class SOSLRecipes {
  public static List<List<SObject>> basicSOSLSearch() {
    String keyword = 'Kansas';
    List<List<SObject>> searchResults = [
      FIND :keyword
      IN ALL FIELDS
      RETURNING Account(Name), Contact(lastName, account.name)
    ];
    return searchResults;
  }
}
