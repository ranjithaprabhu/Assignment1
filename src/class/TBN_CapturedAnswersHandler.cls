/*
@ClassName    : TBN_CapturedAnswersHandler 
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description  : This class is use to the get all the questions that are related to the Products through OpportunityLineItem 
*/
public with sharing class TBN_CapturedAnswersHandler
 {
    Id OppId;                                          //Opportunity Id from the standard controller
    public List<QuestionWrapper> lstQuestionWrapper   {get; set;}
    
   //constructor class TBN_CapturedAnswersHandler 
    public TBN_CapturedAnswersHandler(ApexPages.StandardController Ctrl)
     {
        OppId = Ctrl.getId();  
        lstQuestions = new list<Question__c>();
        fetchProducts();
     }
     
/*
@ClassName    : QuestionWrapper
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description  : Controller check which questions are can be displayed.
*/
 
 public class QuestionWrapper
 {
     List<QuestionWrapper> lstQuestionWrapper   {	get; set;	}
     public Product2 Name;                      {	get; set;	}
     public Answer__c objAnswer;                {	get;set;	}
                    
 	 public QuestionWrapper(ProductName, QuestionText__c, Answer__c objAnswer)
 	 {
 	    this.ProductName = ProductName;
 	 	Answer__c objAnswer = new Answer__c();
 	 	this.QuestionText__c = QuestionText__c;
 	 }
 }  
     
/*
@MethodName : fetchProducts 
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description: This method is used to fetch the Products, for the productGroups which in turn will fetch the Question and Answer 
*/

     public void fetchProducts()
     {
        List<Product2>LstProducts = new list<Product2>();        //list of all the Products
        set<Id>setProductId = new set<Id>();                     //set to store the ProductId     
        set<Id>setProductGroupId = new set<Id>();               //set to store the ProductGroup Id
        set<Id>setAnswerId = new set<Id>();                     //set to store the Answer Id
        Map<Id, list<Product2>>mapProductIdtoProductGroup  = new Map<Id, list<Product2>>();
     
      
        //Iterate over OpportunityLineItem to get the Unique  set of ProductId 
         for(OpportunityLineItem  Objoli : [ Select Product2Id ,OpportunityId 
                                             From OpportunityLineItem 
                                             where OpportunityId=: OppId])
          {
               setProductId.add(Objoli.Product2Id);
                      
         }
         
         //Itearte over the Products to get the list of Products LstProducts
         for(Product2 objproduct: [ Select Id,Name,ProductGroup__c
                                    From Product2
                                    where Id =: setProductId] )
          {
            LstProducts.add(objproduct.ProductGroup__c);
         
          } 
          
          for(Product2 objproduct : LstProducts)
          {
          	//If the map does not contain ProductGroup__c 
          	if(!mapProductIdtoProductGroup.containskey(objproduct.ProductGroup__c))
          	{
          		mapProductIdtoProductGroup.put(objproduct.ProductGroup__c, new list<Product2> {objproduct});
          	}
          	else
          	{
          		mapProductIdtoProductGroup.get(objproduct.ProductGroup__c).put(objproduct);
          	}
          }
          
          //Iterate over the Question__c where ProductGroup__c is present  on  mapProductIdtoProductGroup.keyset()
           for(Question__c objquestion: [ select Name, QuestionText__c,QuestionType__c,ProductGroup__c,QuestionPicklist__c,RecordTypeId
	                                      From Question__c
	                                      where ProductGroup__c =: mapProductIdtoProductGroup.keyset() ])
              {
              		  Answer__c objAnswer = new Answer__c();
                      lstQuestionWrapper.add(new QuestionWrapper(ProductName, QuestionText__c, objAnswer)); 	
              }
       }
/*
* @MethodName   : save()
* @CreatedOn    : 15/April/2015
* @CreatedBy    : Ranjitha
* @Description  : Whenever a user clicks save button, a New record must be created along with the  respective Question__c,Opportunity and Product2
*/
       public void save()
       {
       	  list<Answer__c>lstAnswerstosave= new list<Answer__c>();
       	  for(Integer i=0; i<lstwrapperAccountsize; i++)
       	  {
       	  	if(lstwrapperAccountsize)
       	  }
       }

