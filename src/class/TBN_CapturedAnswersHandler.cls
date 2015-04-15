/*
@ClassName    : TBN_CapturedAnswersHandler 
@CreatedOn    : 14/April/2015
@ModifiedBy   : Ranjitha
@Description  : 
*/
public with sharing class TBN_CapturedAnswersHandler
 {
 
    list<Question__c> lstQuestions          {   get;set;    }
    Id OppId;  
   //constructor class TBN_CapturedAnswersHandler 
    public TBN_CapturedAnswersHandler(ApexPages.StandardController Ctrl)
     {
       OppId = Ctrl.getId();
       lstQuestions = new list<Question__c>();
       fetchProducts();
     }
 /*
@MethodName : fetchProducts 
@Description: This method is used to fetch the Products, for the productGroups which in turn will fetch the Question and Answer 
*/
/*
     public void fetchProducts()
     {
        set<Id>setProductId = new set<Id>();        //set to store the ProductId
        set<Id>setProductGroupId = new set<Id>();   //set to store the ProductGroup Id
        set<Id>setAnswerId = new set<Id>();         //Set to store the Answer Id
       Map<Id, list<Question__c>> MaptoPstteam = new Map<Id, list<Question__c>>();
        
         for(OpportunityLineItem  Objoli : [ Select Product2Id ,OpportunityId 
                                             From OpportunityLineItem 
                                             where OpportunityId=: OppId]) {
               setProductId.add(Objoli.Product2Id);
               system.debug('==========setProductId==========='+setProductId);             
         }
         
         for(Product2 objproduct: [ Select Id,Name,ProductGroup__c
                                    From Product2
                                    where Id =: setProductId] )
          {
            setProductGroupId.add(objproduct.ProductGroup__c);
            system.debug('==========setProductGroupId==========='+setProductGroupId);  
          } 
          
          for(Question__c objquestion: [select Name, QuestionText__c,ProductGroup__c,RecordTypeId
	                                    From Question__c
	                                    where ProductGroup__c =: setProductGroupId])
         {
            //mapQuestionProductGroup.put(objquestion.Id,objquestion.ProductGroup__c ); 
            lstQuestions.add(objquestion.Id);
            system.debug('==========mapQuestionProductGroup==========='+mapQuestionProductGroup);                       
         } 
          for(Answer__c objanswer: [ Select Id,RecordTypeId, Question__c, PicklistAnswer__c, ParagraphText__c,BooleanAnswer__c,Product__c  
                                     From Answer__c
                                     where Product__c=:setProductId AND Question__c=:mapQuestionProductGroup.keyset() ])  
         {
         	setAnswerId.add(objanswer.Id);
         	system.debug('==========setAnswerId==========='+setAnswerId);    
         }
         for(ProductGroup__c objProductGroups: [Select   ])
            
     }
     */

}