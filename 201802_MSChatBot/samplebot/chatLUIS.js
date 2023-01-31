var restify = require('restify');
var builder = require('botbuilder');

// Setup Restify Server
var server = restify.createServer();
server.listen(process.env.port || process.env.PORT || 3978, function () {
    console.log('%s listening to %s', server.name, server.url);
});

// Create chat connector for communicating with the Bot Framework Service
var connector = new builder.ChatConnector({
    appId: process.env.MicrosoftAppId,
    appPassword: process.env.MicrosoftAppPassword,
});

// Listen for messages from users 
server.post('/api/messages', connector.listen());

// Create your bot with a function to receive messages from the user
// This default message handler is invoked if the user's utterance doesn't
// match any intents handled by other dialogs.
var bot = new builder.UniversalBot(connector, function (session, args) {
    session.send('You reached the default message handler. You said \'%s\'.', session.message.text);
});

// Make sure you add code to validate these fields
var luisAppId = process.env.LUIS_APP_ID;
var luisAPIKey = process.env.LUIS_SUBSCRIPTION_KEY;
var luisAPIHostName = process.env.LuisAPIHostName || 'eastasia.api.cognitive.microsoft.com';

const LuisModelUrl = 'https://' + luisAPIHostName + '/luis/v2.0/apps/' + luisAppId + '?subscription-key=' + luisAPIKey;

// Main dialog with LUIS
var recognizer = new builder.LuisRecognizer(LuisModelUrl);

// Add the recognizer to the bot
bot.recognizer(recognizer);

bot.dialog('getWeather',
    (session, args) => {
        // Resolve and store any  entity passed from LUIS.
        var intent = args.intent;
        var date = builder.EntityRecognizer.findEntity(intent.entities, 'getWeather.date');
        var place = builder.EntityRecognizer.findEntity(intent.entities, 'getWeather.place');

        // Turn on a specific device if a device entity is detected by LUIS
        if (date) {
            session.send('Date:%s.', date.entity);
            // Put your code here for calling the IoT web service that turns on a device
        } else if (place) {
            // Assuming turning on lights is the default
            session.send('Place:%s.', place.entity);
            // Put your code here for calling the IoT web service that turns on a device
        }
        session.endDialog();
    }
).triggerAction({
    matches: 'getWeather'
})

bot.dialog('aaa',
    (session, args) => {
        // Resolve and store any  entity passed from LUIS.
        var intent = args.intent;
        var date = builder.EntityRecognizer.findEntity(intent.entities, 'getWeather.date');
        var place = builder.EntityRecognizer.findEntity(intent.entities, 'getWeather.place');

        // Turn on a specific device if a device entity is detected by LUIS
        if (date) {
            session.send('Date:%s.', date.entity);
            // Put your code here for calling the IoT web service that turns on a device
        } else if (place) {
            // Assuming turning on lights is the default
            session.send('Place:%s.', place.entity);
            // Put your code here for calling the IoT web service that turns on a device
        }
        session.endDialog();
    }
).triggerAction({
    matches: 'getWeather'
})