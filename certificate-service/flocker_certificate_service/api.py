from twisted.web import server, resource
from twisted.internet import reactor

class AgentResource(resource.Resource):
    isLeaf = True

    def __init__(self, *args, **kw):
        return resource.Resource.__init__(self, *args, **kw)

    def render_POST(self, request):
        pass

class ControlResource(resource.Resource):
    isLeaf = True

    def __init__(self, *args, **kw):
        return resource.Resource.__init__(self, *args, **kw)

    def render_POST(self, request):
        pass

def getAdapter():
    v1 = resource.Resource()

    v1.putChild("control", ControlResource())
    v1.putChild("agent", AgentResource())

    root = resource.Resource()
    root.putChild("v1", v1)

    site = server.Site(root)
    return site

def main():
    reactor.listenTCP(8123, getAdapter())
    reactor.run()
