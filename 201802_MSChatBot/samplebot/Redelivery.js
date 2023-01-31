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
    appPassword: process.env.MicrosoftAppPassword
});

// Listen for messages from users 
server.post('/api/messages', connector.listen());

var inMemoryStorage = new builder.MemoryBotStorage();

// This is a dinner reservation bot that uses multiple dialogs to prompt users for input.
var bot = new builder.UniversalBot(connector, [
    function (session) {
        session.send("こちらは、再配達予約受付Botです。");
        session.beginDialog('DeliveryMenu');
    }
]).set('storage', inMemoryStorage); // Register in-memory storage 

bot.dialog('DeliveryMenu', [
    function (session) {
        builder.Prompts.number(session, "伝票番号を入力してください。");
    },
    function (session, results) {
        session.dialogData.TicketNumber = results.response;
        builder.Prompts.time(session, "配達希望日を入力してください。(例: 1 / 23)");
    },
    function (session, results) {
        session.dialogData.ReservationYear = builder.EntityRecognizer.resolveTime([results.response]).getFullYear();
        session.dialogData.ReservationMonth = builder.EntityRecognizer.resolveTime([results.response]).getMonth() + 1;
        session.dialogData.ReservationDate = builder.EntityRecognizer.resolveTime([results.response]).getDate();
        builder.Prompts.choice(session, "配達希望時間帯を選択してください。", "9:00 - 12:00|14:00 - 16:00|16:00 - 18:00|18:00 - 21:00", { listStyle: 3 });
    },
    function (session, results) {
        session.dialogData.TimeZone = results.response.entity;
        builder.Prompts.number(session, "電話番号を入力してください。");
    },
    function (session, results) {
        session.dialogData.TelephoneNumber = results.response;

        // Confirm Reservation
        session.send(`伝票番号: ${session.dialogData.TicketNumber} <br/>配達日: ${session.dialogData.ReservationYear}年 ${session.dialogData.ReservationMonth}月 ${session.dialogData.ReservationDate}日 <br/>配達時間帯: ${session.dialogData.TimeZone} <br/>電話番号: ${session.dialogData.TelephoneNumber}`);
        builder.Prompts.confirm(session, "以上の内容で受付を完了してよろしいですか？ (Yes/No)");
    },
    function (session, results) {
        if (results.response) {
            session.send(`再配達の予約受付が完了致しました。ご利用ありがとうございました。`);
            session.endDialog();
        } else {
            session.send("申し訳ございませんが、再入力をお願いいたします。");
            session.replaceDialog('DeliveryMenu', { reprompt: true });
        }
    }
]);

// The dialog stack is cleared and this dialog is invoked when the user enters 'help'.
bot.dialog('help', function (session, args, next) {
    session.endDialog("This is a bot that can help you make a delivery reservation. <br/>Please say 'next' to continue");
})
    .triggerAction({
        matches: /^help$/i,
        onSelectAction: (session, args, next) => {
            // Add the help dialog to the dialog stack 
            // (override the default behavior of replacing the stack)
            session.beginDialog(args.action, args);
        }
    });

//https://docs.microsoft.com/en-us/bot-framework/nodejs/bot-builder-nodejs-dialog-manage-conversation-flow