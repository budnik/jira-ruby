module JIRA
  module Resource

    class UserFactory < JIRA::BaseFactory # :nodoc:
    end

    class User < JIRA::Base
      def self.singular_path(client, key, prefix = '/')
        collection_path(client, prefix) + '?username=' + key
      end

      def self.find_by_project(client, key, prefix = '/')
        url = collection_path(client, prefix) + "/assignable/search?project=" + key
        response = client.get(url)
        json = parse_json(response.body)
        json.map do |user|
          client.User.build(user)
        end
      end

    end

  end
end
