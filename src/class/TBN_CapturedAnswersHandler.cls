/*
@ClassName    : TBN_CapturedAnswersHandler 
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description  : This class is use to the get all the questions that are related to the Products through OpportunityLineItem 
*/
public with sharing class TBN_CapturedAnswersHandler
 {
    private map<Id , Answer__c> mapQuestionToAnswers           {	get;set;	} 
    private map<Id , Question__c> mapIdToQuestions             {	get;set;	}
    public List<DisplayWrapperClass> lstDisplayWrapper         {	get;set;	}
    private map<Id , Set<Answer__c>> mapProductToAnswerSet     {	get;set;	}
    private map<ID , Set<Id>> mapProductIDToQuestions          {	get;set;	}
    private map<Id , String> mapIdToProductName                {	get;set;	}
    public map<Product2 , List<DisplayWrapperClass>> mapProductIdToQA   {	get;set;	}
    public Id OppId                                            {	get;set;	}
     
     
/*
@ClassName    : DisplayWrapperClass
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description  : Wrapper class to check which questions to be displayed.
*/
     public class DisplayWrapperClass
     {
         public String strQuestion    {		get;set;	}
         public Boolean isComment     {		get;set;	}
         public Boolean isPicklist    {		get;set;	}
         public Boolean isCheckbox    {		get;set;	}
         public String strComment     {		get;set;	}
         public Boolean isYes         {		get;set;	}
         public Boolean isNo          {		get;set;	}
         public String strPicklist    {		get;set;	}
         
         public DisplayWrapperClass(String strQuestion , String strComment , Boolean isYes , Boolean isNO , String isPicklist , String strAnsType)
         {
             this.isComment=false;
             this.isPicklist=false;
             this.isCheckbox=false;
         }
     }
     
 
   //constructor class TBN_CapturedAnswersHandler 
    public TBN_CapturedAnswersHandler(ApexPages.StandardController Ctrl)
     {
       OppId = Ctrl.getId();
       mapProductIdToQA = new map<Product2 , List<DisplayWrapperClass>>();
       mapQuestionToAnswers = new map<Id , Answer__c>();
       lstDisplayWrapper = new List<DisplayWrapperClass>();
       fetchQuestionAnswer();
     }
     
/*
@MethodName : fetchQuestionAnswer
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description: This method is used to fetch the Products, for the productGroups which in turn will fetch the Question and Answer 
*/

private void fetchQuestionAnswer()
{
    map<Id , Id > mapProductIdToProductGroup = new map<Id , Id>();
    mapIdToProductName = new map<Id ,String>();
    map<Id , String> mapIdtoProductGroup = new map<Id ,String>();
    
    for(OpportunityLineItem objOLI : [Select Id , Product2Id , Product2.ProductGroup__r.Name , Product2.ProductGroup__c , Product2.Name from OpportunityLineItem where OpportunityId =: OppId])
    {
        mapIdToProductName.put(objOLI.Product2Id , objOLI.Product2.Name);
        mapProductIdToProductGroup.put(objOLI.Product2Id , objOLI.Product2.ProductGroup__c);
        mapIdtoProductGroup.put(objOLI.Product2.ProductGroup__c , objOLI.Product2.ProductGroup__r.Name);
       
    }
    
    mapProductToAnswerSet = new map<Id , Set<Answer__c>>();
    mapProductIDToQuestions = new map<Id , Set<Id>>();
    mapIdToQuestions = new map<Id , Question__c>([Select Id , QuestionText__c , QuestionType__c from Question__c where ProductGroup__c IN :mapIdtoProductGroup.keySet()]);
    map<Id , Product2 > mapIdToProduct = new map<Id , Product2>([Select Id , Name from Product2 where Id IN:mapIdToProductName.keySet()]);
    
    for(Answer__c objAnswer : [Select Id , BooleanAnswer__c , Product__c , ParagraphText__c , PicklistAnswer__c , Question__c from Answer__c where (Question__c IN :mapIdToQuestions.keySet() AND Opportunity__c =: OppId)])
    {
        if(!mapProductToAnswerSet.containsKey(objAnswer.Product__c))
        {
            mapProductToAnswerSet.put(objAnswer.Product__c , new set<Answer__c>{objAnswer});
        }
        mapProductToAnswerSet.get(objAnswer.Product__c).add(objAnswer);
        if(mapProductIDToQuestions.containsKey(objAnswer.Product__c))
        {
            mapProductIDToQuestions.put(objAnswer.Product__c , new set<Id>{objAnswer.Question__c});
        }
        mapProductIDToQuestions.get(objAnswer.Product__c).add(objAnswer.Question__c);
    }
}

/*
@MethodName : onloadInsertAnswers
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description: This method is used to load the answers everytime the page is loaded again
*/
public void onloadInsertAnswers()
{
    List<Answer__c> lstAnswerToInsert = new List<Answer__c>();
    for(Id objProductID : mapIdToProductName.keySet())
    {
        for(Id QuestionId : mapIdToQuestions.keySet())
        {
            if(!mapProductToAnswerSet.containsKey(objProductID))
            {
                lstAnswerToInsert.add(new Answer__c(Product__c = objProductID , Question__c = QuestionId , Opportunity__c = OppId));
            }
            else
            {
                if(!mapProductIDToQuestions.get(objProductID).contains(QuestionId))
                {
                    lstAnswerToInsert.add(new Answer__c(Product__c = objProductID , Question__c = QuestionId , Opportunity__c = OppId));
                }
            }
        }
    }
    
    if(!lstAnswerToInsert.isEmpty())
        insert lstAnswerToInsert;
}
 /*
@MethodName : fetchProducts 
@Description: This method is used to fetch the Products, for the productGroups which in turn will fetch the Question and Answer 
*/
/*
     public void fetchProducts()
     {
        set<Id>setProductId = new set<Id>(); 
        set<Id>setProductGroupId = new set<Id>();
        set<Id>setAnswerId = new set<Id>();
        map<Id,Id>mapQuestionProductGroup = new map<Id,Id>();
        
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
            mapQuestionProductGroup.put(objquestion.Id,objquestion.ProductGroup__c ); 
            system.debug('==========mapQuestionProductGroup==========='+mapQuestionProductGroup);                       
         } 
          for(Answer__c objanswer: [ Select Id,RecordTypeId, Question__c, PicklistAnswer__c, ParagraphText__c,BooleanAnswer__c,Product__c  
                                     From Answer__c
                                     where Product__c=:setProductId AND Question__c=:mapQuestionProductGroup.keyset() ])  
         {
            setAnswerId.add(objanswer.Id);
            system.debug('==========setAnswerId==========='+setAnswerId);    
         }
            
     }
     */

}