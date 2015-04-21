/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TBN_TestcodeforCaptureAnswers {

    static testMethod void myUnitTest() 
    {
         Opportunity  objOpp = new Opportunity ();
         objOpp.Name = 'Opportunity1';
         objOpp.StageName='Stage 0: Unqualified / Inactive';
         objOpp.CloseDate=system.today();
         Insert objOpp;
         
        Opportunity opp= new Opportunity(Name='testOpp', StageName='Prospecting',CloseDate = System.Today());
        insert opp;
       
        Product2 newProd = new Product2(Name = 'test product', family = 'test family');
         insert newProd;

         PriceBookEntry pbEntry = new PriceBookEntry(
        UnitPrice = 300,
        PriceBook2Id = [select id from PriceBook2 where isStandard = true].Id,
        Product2Id = newProd.Id,
        IsActive = true
    );

    insert pbEntry ;

    Opportunity obj1 = new Opportunity(Name='Test Demo Opportunity', StageName='Lead', CloseDate=Date.today(), Pricebook2Id=pbEntry.PriceBook2Id);   
    insert obj1;

    OpportunityLineItem oli = new OpportunityLineItem(pricebookentryid=pbEntry.Id, Quantity=1, OpportunityId=obj1.id, TotalPrice=1000);
    
      ProductGroup__c ObjProductgroup = new ProductGroup__c(Name=' PG1');
      Insert ObjProductgroup;
      
      Question__c  objquest1 = new Question__c(Name= 'Question1',ProductGroup__c=ObjProductgroup.Id, QuestionText__c='how are you', QuestionType__c='Text');
      Insert objquest1;
      Question__c  objquest2 = new Question__c(Name= 'Question2',ProductGroup__c=ObjProductgroup.Id, QuestionText__c='Will you come out', QuestionType__c='Boolean');
      Insert objquest2;
      Question__c  objquest3 = new Question__c(Name= 'Question3',ProductGroup__c=ObjProductgroup.Id, QuestionText__c='what is your fav color', QuestionType__c='Picklist');
      Insert objquest3;
      
      Answer__c objanswer1 = new Answer__c(Name='Answer1', Opportunity__c= 'opp.Id', Product__c='newProd.Id', Question__c='objquest1.Id');
      Insert objanswer1;
       Answer__c objanswer2 = new Answer__c(Name='Answer1', Opportunity__c= 'opp.Id', Product__c='newProd.Id', Question__c='objquest2.Id');
      Insert objanswer2;
       Answer__c objanswer3 = new Answer__c(Name='Answer1', Opportunity__c= 'opp.Id', Product__c='newProd.Id', Question__c='objquest3.Id');
      Insert objanswer3;
       
    }
}