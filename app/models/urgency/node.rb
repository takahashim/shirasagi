# coding: utf-8
module Urgency::Node
  class Base
    include Cms::Node::Model

    default_scope ->{ where(route: /^urgency\//) }
  end

  class Layout
    include Cms::Node::Model

    default_scope ->{ where(route: "urgency/layout") }
  end
end
