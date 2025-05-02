public with sharing class CustomerTimelineController {
    @AuraEnabled(cacheable=true)
    public static List<TimelineEventWrapper> getTimelineEvents(Id recordId) {
        List<TimelineEventWrapper> timeline = new List<TimelineEventWrapper>();

        for (Case c : [SELECT Id, Subject, CreatedDate FROM Case WHERE ContactId = :recordId LIMIT 100]) {
            timeline.add(new TimelineEventWrapper('Case', c.Subject, c.CreatedDate));
        }
        for (Task t : [SELECT Id, Subject, ActivityDate FROM Task WHERE WhoId = :recordId LIMIT 100]) {
            timeline.add(new TimelineEventWrapper('Task', t.Subject, t.ActivityDate));
        }
        for (Event e : [SELECT Id, Subject, StartDateTime FROM Event WHERE WhoId = :recordId LIMIT 100]) {
            timeline.add(new TimelineEventWrapper('Event', e.Subject, e.StartDateTime));
        }
        for (EmailMessage e : [SELECT Id, Subject, CreatedDate FROM EmailMessage WHERE RelatedToId = :recordId LIMIT 100]) {
            timeline.add(new TimelineEventWrapper('Email', e.Subject, e.CreatedDate));
        }

        timeline.sort((a, b) => b.date.compareTo(a.date));

        return timeline;
    }

    public class TimelineEventWrapper {
        @AuraEnabled public String type;
        @AuraEnabled public String subject;
        @AuraEnabled public Datetime date;

        public TimelineEventWrapper(String type, String subject, Datetime date) {
            this.type = type;
            this.subject = subject;
            this.date = date;
        }
    }
}