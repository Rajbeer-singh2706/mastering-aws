# Manage Glue DataBrew Recipe
As you proceed with developing your recipe, you can save your work by publishing the recipe. DataBrew maintains a list of published versions for your recipe. You can use any published version in a recipe job to transform your dataset. You can also download a copy of the recipe steps so you can reuse the recipe in other projects or other transformations.

1. Click the Publish icon at the upper right corner of you recipe work area to publish your recipe.
2. Under Version description put in Note Convert COVID testing data to time series of positive percentage in NY and CA.
3. Click the Publish button.
4. Click the RECIPES icon on the left. You will see the recipe you just published.
5. Click on the recipe name covid-testing-recipe. You will see the details of the recipe.
6. While still in recipe details, click the Action dropdown list and select Download as YAML to store the recipe locally as a yaml file. The file will look like the example below. This allows you to export and import recipes for reuse in other projects.
- Action:
    Operation: DELETE
    Parameters:
      sourceColumns: >-
        ["dateChecked","death","deathIncrease","fips","hash","hospitalized","hospitalizedIncrease","negative","negativeIncrease","pending","positive","total","totalTestResults"]
- Action:
    Operation: REMOVE_VALUES
    Parameters:
      sourceColumn: state
  ConditionExpressions:
    - Condition: IS_NOT
      Value: '["NY","CA"]'
      TargetColumn: state
- Action:
    Operation: DATE_FORMAT
    Parameters:
      dateTimeFormat: yyyy-mm-dd
      functionStepType: DATE_FORMAT
      sourceColumn: date
      targetColumn: date_formatted
- Action:
    Operation: CHANGE_DATA_TYPE
    Parameters:
      columnDataType: date
      sourceColumn: date_formatted
- Action:
    Operation: DELETE
    Parameters:
      sourceColumns: '["date"]'
- Action:
    Operation: DIVIDE
    Parameters:
      functionStepType: DIVIDE
      sourceColumn1: positiveIncrease
      sourceColumn2: totalTestResultsIncrease
      targetColumn: positiveRate
- Action:
    Operation: MULTIPLY
    Parameters:
      functionStepType: MULTIPLY
      sourceColumn1: positiveRate
      targetColumn: positivePercentile
      value2: '100'
- Action:
    Operation: DELETE
    Parameters:
      sourceColumns: '["positiveIncrease","totalTestResultsIncrease","positiveRate"]'

#7. Click the RECIPES icon on the left and click the Published dropdown menu. Select All recipes. You should see both the published and working version of your recipes.