import "commonReactions/all.dsl";

context
{
    input phone: string;
    input day_of_week: string;
    input time_of_day: string;
}

start node root
{
    do
    {
        #connectSafe($phone);
        #waitForSpeech(1000);
        #sayText("Hi, this is Fast Delivery Postal Services! How may I help you today?");
        wait *;
    }
    transitions
    {
        tracking: goto tracking on #messageHasIntent("track");
        bye: goto bye on  #messageHasIntent("no") or #messageHasIntent("bye");
    }
}

node tracking
{
    do
    {
        #sayText("I'll be glad to assist with that. Could you please tell me your tracking number, please?");
        wait *;
    }
    transitions
    {
        track_number: goto track_number on #messageHasIntent("track_num");
    }
}

node track_number
{
    do
    {
     #sayText("Just one moment, let me check... Oooookay, found it. Your package is arriving on "+ $day_of_week + " just as expected. Do you have any questions?");
     wait *;
    }
    transitions
    {
        change_delivery_day: goto change_delivery_day on #messageHasIntent("change_delivery_day");
        time_of_the_day: goto time_of_the_day on #messageHasData("time_of_the_day");
        change_time_of_day: goto change_time_of_day on #messageHasIntent("change_time_of_day");
        free_delivery: goto free_delivery on #messageHasIntent("free_delivery");
        can_call: goto can_call on #messageHasIntent("can_call");
        can_help: goto can_help on #messageHasIntent("yes") or #messageHasIntent("can_help");
        bye: goto bye on #messageHasIntent("no");
    }
}

node change_delivery_day
{
    do
    {
        #sayText("Yes, absolutely. What day would you like your package to be delivered?");
        wait *;
    }
    transitions 
    {
       new_delivery_day: goto new_delivery_day on #messageHasData("day_of_week");
    }
    onexit
    {
        new_delivery_day: do 
        {
        set $day_of_week = #messageGetData("day_of_week", { value: true })[0]?.value??"";
        }
    }
}

node new_delivery_day
{ 
    do 
    { 
        #sayText("Perfect! Your package will be now delivered on " + $day_of_week + " Do you have any other questions?");
        wait *;
    }
    transitions
    {
        time_of_the_day: goto time_of_the_day on #messageHasData("time_of_day");
        change_time_of_day: goto change_time_of_day on #messageHasIntent("change_time_of_day");
        free_delivery: goto free_delivery on #messageHasIntent("free_delivery");
        can_call: goto can_call on #messageHasIntent("can_call");
        can_help: goto can_help on #messageHasIntent("yes") or #messageHasIntent("can_help");
        bye: goto bye on #messageHasIntent("no");
    }
}

node time_of_the_day
{
    do
    {
        #sayText("It looks like your package is gonna arrive in the "+ $time_of_day + ". Anything else I can help you with?");
        wait *;
    }
    transitions
    {
        change_time_of_day: goto change_time_of_day on #messageHasIntent("change_time_of_day");
        can_help: goto can_help on #messageHasIntent("yes") or #messageHasIntent("can_help");
        bye: goto bye on #messageHasIntent("no");
    }
}

node change_time_of_day
{
    do
    {
        #sayText("Sure thing! When would it be most convenient for you to receive your package?");
        wait *;
    }
    transitions 
    {
       new_delivery_time: goto new_delivery_time on #messageHasData("time_of_day");
    }
    onexit
    {
        new_delivery_time: do 
        {
        set $time_of_day = #messageGetData("time_of_day", { value: true })[0]?.value??"";
        }
    }
}

node new_delivery_time
{ 
    do 
    { 
        #sayText("You got it! You'll get your package in the " + $time_of_day + ". Any other questions?");
        wait *;
    }
    transitions
    {
        free_delivery: goto free_delivery on #messageHasIntent("free_delivery");
        can_call: goto can_call on #messageHasIntent("can_call");
        can_help: goto can_help on #messageHasIntent("yes") or #messageHasIntent("can_help");
        bye: goto bye on #messageHasIntent("no");
    }
}

node free_delivery
{
    do
    {
     #sayText("Yes, the delivery is absolitely free! May I help with anything else today?");
     wait *;
    }
    transitions
    {
        change_delivery_day: goto change_delivery_day on #messageHasIntent("change_delivery_day");
        time_of_the_day: goto time_of_the_day on #messageHasData("time_of_the_day");
        change_time_of_day: goto change_time_of_day on #messageHasIntent("change_time_of_day");
        can_call: goto can_call on #messageHasIntent("can_call");
        can_help: goto can_help on #messageHasIntent("yes") or #messageHasIntent("can_help");
        bye: goto bye on #messageHasIntent("no");
    }
}

node can_call
{
    do
    {
     #sayText("Sure thing, you'll get a call from us thirty minutes before your package is delivered. Do you have any other questions?");
     wait *;
    }
    transitions
    {
        change_delivery_day: goto change_delivery_day on #messageHasIntent("change_delivery_day");
        time_of_the_day: goto time_of_the_day on #messageHasData("time_of_the_day");
        change_time_of_day: goto change_time_of_day on #messageHasIntent("change_time_of_day");
        can_help: goto can_help on #messageHasIntent("yes") or #messageHasIntent("can_help");
        bye: goto bye on #messageHasIntent("no");
    }
}

node can_help
{
    do
    {
        #sayText("How can I help?");
        wait *;
    }
}

digression can_help
{
    conditions {on #messageHasIntent("can_help");}
    do
    {
        #sayText("How can I help?");
        wait *;
    }
}

digression bye 
{
    conditions { on #messageHasIntent("bye"); }
    do 
    {
        #sayText("Thanks for your time. Have a great day. Bye!");
        #disconnect();
        exit;
    }
}

node bye
{
    do 
    {
        #sayText("Thanks for your time. Have a great day. Bye!");
        #disconnect();
        exit;
    }
}