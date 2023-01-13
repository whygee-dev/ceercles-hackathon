String createUserProfile = """
  mutation CreateUserProfile(\$data: CreateUserProfileInput!) {
    createUserProfile(data: \$data) {
      userId
      birthday
      gender
    }
  }
""";
