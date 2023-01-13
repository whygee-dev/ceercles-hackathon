String getAllContacts =
    """
  query GetAllContacts {
    getAllContacts {
      id
      fullname
      lastMessage {
        text
        createdAt
        sender {
          id
          fullname
        }
        receiver {
          id
          fullname
        }
      }
    }
  }
""";

String getMessages =
    """
  query GetMessages(\$data: GetMessageInput!) {
    getMessages(data: \$data) {
      id
      text
      createdAt
      sender {
        id
        fullname
      }
      receiver {
        id
        fullname
      }
    }
  }
""";
