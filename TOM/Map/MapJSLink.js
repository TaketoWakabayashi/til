// List View – Priority Color
 
(function () { 
    // Create object that have the context information about the field that we want to change it's output render  
    var priorityFiledContext = {};
    priorityFiledContext.Templates = {};
    priorityFiledContext.Templates.Fields = {
        // Apply the new rendering for Priority field on List View 
        "_x30b9__x30c6__x30fc__x30bf__x30": { "View": priorityFiledTemplate }
    };
 
    SPClientTemplates.TemplateManager.RegisterTemplateOverrides(priorityFiledContext); 
})(); 
 
// This function provides the rendering logic for list view 
function priorityFiledTemplate(ctx) { 
 
    var priority = ctx.CurrentItem[ctx.CurrentFieldSchema.Name]; 
 
    // Return html element with appropriate color based on priority value 
    switch (priority) { 
        case "はい":
            return "<span style='color : red'>" + priority + "</span>"; 
            break;
        case "いいえ": 
            return "<span style='color : black'>" + priority + "</span>"; 
            break;
    } 
}