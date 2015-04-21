/*
@ClassName    : TBN_CapturedAnswersHandler 
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description  : This class is use to the get all the questions that are related to the Products through OpportunityLineItem 
*/
public with sharing class TBN_CapturedAnswersHandler
 {
    public map<Id , Question__c> mapIdToQuestions                   {	get;set;	}
    public map<Id , List<DisplayWrapperClass>> mapProductGrpToQA    {	get;set;	}
    public Id OppId                                                 {	get;set;	}
    public map<Id , List<Question__c>> mapProductToQuestion         {   get;set;    }
	public map<Id , Answer__c> mapQuestionToAnswer                  {   get;set;    }
	public map<Id , String> mapIdtoProductGroup                     {	get;set;	}
    Public  String Picklist                                         {	get;set;	}
     
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
         public Id idQuestion         {     get;set;    }

         
         public DisplayWrapperClass(Id idQuestion , String strQuestion , String strComment , Boolean isBool , String strPicklist , String strAnsType)
         {
             this.idQuestion = idQuestion;
             this.isComment=false;
             this.isPicklist=false;
             this.isCheckbox=false;
             if(strAnsType == 'Text')
             {
                 this.isComment = true;
             }
             if(strAnsType == 'Picklist')
             {
                 this.isPicklist = true;
             }
             if(strAnsType == 'Boolean')
             {
                 this.isCheckbox = true;
             }
             if(strQuestion != NULL)
             {
                this.strQuestion = strQuestion;
             }
             else
             {
                this.strQuestion = ' '; 
             }
             
             if(strComment == NULL)
             {
                 this.strComment = ' ';
             }
             else
             {
                this.strComment = strComment;
             }
             
             this.isYes = isBool;
             
             if(strPicklist != NULL)
             {
                this.strPicklist = strPicklist;
             }
             else
             {
                 this.strPicklist = ' ';
             }
         }    
     }
 
   //constructor class TBN_CapturedAnswersHandler 
    public TBN_CapturedAnswersHandler(ApexPages.StandardController Ctrl)
     {
       OppId = Ctrl.getId();
       mapProductGrpToQA = new map<Id , list<DisplayWrapperClass>>();
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
    mapIdtoProductGroup = new map<Id ,String>();
    
    for(OpportunityLineItem objOLI : [Select Id , Product2Id , Product2.ProductGroup__r.Name , Product2.ProductGroup__c , Product2.Name from OpportunityLineItem where OpportunityId =: OppId])
    {
        mapIdtoProductGroup.put(objOLI.Product2.ProductGroup__c , objOLI.Product2.ProductGroup__r.Name);
    }
    
    mapIdToQuestions = new map<Id , Question__c>([Select Id , QuestionText__c ,QuestionType__c , ProductGroup__c from Question__c where ProductGroup__c IN :mapIdtoProductGroup.keySet()]);
    mapProductToQuestion = new map<Id , List<Question__c>>();
    mapQuestionToAnswer = new map<Id ,Answer__c>();    
    for(Question__c objQuestion : mapIdToQuestions.values())
    {
        if(!mapProductToQuestion.containsKey(objQuestion.ProductGroup__c))
        {
            mapProductToQuestion.put(objQuestion.ProductGroup__c , new List<Question__c>{objQuestion});
        }
        else
        {
            mapProductToQuestion.get(objQuestion.ProductGroup__c).add(objQuestion);
        }
    }
    for(Answer__c objAnswer : [Select Id , BooleanAnswer__c , Product__c , Question__r.ProductGroup__c , ParagraphText__c , PicklistAnswer__c , Question__c from Answer__c where (Question__c IN :mapIdToQuestions.keySet() AND Opportunity__c =: OppId)])
    {
        mapQuestionToAnswer.put(objAnswer.Question__c , objAnswer);
    }
    for(Id idProductGrp : mapProductToQuestion.keySet())
    {
        for(Question__c objQuestion : mapProductToQuestion.get(idProductGrp))
        {
            if(mapQuestionToAnswer.containsKey(objQuestion.Id))
            {
                List<DisplayWrapperClass> lstWrapper = new List<DisplayWrapperClass>();
                if(!mapProductGrpToQA.containsKey(idProductGrp))
                {
                    DisplayWrapperClass objWrapper = new DisplayWrapperClass(objQuestion.Id , mapIdToQuestions.get(objQuestion.Id).QuestionText__c , 
                                                                                                                mapQuestionToAnswer.get(objQuestion.Id).ParagraphText__c ,
                                                                                                                mapQuestionToAnswer.get(objQuestion.Id).BooleanAnswer__c , 
                                                                                                                mapQuestionToAnswer.get(objQuestion.Id).PicklistAnswer__c,
                                                                                                                mapIdToQuestions.get(objQuestion.Id).QuestionType__c );
                    lstWrapper.add(objWrapper);
                    mapProductGrpToQA.put(idProductGrp , lstWrapper);         
                }
                else
                {
                    lstWrapper.addAll(mapProductGrpToQA.get(idProductGrp));
                    DisplayWrapperClass objWrapper = new DisplayWrapperClass(objQuestion.Id , mapIdToQuestions.get(objQuestion.Id).QuestionText__c , 
                                                                                                                mapQuestionToAnswer.get(objQuestion.Id).ParagraphText__c ,
                                                                                                                mapQuestionToAnswer.get(objQuestion.Id).BooleanAnswer__c , 
                                                                                                                mapQuestionToAnswer.get(objQuestion.Id).PicklistAnswer__c,
                                                                                                                mapIdToQuestions.get(objQuestion.Id).QuestionType__c);
                    lstWrapper.add(objWrapper);
                    mapProductGrpToQA.put(idProductGrp , lstWrapper);
                }
            }
            else
            {
               List<DisplayWrapperClass> lstWrapper = new List<DisplayWrapperClass>();
               if(!mapProductGrpToQA.containsKey(idProductGrp))
                {
                    DisplayWrapperClass objWrapper = new DisplayWrapperClass(objQuestion.Id , mapIdToQuestions.get(objQuestion.Id).QuestionText__c , 
                                                                                                                ' ' ,
                                                                                                                false, 
                                                                                                                ' ',
                                                                                                                mapIdToQuestions.get(objQuestion.Id).QuestionType__c );
                    lstWrapper.add(objWrapper);                                                                                            
                    mapProductGrpToQA.put(idProductGrp , lstWrapper);         
                }
                else
                {
                    lstWrapper.addAll(mapProductGrpToQA.get(idProductGrp));
                    DIsplayWrapperClass objWrapper =  new DisplayWrapperClass(objQuestion.Id , mapIdToQuestions.get(objQuestion.Id).QuestionText__c , 
                                                                                                                ' ' ,
                                                                                                                false, 
                                                                                                                ' ',
                                                                                                                mapIdToQuestions.get(objQuestion.Id).QuestionType__c);
                    lstWrapper.add(objWrapper);
                    mapProductGrpToQA.put(idProductGrp , lstWrapper);         
                } 
            }
        }
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
	    for(Id objProductID : mapProductToQuestion.keySet())
	    {
	        for(Question__c objQuest : mapProductToQuestion.get(objProductID))
	        {
	            if(!mapQuestionToAnswer.containsKey(objQuest.Id))
	            {
	                lstAnswerToInsert.add(new Answer__c(Question__c = objQuest.Id , Opportunity__c = OppId));
	            }
	        }
	    }
	    if(!lstAnswerToInsert.isEmpty())
	        insert lstAnswerToInsert;
	}
/*
@MethodName : PageReference
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description: This method is used to select the type of Answer
*/	
public string selectedValue {get;set;}   
     public PageReference test() {
     	
        if(selectedValue == 'Yes'){
        	
        	//Answer__c objAns = new Answer__c(Yes__c == true); 
        //logic here
        } else if (selectedValue == 'No'){
        	//Answer__c.No__c = true;
        // logic here
        } return null;
    }
                
    	public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options;
} 
/*
@MethodName : PageReference
@CreatedOn    : 15/April/2015
@ModifiedBy   : Ranjitha
@Description: This method is used to Save,Edit  and Cancel functionalities
*/	         
public void save()    
{   
    system.debug('======>' + mapProductGrpToQA);
    List<Answer__c> lstAnswerToUpdate = [Select Id , BooleanAnswer__c , Product__c , Question__r.ProductGroup__c , ParagraphText__c , PicklistAnswer__c , Question__c from Answer__c where (Question__c IN :mapIdToQuestions.keySet() AND Opportunity__c =: OppId)]; 
    for(Id objProductGrp : mapProductGrpToQA.keySet())
    {
       for(DisplayWrapperClass Wrapper : mapProductGrpToQA.get(objProductGrp))
       {
           for(Answer__c objAnswer : lstAnswerToUpdate)
           {
               if(objProductGrp == objAnswer.Question__r.ProductGroup__c && objAnswer.Question__c == Wrapper.idQuestion  )
               {
                   objAnswer.BooleanAnswer__c = Wrapper.isYes;
                   objAnswer.ParagraphText__c = Wrapper.strComment;
                   objAnswer.PicklistAnswer__c = Wrapper.strPicklist;
               }
           }
       }
    }

    update lstAnswerToUpdate;
}
	     
public Pagereference cancel()
{
   PageReference newpage = new Pagereference('/' + OppId);
   newpage.setRedirect(true);
   return newpage;
}
        public PageReference test1() 
        {
            return null;
        }
            public List<SelectOption> getItems1()
             {
	            List<SelectOption> options = new List<SelectOption>();
	            options.add(new SelectOption('Violet','Violet'));
	            options.add(new SelectOption('Indigo','Indigo'));
	            options.add(new SelectOption('Blue','Blue'));
	            options.add(new SelectOption('Green','Green'));
	            options.add(new SelectOption('Yellow','Yellow'));
	            options.add(new SelectOption('Orange','Orange'));
	            options.add(new SelectOption('Red','Red'));
	            return options;
           }
            
    }