public with sharing class SOQLRecipiesTestHelper {
  public static Account createAccount(Boolean setCountry, String country) {
    Account account = genAccountWithOptions(setCountry, country);
    insert account;
    return account;
  }
  public static void createAccounts(
    Boolean setCountry,
    String country,
    Integer numberOfAccounts
  ) {
    insert genXnumberOfAccountWithOptions(
      setCountry,
      country,
      numberOfAccounts
    );
  }
  public static List<Account> genXnumberOfAccountWithOptions(
    Boolean setCountry,
    String country,
    Integer numberOfAccounts
  ) {
    List<Account> acctList = new List<Account>();
    for (Integer i = 0; i < numberOfAccounts; i++) {
      acctList.add(genAccountWithOptions(setCountry, country));
    }
    return acctList;
  }
  public static Account genAccountWithOptions(
    Boolean setCountry,
    String country
  ) {
    Account acct = new Account(
      Name = 'The Test Account of Awesomeness' + Crypto.getRandomInteger(),
      ShippingStreet = '123 Sessame St.',
      ShippingCity = 'Wehawkin'
    );
    if (setCountry) {
      acct.ShippingCountry = country;
    }
    return acct;
  }
  public static Contact genContactForAccount(ID acctID) {
    return new Contact(
      AccountID = acctID,
      LastName = 'Spectecular',
      FirstName = String.valueOf(Crypto.getRandomInteger())
    );
  }
  public static User createUser(Boolean ins, String profileName) {
    Profile standartProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = :profileName
    ];
    User contextuser = new User(
      Alias = 'standt',
      Email = 'arieend@apexrecipes.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = standartProfile.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'arieend@apexrecipes.com'
    );
    if (ins) {
      insert contextuser;
    }
    return contextuser;
  }
}
