/*
you have to to have all source csv files uploaded first
*/


SELECT 
substring([ID_CRM],len([Poverty_Code])+1,len([ID_CRM])-len(Income_Level)-len([Poverty_Code])) as UniqueID,
a.*, b.*, c.*,d.*
into #sourcedata
FROM [DataScientist].[dbo].[sales_model] a
left join [DataScientist].[dbo].[crm_model] b on substring([ID_CRM],len([Poverty_Code])+1,len([ID_CRM])-len(Income_Level)-len([Poverty_Code])) = substring(ID_Sales,len(Program_Code)+1,len(ID_Sales)-len(Travel_Type)-len(Program_Code))
left join [DataScientist].[dbo].[finance_model] c on case when left([ID_FINANCE],len([Special_Pay])) = [Special_Pay] then substring([ID_FINANCE],len([Special_Pay])+1,len([ID_FINANCE])-len([Special_Pay])) else ID_FINANCE end = substring(ID_Sales,len(Program_Code)+1,len(ID_Sales)-len(Travel_Type)-len(Program_Code))
left join [DataScientist].[dbo].[finance_model] d on d.[ID_SALES] = a.[ID_SALES]



  /* check on crm_model */
  select * from [DataScientist].[dbo].[crm_model] 
  where left([ID_CRM],len([Poverty_Code])) <> [Poverty_Code] 
  or right([ID_CRM],len(Income_Level)) <> Income_Level

  /* check on sales_model  - ok, we have 0 instead of Travel_type but logic still works*/
  select * from [DataScientist].[dbo].[sales_model] 
  where left(ID_Sales,len(Program_Code)) <> Program_Code 
  or right(ID_Sales,len(Travel_Type)) <> Travel_Type

  /* check on finance_model */
  select * from [DataScientist].[dbo].[finance_model] 
  where left([ID_FINANCE],len([Special_Pay])) <> [Special_Pay] 
  
  /* crm_model id */
  select distinct substring([ID_CRM],len([Poverty_Code])+1,len([ID_CRM])-len(Income_Level)-len([Poverty_Code])) as ID, [ID_CRM]  FROM [DataScientist].[dbo].[crm_model]
  union
  /* sales_model id */
  select distinct substring(ID_Sales,len(Program_Code)+1,len(ID_Sales)-len(Travel_Type)-len(Program_Code)) as ID, ID_Sales FROM [DataScientist].[dbo].[sales_model]
  union
  /* finance_model id */
  select distinct case when left([ID_FINANCE],len([Special_Pay])) = [Special_Pay] then substring([ID_FINANCE],len([Special_Pay])+1,len([ID_FINANCE])-len([Special_Pay])) else ID_FINANCE end as ID, ID_FINANCE FROM [DataScientist].[dbo].[finance_model]
  
