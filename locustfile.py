from locust import HttpLocust, TaskSet

def segment(l):
    json = { "version": 1,
             "type": "track",
             "userId": "019mr8mf4r",
             "event": "Purchased an Item",
             "properties" : {
                "revenue": "39.95",
                "shippingMethod": "2-day"
             },
             "timestamp" : "2012-12-02T00:30:08.276Z"
    }
    l.client.post("/segment", json=json)

class UserBehavior(TaskSet):
    tasks = {segment:1}

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait=5000
    max_wait=9000